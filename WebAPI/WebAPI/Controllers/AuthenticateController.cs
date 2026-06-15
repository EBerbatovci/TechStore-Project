using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Collections.Concurrent;
using System.Security.Cryptography;
using System.Security.Claims;
using System.Text;
using WebAPI.Auth;
using WebAPI.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authorization;
using WebAPI.Data;

namespace WebAPI.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticateController : ControllerBase
    {
        private static readonly ConcurrentDictionary<string, StoredRefreshToken> RefreshTokens = new();
        private readonly UserManager<IdentityUser> _userManager;
        private readonly IConfiguration _configuration;
        private readonly TechStoreDbContext _context;
        private readonly RoleManager<IdentityRole> _roleManager;

        public AuthenticateController(
            UserManager<IdentityUser> userManager,
           RoleManager<IdentityRole> roleManager,
            IConfiguration configuration,
            TechStoreDbContext context)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _configuration = configuration;
            _context = context;
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("register")]
        public async Task<IActionResult> Register([FromBody] RegisterModel registerModel)
        {
            if (ModelState.IsValid)
            {
                var perdoruesiEkziston = await _userManager.FindByEmailAsync(registerModel.Email);

                if (perdoruesiEkziston != null)
                {
                    return BadRequest(new AuthResults()
                    {
                        Result = false,
                        Errors = new List<string>()
                        {
                            "Email already exists"
                        }
                    });
                }

                var perdoruesiIRI = new IdentityUser()
                {
                    Email = registerModel.Email,
                    UserName = registerModel.Username,
                    PhoneNumber = registerModel.NrTelefonit,
                };

                var shtuarMeSukses = await _userManager.CreateAsync(perdoruesiIRI, registerModel.Password);

                if (shtuarMeSukses.Succeeded)
                {
                    await _userManager.AddToRoleAsync(perdoruesiIRI, "User");

                    Perdoruesi perdoruesi = new Perdoruesi
                    {
                        AspNetUserId = perdoruesiIRI.Id,
                        Emri = registerModel.Name,
                        Username = perdoruesiIRI.UserName,
                        Email = perdoruesiIRI.Email,
                        Mbiemri = registerModel.LastName,
                    };
                    await _context.Perdoruesi.AddAsync(perdoruesi);
                    await _context.SaveChangesAsync();

                    TeDhenatPerdoruesit teDhenatPerdoruesit = new TeDhenatPerdoruesit
                    {
                        UserId = perdoruesi.UserId,
                        Adresa = !registerModel.Adresa.IsNullOrEmpty() ? registerModel.Adresa : null,
                        Qyteti = !registerModel.Qyteti.IsNullOrEmpty() ? registerModel.Qyteti : null,
                        Shteti = !registerModel.Shteti.IsNullOrEmpty() ? registerModel.Shteti : null,
                        ZipKodi = registerModel.ZipKodi > 0 ? registerModel.ZipKodi : 0,
                        NrKontaktit = !registerModel.NrTelefonit.IsNullOrEmpty() ? registerModel.NrTelefonit : null
                    };
                    await _context.TeDhenatPerdoruesit.AddAsync(teDhenatPerdoruesit);
                    await _context.SaveChangesAsync();

                    return Ok(new AuthResults()
                    {
                        Result = true
                    });
                }
                return BadRequest(new AuthResults()
                {
                    Errors = new List<string>
                    {
                        "Server Errors"
                    },
                    Result = false
                });

            }
            return BadRequest();
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login([FromBody] LogInModel login)
        {
            if (ModelState.IsValid)
            {

                var useri_ekziston = await _userManager.FindByEmailAsync(login.Email);

                if (useri_ekziston == null)
                {
                    return BadRequest(new AuthResults()
                    {
                        Errors = new List<string>()
                        {
                            "Inavlid Payload"
                        },
                        Result = false
                    });
                }

                var neRregull = await _userManager.CheckPasswordAsync(useri_ekziston, login.Password);

                if (!neRregull)
                {
                    return BadRequest(new AuthResults()
                    {
                        Errors = new List<string>()
                        {
                            "Invalid Credintials"
                        },
                        Result = false
                    });
                }

                var roles = await _userManager.GetRolesAsync(useri_ekziston);

                var jwtToken = GenerateJwtToken(useri_ekziston, roles);
                var refreshToken = GenerateRefreshToken();
                var refreshTokenExpires = DateTime.UtcNow.AddDays(7);
                RefreshTokens[refreshToken] = new StoredRefreshToken(useri_ekziston.Id, refreshTokenExpires);

                return Ok(new AuthResults()
                {
                    Token = jwtToken,
                    RefreshToken = refreshToken,
                    RefreshTokenExpires = refreshTokenExpires,
                    Result = true
                });
            }

            return BadRequest(new AuthResults()
            {
                Errors = new List<String>()
                {
                    "Inavlid Payload"
                }
            });
        }

        [AllowAnonymous]
        [HttpPost]
        [Route("refresh")]
        public async Task<IActionResult> Refresh([FromBody] RefreshTokenRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Token) || string.IsNullOrWhiteSpace(request.RefreshToken))
            {
                return BadRequest(new AuthResults
                {
                    Result = false,
                    Errors = new List<string> { "Token and refresh token are required." }
                });
            }

            var principal = GetPrincipalFromExpiredToken(request.Token);
            var userId = principal?.Claims.FirstOrDefault(c => c.Type == "id")?.Value;

            if (string.IsNullOrWhiteSpace(userId) ||
                !RefreshTokens.TryGetValue(request.RefreshToken, out var storedToken) ||
                storedToken.UserId != userId ||
                storedToken.ExpiresUtc <= DateTime.UtcNow)
            {
                return Unauthorized(new AuthResults
                {
                    Result = false,
                    Errors = new List<string> { "Invalid or expired refresh token." }
                });
            }

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null)
            {
                return Unauthorized(new AuthResults
                {
                    Result = false,
                    Errors = new List<string> { "User no longer exists." }
                });
            }

            RefreshTokens.TryRemove(request.RefreshToken, out _);
            var roles = await _userManager.GetRolesAsync(user);
            var newJwtToken = GenerateJwtToken(user, roles);
            var newRefreshToken = GenerateRefreshToken();
            var refreshTokenExpires = DateTime.UtcNow.AddDays(7);
            RefreshTokens[newRefreshToken] = new StoredRefreshToken(user.Id, refreshTokenExpires);

            return Ok(new AuthResults
            {
                Token = newJwtToken,
                RefreshToken = newRefreshToken,
                RefreshTokenExpires = refreshTokenExpires,
                Result = true
            });
        }

        [Authorize]
        [HttpPost]
        [Route("revoke")]
        public IActionResult Revoke([FromBody] RefreshTokenRequest request)
        {
            if (!string.IsNullOrWhiteSpace(request?.RefreshToken))
            {
                RefreshTokens.TryRemove(request.RefreshToken, out _);
            }

            return NoContent();
        }

        [Authorize(Roles = "Admin, Menaxher")]
        [HttpPost]
        [Route("shtoRolinPerdoruesit")]
        public async Task<IActionResult> PerditesoAksesin(string userID, string roli)
        {
            var user = await _userManager.FindByIdAsync(userID);

            if (user == null)
            {
                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Perdoruesi nuk ekziston!" }
                });
            }

            var perditesoAksesin = await _userManager.AddToRoleAsync(user, roli);

            if (perditesoAksesin.Succeeded)
            {

                return Ok(new AuthResults
                {
                    Result = true
                });
            }
            else if (await _userManager.IsInRoleAsync(user, roli))
            {
                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Ky perdorues e ka kete role!" }
                });
            }
            else
            {
                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Ndodhi nje gabim gjate perditesimit te Aksesit" }
                });
            }
        }

        [Authorize(Roles = "Admin, Menaxher")]
        [HttpDelete]
        [Route("FshijRolinUserit")]
        public async Task<IActionResult> FshijRolinUserit(string userID, string roli)
        {
            var perdoruesi = await _userManager.FindByIdAsync(userID);

            if (perdoruesi == null)
            {
                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Ky perdorues nuk egziston" }
                });
            }
            else
            {
                var ekzistonRoli = await _roleManager.FindByNameAsync(roli);

                if (ekzistonRoli != null)
                {
                    var eKaRolin = await _userManager.IsInRoleAsync(perdoruesi, roli);

                    if (eKaRolin == true)
                    {
                        await _userManager.RemoveFromRoleAsync(perdoruesi, roli);

                        return Ok(new AuthResults
                        {
                            Result = true
                        });
                    }
                }
                else
                {
                    return BadRequest(new AuthResults
                    {
                        Errors = new List<string> { "Ky role nuk egziston" }
                    });
                }

                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Ndodhi nje gabim!" }
                });
            }


        }

        [Authorize(Roles = "Admin, Menaxher")]
        [HttpPost]
        [Route("shtoRolin")]
        public async Task<IActionResult> ShtoRolin(string roli)
        {
            var ekziston = await _roleManager.FindByNameAsync(roli);

            if (ekziston != null)
            {
                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Ky role tashme Egziston!" }
                });
            }
            else
            {
                var role = new IdentityRole(roli);
                var result = await _roleManager.CreateAsync(role);

                if (result.Succeeded)
                {
                    return Ok(new AuthResults
                    {
                        Result = true
                    });
                }
                else
                {
                    return BadRequest(new AuthResults
                    {
                        Errors = new List<string> { "Ndodhi nje gabim gjate shtimit te rolit" }
                    });
                }
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete]
        [Route("fshijRolin")]
        public async Task<IActionResult> FshijRolet(string emriRolit)
        {
            var roliEkziston = await _roleManager.FindByNameAsync(emriRolit);

            if (roliEkziston != null)
            {
                var roliUFshi = await _roleManager.DeleteAsync(roliEkziston);

                if (roliUFshi.Succeeded)
                {
                    return Ok(new AuthResults { Result = true });
                }
                else
                {
                    return BadRequest(new AuthResults
                    {
                        Errors = new List<string> { "Ndodhi nje gabim gjate fshirjes" }
                    });
                }
            }
            else
            {
                return BadRequest(new AuthResults
                {
                    Errors = new List<string> { "Ky Rol nuk egziston" }
                });
            }
        }

        [Authorize(Roles = "Admin, Menaxher")]
        [HttpGet]
        [Route("shfaqRolet")]
        public async Task<IActionResult> ShfaqRolet()
        {
            var rolet = await _roleManager.Roles.ToListAsync();

            var roletWithUsersCount = new List<object>();

            foreach (var roli in rolet)
            {
                var usersCount = await _userManager.GetUsersInRoleAsync(roli.Name);

                var roliWithUsersCount = new
                {
                    roli.Id,
                    roli.Name,
                    roli.NormalizedName,
                    roli.ConcurrencyStamp,
                    TotaliPerdoruesve = usersCount.Count
                };

                roletWithUsersCount.Add(roliWithUsersCount);
            }

            return Ok(roletWithUsersCount);
        }


        private string GenerateJwtToken(IdentityUser user, IList<string> roles)
        {
            var jwtTokenHandler = new JwtSecurityTokenHandler();

            var secret = _configuration["JWT_SECRET"] ?? _configuration.GetSection("JwtConfig:Secret").Value;
            var key = Encoding.UTF8.GetBytes(secret);

            // Token descriptor
            var TokenDescriptor = new SecurityTokenDescriptor()
            {

                Subject = new ClaimsIdentity(new[]
                {
                    new Claim("id", user.Id),
                    new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                    new Claim(JwtRegisteredClaimNames.Email, value:user.Email),
                    new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                    new Claim(JwtRegisteredClaimNames.Iat, DateTime.Now.ToUniversalTime().ToString())
                }),

                Expires = DateTime.Now.AddDays(1).AddHours(12),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256)
            };

            foreach (var role in roles)
            {
                TokenDescriptor.Subject.AddClaim(new Claim(ClaimTypes.Role, role));
            }

            var token = jwtTokenHandler.CreateToken(TokenDescriptor);
            var jwtToken = jwtTokenHandler.WriteToken(token);

            return jwtToken;
        }

        private ClaimsPrincipal? GetPrincipalFromExpiredToken(string token)
        {
            var secret = _configuration["JWT_SECRET"] ?? _configuration.GetSection("JwtConfig:Secret").Value;
            var tokenValidationParameters = new TokenValidationParameters
            {
                ValidateAudience = false,
                ValidateIssuer = false,
                ValidateIssuerSigningKey = true,
                IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret)),
                ValidateLifetime = false
            };

            var tokenHandler = new JwtSecurityTokenHandler();
            try
            {
                var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out var securityToken);
                if (securityToken is not JwtSecurityToken jwtSecurityToken ||
                    !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
                {
                    return null;
                }

                return principal;
            }
            catch
            {
                return null;
            }
        }

        private static string GenerateRefreshToken()
        {
            var randomBytes = new byte[64];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomBytes);
            return Convert.ToBase64String(randomBytes);
        }

        private record StoredRefreshToken(string UserId, DateTime ExpiresUtc);

    }

}
