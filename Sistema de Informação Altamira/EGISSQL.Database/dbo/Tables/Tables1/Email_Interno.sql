CREATE TABLE [dbo].[Email_Interno] (
    [cd_email_interno]      INT           NOT NULL,
    [nm_emitente_email]     VARCHAR (20)  NULL,
    [nm_destinatario_email] VARCHAR (20)  NULL,
    [dt_geracao_email]      DATETIME      NULL,
    [dt_envio_email]        DATETIME      NULL,
    [nm_assunto_email]      VARCHAR (100) NULL,
    [ds_mensagem_email]     TEXT          NULL,
    [ic_enviado_email]      CHAR (1)      NULL,
    [cd_informacao_email]   INT           NULL,
    CONSTRAINT [PK_Email_Interno] PRIMARY KEY CLUSTERED ([cd_email_interno] ASC) WITH (FILLFACTOR = 90)
);

