CREATE TABLE [dbo].[cfosecao] (
    [perfil]          NVARCHAR (50)  NULL,
    [secao]           NVARCHAR (50)  NULL,
    [imprimir]        BIT            NOT NULL,
    [ordem_impressao] REAL           NULL,
    [texto_indice]    NVARCHAR (100) NULL
);

