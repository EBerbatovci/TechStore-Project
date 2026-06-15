# Running TechStore Locally

## Prerequisites

- .NET SDK 6 or newer
- Node.js 18 or newer
- SQL Server Express or SQL Server Developer
- Visual Studio, Rider, or VS Code

## Database

The backend uses this connection string by default:

```json
"Conn": "Server=localhost\\SQLEXPRESS;Database=TechStoreDB;Trusted_Connection=True;TrustServerCertificate=True"
```

Create/update the database from EF migrations:

```powershell
cd WebAPI/WebAPI
dotnet ef database update
```

The generated schema script is also available at:

```text
Databaza/TechStoreDB_schema.sql
```

The original exported data script is:

```text
Databaza/TechStoreDB.sql
```

## Backend

```powershell
cd WebAPI/WebAPI
dotnet restore
dotnet run
```

Backend URL:

```text
https://localhost:7285
```

Swagger:

```text
https://localhost:7285/swagger
```

For a safer local secret, set this before running:

```powershell
$env:JWT_SECRET = "replace-with-a-long-random-secret-at-least-32-chars"
```

## Frontend

```powershell
cd techstore
npm install
npm start
```

Frontend URL:

```text
http://localhost:3000
```

## Demo Accounts

| Email | Password | Role |
| --- | --- | --- |
| admin@techstore.com | Admin1@ | Administrator |
| menaxher@techstore.com | Menaxher1@ | Menaxher |
| user@techstore.com | User1@ | Klient |

## Acceptance Checklist

- Open the frontend in Chrome/Edge/Firefox.
- Login with each demo role.
- Confirm protected dashboard screens require login.
- Confirm product/category/company CRUD from the admin dashboard.
- Confirm order workflow and invoice screen.
- Open Swagger and test at least one public and one protected endpoint.
- Attach Trello evidence from `docs/PROJECT_MANAGEMENT.md`.
