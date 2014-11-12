CREATE TABLE [dbo].[Nota_Saida_Acumulada] (
    [cd_nota_saida_origem] INT        NULL,
    [cd_nota_saida]        INT        NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [ic_gerado_nota]       CHAR (1)   NULL,
    [vl_base_calculo]      FLOAT (53) NULL
);

