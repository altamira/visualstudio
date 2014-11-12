CREATE TABLE [dbo].[Usuarios] (
    [idUsuario]   INT            IDENTITY (1, 1) NOT NULL,
    [Usuario]     NVARCHAR (100) NOT NULL,
    [Login]       NVARCHAR (20)  NOT NULL,
    [Senha]       NVARCHAR (50)  NOT NULL,
    [Prefixo]     NVARCHAR (4)   NULL,
    [Observacoes] NVARCHAR (MAX) NULL,
    [Ativo]       BIT            NOT NULL,
    [descontoMax] NVARCHAR (10)  NULL
);

