CREATE TABLE [dbo].[Usuario_Contato] (
    [cd_usuario]               INT           NOT NULL,
    [cd_usuario_contato]       INT           NOT NULL,
    [nm_usuario_contato]       VARCHAR (40)  NULL,
    [nm_fantasia_contato]      VARCHAR (15)  NULL,
    [nm_empresa_contato]       VARCHAR (40)  NULL,
    [dt_aniversario_contato]   DATETIME      NULL,
    [nm_email_usuario_contato] VARCHAR (100) NULL,
    [nm_site_usuario_contato]  VARCHAR (100) NULL,
    [cd_ddd_usuario_contato]   CHAR (4)      NULL,
    [cd_fone_empresa]          VARCHAR (15)  NULL,
    [cd_fone_residencia]       VARCHAR (15)  NULL,
    [cd_fax_empresa]           VARCHAR (15)  NULL,
    [cd_ceclular]              VARCHAR (15)  NULL,
    [ds_usuario_contato]       TEXT          NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_fone_auxiliar1]        VARCHAR (15)  NULL,
    [cd_fone_auxiliar2]        VARCHAR (15)  NULL,
    CONSTRAINT [PK_Usuario_Contato] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [cd_usuario_contato] ASC) WITH (FILLFACTOR = 90)
);

