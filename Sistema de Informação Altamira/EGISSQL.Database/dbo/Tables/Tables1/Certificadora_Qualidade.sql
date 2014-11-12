CREATE TABLE [dbo].[Certificadora_Qualidade] (
    [cd_certificadora_qualidade] INT           NOT NULL,
    [nm_certificadora_qualidade] VARCHAR (40)  NULL,
    [nm_fantasia_certificadora]  VARCHAR (15)  NULL,
    [cd_ddd]                     VARCHAR (4)   NULL,
    [cd_telefone]                VARCHAR (15)  NULL,
    [ds_certificadora_qualidade] TEXT          NULL,
    [nm_logotipo_certificadora]  VARCHAR (150) NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [nm_site_certificadora]      VARCHAR (100) NULL,
    CONSTRAINT [PK_Certificadora_Qualidade] PRIMARY KEY CLUSTERED ([cd_certificadora_qualidade] ASC) WITH (FILLFACTOR = 90)
);

