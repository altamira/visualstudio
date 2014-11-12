CREATE TABLE [dbo].[Natureza_Exportacao] (
    [cd_natureza_exportacao]    INT          NOT NULL,
    [nm_natureza_exportacao]    VARCHAR (60) NULL,
    [cd_identificacao_sintegra] INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Natureza_Exportacao] PRIMARY KEY CLUSTERED ([cd_natureza_exportacao] ASC)
);

