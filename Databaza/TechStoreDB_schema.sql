IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [AspNetRoles] (
    [Id] nvarchar(450) NOT NULL,
    [Name] nvarchar(256) NULL,
    [NormalizedName] nvarchar(256) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoles] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [AspNetUsers] (
    [Id] nvarchar(450) NOT NULL,
    [UserName] nvarchar(256) NULL,
    [NormalizedUserName] nvarchar(256) NULL,
    [Email] nvarchar(256) NULL,
    [NormalizedEmail] nvarchar(256) NULL,
    [EmailConfirmed] bit NOT NULL,
    [PasswordHash] nvarchar(max) NULL,
    [SecurityStamp] nvarchar(max) NULL,
    [ConcurrencyStamp] nvarchar(max) NULL,
    [PhoneNumber] nvarchar(max) NULL,
    [PhoneNumberConfirmed] bit NOT NULL,
    [TwoFactorEnabled] bit NOT NULL,
    [LockoutEnd] datetimeoffset NULL,
    [LockoutEnabled] bit NOT NULL,
    [AccessFailedCount] int NOT NULL,
    CONSTRAINT [PK_AspNetUsers] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [AspNetRoleClaims] (
    [Id] int NOT NULL IDENTITY,
    [RoleId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserClaims] (
    [Id] int NOT NULL IDENTITY,
    [UserId] nvarchar(450) NOT NULL,
    [ClaimType] nvarchar(max) NULL,
    [ClaimValue] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserClaims] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserLogins] (
    [LoginProvider] nvarchar(450) NOT NULL,
    [ProviderKey] nvarchar(450) NOT NULL,
    [ProviderDisplayName] nvarchar(max) NULL,
    [UserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserLogins] PRIMARY KEY ([LoginProvider], [ProviderKey]),
    CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserRoles] (
    [UserId] nvarchar(450) NOT NULL,
    [RoleId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_AspNetUserRoles] PRIMARY KEY ([UserId], [RoleId]),
    CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [AspNetRoles] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [AspNetUserTokens] (
    [UserId] nvarchar(450) NOT NULL,
    [LoginProvider] nvarchar(450) NOT NULL,
    [Name] nvarchar(450) NOT NULL,
    [Value] nvarchar(max) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY ([UserId], [LoginProvider], [Name]),
    CONSTRAINT [FK_AspNetUserTokens_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_AspNetRoleClaims_RoleId] ON [AspNetRoleClaims] ([RoleId]);
GO

CREATE UNIQUE INDEX [RoleNameIndex] ON [AspNetRoles] ([NormalizedName]) WHERE [NormalizedName] IS NOT NULL;
GO

CREATE INDEX [IX_AspNetUserClaims_UserId] ON [AspNetUserClaims] ([UserId]);
GO

CREATE INDEX [IX_AspNetUserLogins_UserId] ON [AspNetUserLogins] ([UserId]);
GO

CREATE INDEX [IX_AspNetUserRoles_RoleId] ON [AspNetUserRoles] ([RoleId]);
GO

CREATE INDEX [EmailIndex] ON [AspNetUsers] ([NormalizedEmail]);
GO

CREATE UNIQUE INDEX [UserNameIndex] ON [AspNetUsers] ([NormalizedUserName]) WHERE [NormalizedUserName] IS NOT NULL;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231202165315_InitialCreate', N'7.0.5');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [KategoriaProduktit] (
    [KategoriaId] int NOT NULL IDENTITY,
    [LlojiKategoris] nvarchar(max) NULL,
    [PershkrimiKategoris] nvarchar(max) NULL,
    CONSTRAINT [PK_KategoriaProduktit] PRIMARY KEY ([KategoriaId])
);
GO

CREATE TABLE [Kompania] (
    [KompaniaId] int NOT NULL IDENTITY,
    [EmriKompanis] nvarchar(max) NULL,
    [Logo] nvarchar(max) NULL,
    [Adresa] nvarchar(max) NULL,
    CONSTRAINT [PK_Kompania] PRIMARY KEY ([KompaniaId])
);
GO

CREATE TABLE [Perdoruesi] (
    [UserId] int NOT NULL IDENTITY,
    [Emri] nvarchar(max) NULL,
    [Mbiemri] nvarchar(max) NULL,
    [Email] nvarchar(max) NULL,
    [Username] nvarchar(max) NULL,
    [AspNetUserId] nvarchar(450) NOT NULL,
    CONSTRAINT [PK_Perdoruesi] PRIMARY KEY ([UserId]),
    CONSTRAINT [FK_Perdoruesi_AspNetUsers_AspNetUserId] FOREIGN KEY ([AspNetUserId]) REFERENCES [AspNetUsers] ([Id]) ON DELETE CASCADE
);
GO

CREATE TABLE [TeDhenatBiznesit] (
    [IdteDhenatBiznesit] int NOT NULL IDENTITY,
    [EmriIbiznesit] nvarchar(max) NULL,
    [ShkurtesaEmritBiznesit] nvarchar(max) NULL,
    [Nui] int NULL,
    [Nf] int NULL,
    [Nrtvsh] int NULL,
    [Adresa] nvarchar(max) NULL,
    [NrKontaktit] nvarchar(max) NULL,
    [Email] nvarchar(max) NULL,
    [Logo] nvarchar(max) NULL,
    CONSTRAINT [PK_TeDhenatBiznesit] PRIMARY KEY ([IdteDhenatBiznesit])
);
GO

CREATE TABLE [Produkti] (
    [ProduktiId] int NOT NULL IDENTITY,
    [EmriProduktit] nvarchar(max) NULL,
    [Pershkrimi] nvarchar(max) NULL,
    [FotoProduktit] nvarchar(max) NULL,
    [KompaniaId] int NULL,
    [KategoriaId] int NULL,
    CONSTRAINT [PK_Produkti] PRIMARY KEY ([ProduktiId]),
    CONSTRAINT [FK_Produkti_KategoriaProduktit_KategoriaId] FOREIGN KEY ([KategoriaId]) REFERENCES [KategoriaProduktit] ([KategoriaId]),
    CONSTRAINT [FK_Produkti_Kompania_KompaniaId] FOREIGN KEY ([KompaniaId]) REFERENCES [Kompania] ([KompaniaId])
);
GO

CREATE TABLE [ContactForm] (
    [MesazhiId] int NOT NULL IDENTITY,
    [UserId] int NULL,
    [Mesazhi] nvarchar(max) NULL,
    [DataDergeses] datetime2 NULL,
    [Statusi] nvarchar(max) NULL,
    [Emri] nvarchar(max) NULL,
    [Email] nvarchar(max) NULL,
    CONSTRAINT [PK_ContactForm] PRIMARY KEY ([MesazhiId]),
    CONSTRAINT [FK_ContactForm_Perdoruesi_UserId] FOREIGN KEY ([UserId]) REFERENCES [Perdoruesi] ([UserId])
);
GO

CREATE TABLE [Porosit] (
    [IdPorosia] int NOT NULL IDENTITY,
    [TotaliPorosis] decimal(18,2) NULL,
    [DataPorosis] datetime2 NULL,
    [StatusiPorosis] nvarchar(max) NULL,
    [IdKlienti] int NULL,
    [Zbritja] decimal(18,2) NULL,
    [TotaliProdukteve] int NULL,
    CONSTRAINT [PK_Porosit] PRIMARY KEY ([IdPorosia]),
    CONSTRAINT [FK_Porosit_Perdoruesi_IdKlienti] FOREIGN KEY ([IdKlienti]) REFERENCES [Perdoruesi] ([UserId])
);
GO

CREATE TABLE [RegjistrimiStokut] (
    [IdRegjistrimit] int NOT NULL IDENTITY,
    [DataRegjistrimit] datetime2 NULL,
    [StafiId] int NULL,
    [TotaliProdukteveRegjistruara] int NULL,
    [ShumaTotaleRegjistrimit] decimal(18,2) NULL,
    [ShumaTotaleBlerese] decimal(18,2) NULL,
    CONSTRAINT [PK_RegjistrimiStokut] PRIMARY KEY ([IdRegjistrimit]),
    CONSTRAINT [FK_RegjistrimiStokut_Perdoruesi_StafiId] FOREIGN KEY ([StafiId]) REFERENCES [Perdoruesi] ([UserId])
);
GO

CREATE TABLE [TeDhenatPerdoruesit] (
    [TeDhenatId] int NOT NULL IDENTITY,
    [UserId] int NOT NULL,
    [NrKontaktit] nvarchar(max) NULL,
    [Qyteti] nvarchar(max) NULL,
    [ZipKodi] int NULL,
    [Adresa] nvarchar(max) NULL,
    [Shteti] nvarchar(max) NULL,
    CONSTRAINT [PK_TeDhenatPerdoruesit] PRIMARY KEY ([TeDhenatId]),
    CONSTRAINT [FK_TeDhenatPerdoruesit_Perdoruesi_UserId] FOREIGN KEY ([UserId]) REFERENCES [Perdoruesi] ([UserId]) ON DELETE CASCADE
);
GO

CREATE TABLE [KodiZbritje] (
    [Kodi] nvarchar(450) NOT NULL,
    [DataKrijimit] datetime2 NULL,
    [QmimiZbritjes] decimal(18,2) NULL,
    [IdProdukti] int NULL,
    CONSTRAINT [PK_KodiZbritje] PRIMARY KEY ([Kodi]),
    CONSTRAINT [FK_KodiZbritje_Produkti_IdProdukti] FOREIGN KEY ([IdProdukti]) REFERENCES [Produkti] ([ProduktiId])
);
GO

CREATE TABLE [StokuQmimiProduktit] (
    [StokuID] int NOT NULL IDENTITY,
    [ProduktiId] int NOT NULL,
    [SasiaNeStok] int NULL,
    [QmimiBleres] decimal(18,2) NULL,
    [QmimiProduktit] decimal(18,2) NULL,
    [DataKrijimit] datetime2 NULL,
    [DataPerditsimit] datetime2 NULL,
    CONSTRAINT [PK_StokuQmimiProduktit] PRIMARY KEY ([StokuID]),
    CONSTRAINT [FK_StokuQmimiProduktit_Produkti_ProduktiId] FOREIGN KEY ([ProduktiId]) REFERENCES [Produkti] ([ProduktiId]) ON DELETE CASCADE
);
GO

CREATE TABLE [ZbritjaQmimitProduktit] (
    [ZbritjaID] int NOT NULL IDENTITY,
    [ProduktiId] int NOT NULL,
    [QmimiPaZbritjeProduktit] decimal(18,2) NULL,
    [QmimiMeZbritjeProduktit] decimal(18,2) NULL,
    [DataZbritjes] datetime2 NULL,
    [DataSkadimit] datetime2 NULL,
    CONSTRAINT [PK_ZbritjaQmimitProduktit] PRIMARY KEY ([ZbritjaID]),
    CONSTRAINT [FK_ZbritjaQmimitProduktit_Produkti_ProduktiId] FOREIGN KEY ([ProduktiId]) REFERENCES [Produkti] ([ProduktiId]) ON DELETE CASCADE
);
GO

CREATE TABLE [TeDhenatEPorosis] (
    [IdDetajet] int NOT NULL IDENTITY,
    [QmimiTotal] decimal(18,2) NULL,
    [SasiaPorositur] int NULL,
    [IdPorosia] int NULL,
    [IdProdukti] int NULL,
    [QmimiProduktit] decimal(18,2) NULL,
    CONSTRAINT [PK_TeDhenatEPorosis] PRIMARY KEY ([IdDetajet]),
    CONSTRAINT [FK_TeDhenatEPorosis_Porosit_IdPorosia] FOREIGN KEY ([IdPorosia]) REFERENCES [Porosit] ([IdPorosia]),
    CONSTRAINT [FK_TeDhenatEPorosis_Produkti_IdProdukti] FOREIGN KEY ([IdProdukti]) REFERENCES [Produkti] ([ProduktiId])
);
GO

CREATE TABLE [TeDhenatRegjistrimit] (
    [Id] int NOT NULL IDENTITY,
    [IdRegjistrimit] int NULL,
    [IdProduktit] int NULL,
    [SasiaStokut] int NULL,
    [QmimiBleres] decimal(18,2) NULL,
    [QmimiShites] decimal(18,2) NULL,
    CONSTRAINT [PK_TeDhenatRegjistrimit] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_TeDhenatRegjistrimit_Produkti_IdProduktit] FOREIGN KEY ([IdProduktit]) REFERENCES [Produkti] ([ProduktiId]),
    CONSTRAINT [FK_TeDhenatRegjistrimit_RegjistrimiStokut_IdRegjistrimit] FOREIGN KEY ([IdRegjistrimit]) REFERENCES [RegjistrimiStokut] ([IdRegjistrimit])
);
GO

CREATE INDEX [IX_ContactForm_UserId] ON [ContactForm] ([UserId]);
GO

CREATE INDEX [IX_KodiZbritje_IdProdukti] ON [KodiZbritje] ([IdProdukti]);
GO

CREATE INDEX [IX_Perdoruesi_AspNetUserId] ON [Perdoruesi] ([AspNetUserId]);
GO

CREATE INDEX [IX_Porosit_IdKlienti] ON [Porosit] ([IdKlienti]);
GO

CREATE INDEX [IX_Produkti_KategoriaId] ON [Produkti] ([KategoriaId]);
GO

CREATE INDEX [IX_Produkti_KompaniaId] ON [Produkti] ([KompaniaId]);
GO

CREATE INDEX [IX_RegjistrimiStokut_StafiId] ON [RegjistrimiStokut] ([StafiId]);
GO

CREATE UNIQUE INDEX [IX_StokuQmimiProduktit_ProduktiId] ON [StokuQmimiProduktit] ([ProduktiId]);
GO

CREATE INDEX [IX_TeDhenatEPorosis_IdPorosia] ON [TeDhenatEPorosis] ([IdPorosia]);
GO

CREATE INDEX [IX_TeDhenatEPorosis_IdProdukti] ON [TeDhenatEPorosis] ([IdProdukti]);
GO

CREATE UNIQUE INDEX [IX_TeDhenatPerdoruesit_UserId] ON [TeDhenatPerdoruesit] ([UserId]);
GO

CREATE INDEX [IX_TeDhenatRegjistrimit_IdProduktit] ON [TeDhenatRegjistrimit] ([IdProduktit]);
GO

CREATE INDEX [IX_TeDhenatRegjistrimit_IdRegjistrimit] ON [TeDhenatRegjistrimit] ([IdRegjistrimit]);
GO

CREATE UNIQUE INDEX [IX_ZbritjaQmimitProduktit_ProduktiId] ON [ZbritjaQmimitProduktit] ([ProduktiId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231202165456_ShtimiTabelave', N'7.0.5');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

DROP TABLE [KodiZbritje];
GO

CREATE TABLE [KodiZbritjes] (
    [Kodi] nvarchar(450) NOT NULL,
    [DataKrijimit] datetime2 NULL,
    [QmimiZbritjes] decimal(18,2) NULL,
    [IdProdukti] int NULL,
    CONSTRAINT [PK_KodiZbritjes] PRIMARY KEY ([Kodi]),
    CONSTRAINT [FK_KodiZbritjes_Produkti_IdProdukti] FOREIGN KEY ([IdProdukti]) REFERENCES [Produkti] ([ProduktiId])
);
GO

CREATE INDEX [IX_KodiZbritjes_IdProdukti] ON [KodiZbritjes] ([IdProdukti]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231202170119_PerditesimiKodiZbritjes', N'7.0.5');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name', N'NormalizedName', N'ConcurrencyStamp') AND [object_id] = OBJECT_ID(N'[AspNetRoles]'))
    SET IDENTITY_INSERT [AspNetRoles] ON;
INSERT INTO [AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (N'0267d4fd-5bac-4552-9930-8e528b2fec1b', N'Admin', N'ADMIN', N'bcb0a7f8-41b2-48ce-bf39-fbc24516012e'),
(N'db3dd60d-a159-4f85-a9a5-d1444ee1013d', N'Menaxher', N'MENAXHER', N'3e215a86-6eeb-48a6-90d9-fe12a7a70f28'),
(N'be4b8ef8-abf0-454c-852c-676cdab20e3b', N'User', N'USER', N'264000ea-9d66-4686-b48b-e06165a906fc');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'Name', N'NormalizedName', N'ConcurrencyStamp') AND [object_id] = OBJECT_ID(N'[AspNetRoles]'))
    SET IDENTITY_INSERT [AspNetRoles] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'UserName', N'NormalizedUserName', N'Email', N'NormalizedEmail', N'EmailConfirmed', N'PasswordHash', N'SecurityStamp', N'ConcurrencyStamp', N'PhoneNumber', N'PhoneNumberConfirmed', N'TwoFactorEnabled', N'LockoutEnabled', N'AccessFailedCount') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
    SET IDENTITY_INSERT [AspNetUsers] ON;
