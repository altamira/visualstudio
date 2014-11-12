CREATE TABLE [dbo].[Destinatario] (
    [cd_destinatario]              INT           NOT NULL,
    [nm_fantasia_destinatario]     VARCHAR (15)  NULL,
    [nm_razao_social_destinatario] VARCHAR (45)  NULL,
    [nm_razao_complemento]         VARCHAR (40)  NULL,
    [nm_site_destinatario]         VARCHAR (150) NULL,
    [nm_email_destinatario]        VARCHAR (150) NULL,
    [cd_tipo_destinatario]         INT           NULL,
    [dt_cadastro_destinatario]     DATETIME      NULL,
    [cd_usuario]                   INT           NULL,
    [dt_usuario]                   DATETIME      NULL,
    [ds_destinatario]              TEXT          NULL,
    [cd_tipo_pessoa]               INT           NULL,
    CONSTRAINT [PK_Destinatario] PRIMARY KEY CLUSTERED ([cd_destinatario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Destinatario_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario]),
    CONSTRAINT [FK_Destinatario_Tipo_Pessoa] FOREIGN KEY ([cd_tipo_pessoa]) REFERENCES [dbo].[Tipo_Pessoa] ([cd_tipo_pessoa])
);

