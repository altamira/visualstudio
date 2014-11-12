CREATE TABLE [dbo].[Nota_Saida_Embarque] (
    [cd_nota_saida]     INT          NOT NULL,
    [sg_local_embarque] CHAR (2)     NULL,
    [nm_local_embarque] VARCHAR (60) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Nota_Saida_Embarque] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC)
);

