CREATE TABLE [dbo].[Nota_Saida_Usuario] (
    [cd_controle]          INT      NOT NULL,
    [cd_nota_saida]        INT      NULL,
    [cd_serie_nota_fiscal] INT      NULL,
    [cd_usuario_nota]      INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Nota_Saida_Usuario] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

