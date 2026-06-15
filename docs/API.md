# TechStore API Documentation

Base URL for local development:

```text
https://localhost:7285/api
```

Swagger is enabled in Development mode:

```text
https://localhost:7285/swagger
```

Most protected endpoints require this header:

```http
Authorization: Bearer <jwt-token>
```

## Authentication

| Method | Endpoint | Access | Description |
| --- | --- | --- | --- |
| POST | `/Authenticate/register` | Public | Register a new user and assign the default `User` role. |
| POST | `/Authenticate/login` | Public | Login and receive JWT + refresh token. |
| POST | `/Authenticate/refresh` | Public | Exchange an expired/active JWT plus refresh token for a new pair. |
| POST | `/Authenticate/revoke` | Authenticated | Revoke a refresh token/session. |
| POST | `/Authenticate/shtoRolinPerdoruesit` | Admin, Menaxher | Add a role to a user. |
| DELETE | `/Authenticate/FshijRolinUserit` | Admin, Menaxher | Remove a role from a user. |
| POST | `/Authenticate/shtoRolin` | Admin, Menaxher | Create a role. |
| DELETE | `/Authenticate/fshijRolin` | Admin | Delete a role. |
| GET | `/Authenticate/shfaqRolet` | Admin, Menaxher | List roles with user counts. |

## Catalog

| Method | Endpoint | Access | Description |
| --- | --- | --- | --- |
| GET | `/Produkti/Products` | Public | List products with company, category, stock, price and discount data. |
| GET | `/Produkti/{id}` | Public | Get a product by ID. |
| GET | `/Produkti/15ProduktetMeTeFundit` | Public | Get the 15 newest products. |
| GET | `/Produkti/ProduktetPerKalkulim` | Public | List products ordered for stock calculation. |
| POST | `/Produkti/shtoProdukt` | Admin, Menaxher | Create a product and its stock/price row. |
| PUT | `/Produkti/{id}` | Admin, Menaxher | Update product, company, category, image, stock and pricing. |
| DELETE | `/Produkti/{id}` | Admin | Delete a product. |

## Categories And Companies

| Method | Endpoint | Access | Description |
| --- | --- | --- | --- |
| GET | `/Kategoria/shfaqKategorit` | Public | List categories. |
| GET | `/Kategoria/shfaqKategorinSipasIDs?id=` | Public | Get a category by ID. |
| POST | `/Kategoria/shtoKategorin` | Admin, Menaxher | Create a category. |
| PUT | `/Kategoria/perditesoKategorin?id=` | Admin, Menaxher | Update a category. |
| DELETE | `/Kategoria/fshijKategorin?id=` | Admin | Delete a category. |
| GET | `/Kompania/shfaqKompanit` | Public | List companies. |
| GET | `/Kompania/shfaqKompanin?id=` | Public | Get a company by ID. |
| POST | `/Kompania/shtoKompanin` | Admin, Menaxher | Create a company. |
| PUT | `/Kompania/perditesoKompanin?id=` | Admin, Menaxher | Update a company. |
| DELETE | `/Kompania/fshijKompanin?id=` | Admin | Delete a company. |

## Orders And Stock

| Method | Endpoint | Access | Description |
| --- | --- | --- | --- |
| GET | `/Porosia/Porosit` | Admin, Menaxher | List all orders. |
| GET | `/Porosia/shfaqPorositeUserit?idPerdoruesi=` | Admin, Menaxher, User | List one user's orders. |
| GET | `/Porosia/shfaqPorosineNgaID?nrFatures=` | Admin, Menaxher, User | Get invoice/order details. |
| POST | `/Porosia/vendosPorosine` | Admin, Menaxher, User | Create an order. |
| POST | `/Porosia/vendosTeDhenatPorosise` | Admin, Menaxher, User | Create order line and reduce stock. |
| PUT | `/Porosia/perditesoStatusinPorosis?idPorosia=&statusi=` | Admin, Menaxher | Update order status. |
| DELETE | `/Porosia/fshijPorosine?idPorosia=` | Admin | Delete an order and its details. |
| GET | `/RegjistrimiStokut/shfaqRegjistrimet` | Admin, Menaxher | List stock registrations. |
| POST | `/RegjistrimiStokut/ruajKalkulimin` | Admin, Menaxher | Create stock registration. |
| POST | `/RegjistrimiStokut/ruajKalkulimin/teDhenat` | Admin, Menaxher | Add stock registration details. |
| PUT | `/RegjistrimiStokut/ruajKalkulimin/perditesoStokunQmimin?id=` | Admin, Menaxher | Update product stock and prices. |
| DELETE | `/RegjistrimiStokut/fshijRegjistrimin?id=` | Admin | Delete stock registration and details. |

## Discounts, Messages, Dashboard

| Method | Endpoint | Access | Description |
| --- | --- | --- | --- |
| GET | `/KodiZbritje/...` | Admin, Menaxher, User | Discount-code read/create/update/delete operations. |
| GET | `/ZbritjaQmimitProduktit/shfaqZbritjet` | Admin, Menaxher | List product price discounts. |
| POST | `/ZbritjaQmimitProduktit/shtoZbritjenProduktit` | Admin, Menaxher | Create product discount. |
| PUT | `/ZbritjaQmimitProduktit/perditesoZbritjenProduktit?id=` | Admin, Menaxher | Update product discount. |
| DELETE | `/ZbritjaQmimitProduktit/fshijZbritjenProduktit?id=` | Admin, Menaxher | Delete product discount. |
| GET/POST/PUT/DELETE | `/ContactForm/...` | Mixed | Customer/staff message workflows. |
| GET | `/Statistikat/...` | Admin, Menaxher | Dashboard statistics. |
| GET/PUT | `/TeDhenatBiznesit/...` | Public/Admin | Business profile used by the site. |

## Security Notes

- JWT authentication and role-based authorization are configured in `Program.cs`.
- Login returns both an access token and refresh token.
- Refresh tokens can be rotated through `/Authenticate/refresh` and revoked through `/Authenticate/revoke`.
- CORS is restricted through the `AllowedOrigins` setting.
- For deployment, set `JWT_SECRET` as an environment variable instead of relying on `appsettings.json`.
