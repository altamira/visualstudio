CREATE TABLE [dbo].[Servico_Email] (
    [cd_servico_email]         INT           NOT NULL,
    [nm_from_address]          VARCHAR (100) NULL,
    [nm_from_name]             VARCHAR (50)  NULL,
    [nm_subject]               VARCHAR (100) NULL,
    [nm_email_destino_servico] VARCHAR (100) NULL,
    [dt_servico_email]         DATETIME      NULL,
    [cd_documento_email]       INT           NULL,
    [cd_item_documento_email]  INT           NULL,
    [nm_arquivo_html_servico]  VARCHAR (30)  NULL,
    [cd_tipo_email]            INT           NULL,
    [ic_status_email]          CHAR (1)      NULL,
    [qt_tentativa_envio]       INT           NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [ds_problema_envio]        TEXT          NULL,
    [nm_anexo_servico]         VARCHAR (250) NULL,
    CONSTRAINT [PK_Servico_Email] PRIMARY KEY CLUSTERED ([cd_servico_email] ASC) WITH (FILLFACTOR = 90)
);

