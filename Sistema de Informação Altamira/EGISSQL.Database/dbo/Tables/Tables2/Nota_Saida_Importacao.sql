CREATE TABLE [dbo].[Nota_Saida_Importacao] (
    [cd_nota_saida]  INT          NOT NULL,
    [nm_di]          VARCHAR (30) NULL,
    [dt_emissao_di]  DATETIME     NULL,
    [nm_porto_di]    VARCHAR (60) NULL,
    [sg_estado_di]   CHAR (2)     NULL,
    [dt_desembaraco] DATETIME     NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Nota_Saida_Importacao] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC)
);

