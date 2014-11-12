CREATE TABLE [dbo].[Embarque_Complemento] (
    [cd_embarque]              INT          NOT NULL,
    [dt_declaracao_exportacao] DATETIME     NULL,
    [cd_declaracao_exportacao] VARCHAR (20) NULL,
    [cd_natureza_exportacao]   INT          NULL,
    [cd_registro_exportacao]   VARCHAR (20) NULL,
    [dt_registro_exportacao]   DATETIME     NULL,
    [nm_conhecimento_embarque] VARCHAR (20) NULL,
    [dt_conhecimento]          DATETIME     NULL,
    [cd_tipo_conhecimento]     INT          NULL,
    [cd_pais]                  INT          NULL,
    [dt_averbacao]             DATETIME     NULL,
    [cd_nota_saida]            INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Embarque_Complemento] PRIMARY KEY CLUSTERED ([cd_embarque] ASC),
    CONSTRAINT [FK_Embarque_Complemento_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

