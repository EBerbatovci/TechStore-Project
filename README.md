# TechStore Project

TechStore is an e-commerce web application for selling technology products. It was built for Lab Course 1.

## Technology Stack

- Frontend: React JS, React Bootstrap, MDB React UI Kit
- Backend: ASP.NET Core Web API
- Authentication: ASP.NET Core Identity, JWT, refresh-token workflow
- Database: SQL Server, Entity Framework Core migrations
- Documentation: Swagger and Markdown API docs

## Main Features

- Public product catalog with product search, category filtering and company filtering.
- User registration and login.
- JWT authorization with role-based access for `Admin`, `Menaxher` and `User`.
- Refresh-token endpoint and token revocation endpoint.
- Customer cart, checkout, orders and invoice view.
- Admin dashboard for products, categories, companies, users, roles, orders, discounts, messages, stock registration and statistics.
- SQL Server schema managed with EF Core migrations.

## Demo Accounts

| Email | Password | Role |
| --- | --- | --- |
| admin@techstore.com | Admin1@ | Administrator |
| menaxher@techstore.com | Menaxher1@ | Menaxher |
| user@techstore.com | User1@ | Klient |

## Run The Project

Detailed setup steps are in:

```text
docs/RUNNING.md
```

Short version:

```powershell
cd WebAPI/WebAPI
dotnet restore
dotnet ef database update
dotnet run
```

```powershell
cd techstore
npm install
npm start
```

Backend:

```text
https://localhost:7285
```

Frontend:

```text
http://localhost:3000
```

Swagger:

```text
https://localhost:7285/swagger
```

## Documentation

- API documentation: `docs/API.md`
- Running instructions: `docs/RUNNING.md`
- Trello/project-management evidence checklist: `docs/PROJECT_MANAGEMENT.md`
- Generated database schema script: `Databaza/TechStoreDB_schema.sql`
- Original exported data script: `Databaza/TechStoreDB.sql`

## Lab Course 1 Checklist

| Requirement | Status |
| --- | --- |
| Git usage | Repository history exists; root `.gitignore` added to prevent build-output pollution. |
| Trello usage | Add Trello board link/screenshots in `docs/PROJECT_MANAGEMENT.md` before submission. |
| Backend API | ASP.NET Core Web API with CRUD endpoints and Swagger. |
| Frontend | React app with Bootstrap-based UI and admin dashboard. |
| Database | SQL Server with EF Core migrations and generated schema SQL. |
| Security | JWT, Identity roles, refresh-token endpoint, revoke endpoint, restricted CORS origins. |
| Documentation | README, API docs and running guide included. |

## Security Notes

For local development, the project can use `JwtConfig:Secret` from `appsettings.json`. For a real deployment or public hosting, set a strong `JWT_SECRET` environment variable and do not commit production secrets.
