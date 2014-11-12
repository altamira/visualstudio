CREATE TABLE [dbo].[Config_Servidor_Email] (
    [cd_config_servidor_email]       INT           NOT NULL,
    [cd_pop3_servidor_email]         VARCHAR (20)  NULL,
    [cd_smtp_servidor_email]         VARCHAR (20)  NULL,
    [nm_usuario_servidor_email]      VARCHAR (100) NULL,
    [cd_senha_servidor_email]        VARCHAR (30)  NULL,
    [qt_tentativa_servidor]          INT           NULL,
    [ic_ocorrencia_servidor]         CHAR (1)      NULL,
    [cd_empresa]                     INT           NULL,
    [cd_usuario]                     INT           NULL,
    [dt_usuario]                     DATETIME      NULL,
    [ic_ativo_servidor_email]        CHAR (1)      NULL,
    [nm_caminho_html_email]          VARCHAR (150) NULL,
    [nm_host_servidor_email]         VARCHAR (150) NULL,
    [qt_verifica_servico]            INT           NULL,
    [cd_senha_servidor_email_smtp]   VARCHAR (15)  NULL,
    [nm_usuario_servidor_email_smtp] VARCHAR (60)  NULL,
    CONSTRAINT [PK_Config_Servidor_Email] PRIMARY KEY CLUSTERED ([cd_config_servidor_email] ASC) WITH (FILLFACTOR = 90)
);