INSERT INTO [AspNetUsers] ([Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail], [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount])
VALUES (N'9d6b2651-641d-4c85-9154-99761863fc65', N'user', N'USER', N'user@techstore.com', N'USER@TECHSTORE.COM', CAST(0 AS bit), N'AQAAAAEAACcQAAAAEFvlpjPerR25vlxvKiV9GnWzzfQGEk9LCpEfnHG/yUyyaYXsRp/sN52ZWgKNbsq1JA==', N'3VINW7OQ6CJ7CZE3737G4L6WGMKBHWPT', N'241f5600-e4e1-4e08-b789-9b0fc9367502', N'', CAST(0 AS bit), CAST(0 AS bit), CAST(0 AS bit), 0),
(N'd2a7088f-a25e-4f3f-8488-b616eeaff928', N'menagjer', N'MENAGJER', N'menagjer@techstore.com', N'MENAGJER@TECHSTORE.COM', CAST(0 AS bit), N'AQAAAAEAACcQAAAAEP60Y+OpxVc3CPWS9NZu79pNu/KAAsxbrm8qTWpL9+ILK+Sd/3Pw4yLEas1N2TXL+g==', N'2TO7IOMEDSKTLMHBALX52ICRC3HX3FNQ', N'297b4ee1-133a-4ad2-8242-201592f7a43d', N'', CAST(0 AS bit), CAST(0 AS bit), CAST(0 AS bit), 0),
(N'f2bb7622-23ac-4c5f-8d71-00032b281e37', N'admin', N'ADMIN', N'admin@techstore.com', N'ADMIN@TECHSTORE.COM', CAST(0 AS bit), N'AQAAAAEAACcQAAAAEAy6t6f1jILbKXRyqzSZGrR4zq/Wl8G525tgzrBsqYIG4ksRH5HySRRlJrMtzvfTug==', N'RHCE5BDZYCGBDPAZQ74P3IWVFBNDWMEX', N'5dd7b4ea-994f-43c2-bdfd-1bef310ebf29', N'', CAST(0 AS bit), CAST(0 AS bit), CAST(0 AS bit), 0);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'UserName', N'NormalizedUserName', N'Email', N'NormalizedEmail', N'EmailConfirmed', N'PasswordHash', N'SecurityStamp', N'ConcurrencyStamp', N'PhoneNumber', N'PhoneNumberConfirmed', N'TwoFactorEnabled', N'LockoutEnabled', N'AccessFailedCount') AND [object_id] = OBJECT_ID(N'[AspNetUsers]'))
    SET IDENTITY_INSERT [AspNetUsers] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'UserId', N'RoleId') AND [object_id] = OBJECT_ID(N'[AspNetUserRoles]'))
    SET IDENTITY_INSERT [AspNetUserRoles] ON;
