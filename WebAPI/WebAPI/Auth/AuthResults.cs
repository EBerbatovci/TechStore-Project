namespace WebAPI.Auth
{
    public class AuthResults
    {
        public string Token { get; set; } = string.Empty;
        public string RefreshToken { get; set; } = string.Empty;
        public DateTime? RefreshTokenExpires { get; set; }
        public bool Result { get; set; }
        public List<String> Errors { get; set; } = new List<string>();
    }
}
