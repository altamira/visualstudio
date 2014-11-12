CREATE TABLE [dbo].[Nota_Saida_Referenciada] (
    [cd_nota_saida]      INT      NULL,
    [cd_nota_referencia] INT      NULL,
    [sg_modelo_nota]     CHAR (2) NULL,
    [sg_serie_nota]      CHAR (3) NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL
);