INSERT INTO [AspNetUserRoles] ([UserId], [RoleId])
VALUES (N'9d6b2651-641d-4c85-9154-99761863fc65', N'be4b8ef8-abf0-454c-852c-676cdab20e3b'),
(N'd2a7088f-a25e-4f3f-8488-b616eeaff928', N'be4b8ef8-abf0-454c-852c-676cdab20e3b'),
(N'f2bb7622-23ac-4c5f-8d71-00032b281e37', N'be4b8ef8-abf0-454c-852c-676cdab20e3b'),
(N'd2a7088f-a25e-4f3f-8488-b616eeaff928', N'db3dd60d-a159-4f85-a9a5-d1444ee1013d'),
(N'f2bb7622-23ac-4c5f-8d71-00032b281e37', N'db3dd60d-a159-4f85-a9a5-d1444ee1013d'),
(N'f2bb7622-23ac-4c5f-8d71-00032b281e37', N'0267d4fd-5bac-4552-9930-8e528b2fec1b');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'UserId', N'RoleId') AND [object_id] = OBJECT_ID(N'[AspNetUserRoles]'))
    SET IDENTITY_INSERT [AspNetUserRoles] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'UserId', N'Emri', N'Mbiemri', N'Email', N'Username', N'AspNetUserId') AND [object_id] = OBJECT_ID(N'[Perdoruesi]'))
    SET IDENTITY_INSERT [Perdoruesi] ON;
