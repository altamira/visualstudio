CREATE TABLE [dbo].[prdfam] (
    [Familia]           NVARCHAR (30)  NULL,
    [Descricao]         NVARCHAR (50)  NULL,
    [IMPORTAR]          INT            NULL,
    [VARPRDESTLST]      NVARCHAR (250) NULL,
    [FORMULA]           NVARCHAR (MAX) NULL,
    [idPrdfam]          INT            IDENTITY (1, 1) NOT NULL,
    [descritivoTecnico] NVARCHAR (MAX) NULL
);

