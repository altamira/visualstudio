CREATE TABLE [dbo].[idmprd] (
    [idioma]    NVARCHAR (12) NULL,
    [produto]   NVARCHAR (20) NULL,
    [descricao] NVARCHAR (50) NULL,
    [unidade]   NVARCHAR (2)  NULL,
    [IdIdmprd]  INT           IDENTITY (1, 1) NOT NULL
);