INSERT INTO [Perdoruesi] ([UserId], [Emri], [Mbiemri], [Email], [Username], [AspNetUserId])
VALUES (1, N'Administrator', N'Administrator', N'admin@techstore.com', N'admin', N'f2bb7622-23ac-4c5f-8d71-00032b281e37'),
(2, N'Menagjer', N'Menagjer', N'menagjer@techstore.com', N'menagjer', N'd2a7088f-a25e-4f3f-8488-b616eeaff928'),
(3, N'User', N'User', N'user@techstore.com', N'user', N'9d6b2651-641d-4c85-9154-99761863fc65');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'UserId', N'Emri', N'Mbiemri', N'Email', N'Username', N'AspNetUserId') AND [object_id] = OBJECT_ID(N'[Perdoruesi]'))
    SET IDENTITY_INSERT [Perdoruesi] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeDhenatId', N'UserId', N'ZipKodi') AND [object_id] = OBJECT_ID(N'[TeDhenatPerdoruesit]'))
    SET IDENTITY_INSERT [TeDhenatPerdoruesit] ON;
INSERT INTO [TeDhenatPerdoruesit] ([TeDhenatId], [UserId], [ZipKodi])
VALUES (1, 1, 0),
(2, 2, 0),
(3, 3, 0);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'TeDhenatId', N'UserId', N'ZipKodi') AND [object_id] = OBJECT_ID(N'[TeDhenatPerdoruesit]'))
    SET IDENTITY_INSERT [TeDhenatPerdoruesit] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'IdteDhenatBiznesit', N'Nui', N'Nf', N'Nrtvsh', N'Logo') AND [object_id] = OBJECT_ID(N'[TeDhenatBiznesit]'))
    SET IDENTITY_INSERT [TeDhenatBiznesit] ON;
INSERT INTO [TeDhenatBiznesit] ([IdteDhenatBiznesit], [Nui], [Nf], [Nrtvsh], [Logo])
VALUES (1, 0, 0, 0, N'PaLogo.png');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'IdteDhenatBiznesit', N'Nui', N'Nf', N'Nrtvsh', N'Logo') AND [object_id] = OBJECT_ID(N'[TeDhenatBiznesit]'))
    SET IDENTITY_INSERT [TeDhenatBiznesit] OFF;
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231202172926_VendosjaETeDhenave', N'7.0.5');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Banka57449] (
    [Id57449] int NOT NULL IDENTITY,
    [Emri57449] nvarchar(max) NULL,
    CONSTRAINT [PK_Banka57449] PRIMARY KEY ([Id57449])
);
GO

CREATE TABLE [Personi57449] (
    [Id57449] int NOT NULL IDENTITY,
    [Emri57449] nvarchar(max) NULL,
    [Mbiemri57449] nvarchar(max) NULL,
    [Banka57449ID] int NULL,
    CONSTRAINT [PK_Personi57449] PRIMARY KEY ([Id57449]),
    CONSTRAINT [FK_Personi57449_Banka57449_Banka57449ID] FOREIGN KEY ([Banka57449ID]) REFERENCES [Banka57449] ([Id57449])
);
GO

CREATE INDEX [IX_Personi57449_Banka57449ID] ON [Personi57449] ([Banka57449ID]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20231202185513_VendosjaTeDhenaveMbrotjeProjketi', N'7.0.5');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Planet212257449] (
    [PlanetId] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    [Type] nvarchar(max) NULL,
    [isDeleted] nvarchar(max) NULL,
    CONSTRAINT [PK_Planet212257449] PRIMARY KEY ([PlanetId])
);
GO

CREATE TABLE [Satellite212257449] (
    [SatelliteId] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    [isDeleted] nvarchar(max) NULL,
    [PlanetId] int NULL,
    CONSTRAINT [PK_Satellite212257449] PRIMARY KEY ([SatelliteId]),
    CONSTRAINT [FK_Satellite212257449_Planet212257449_PlanetId] FOREIGN KEY ([PlanetId]) REFERENCES [Planet212257449] ([PlanetId])
);
GO

CREATE INDEX [IX_Satellite212257449_PlanetId] ON [Satellite212257449] ([PlanetId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240416152322_KrijimiDatabazesMbrojtjaProjektitDet2', N'7.0.5');
GO

COMMIT;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Team] (
    [TeamId] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    CONSTRAINT [PK_Team] PRIMARY KEY ([TeamId])
);
GO

CREATE TABLE [Player] (
    [PlayerId] int NOT NULL IDENTITY,
    [Name] nvarchar(max) NULL,
    [Number] int NULL,
    [BirthYear] int NULL,
    [TeamId] int NULL,
    CONSTRAINT [PK_Player] PRIMARY KEY ([PlayerId]),
    CONSTRAINT [FK_Player_Team_TeamId] FOREIGN KEY ([TeamId]) REFERENCES [Team] ([TeamId]) ON DELETE CASCADE
);
GO

CREATE INDEX [IX_Player_TeamId] ON [Player] ([TeamId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20240416170627_KrijimiDatabazesMbrojtjaProjektitDet3', N'7.0.5');
GO

COMMIT;
GO

