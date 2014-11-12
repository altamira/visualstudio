CREATE TABLE [dbo].[Fila_Email] (
    [cd_consulta]           INT           NOT NULL,
    [dt_geracao_email]      DATETIME      NOT NULL,
    [cd_cliente]            INT           NOT NULL,
    [nm_destinatario_email] VARCHAR (30)  NULL,
    [nm_depto_email]        VARCHAR (30)  NULL,
    [nm_email_enviado]      VARCHAR (100) NULL,
    [ic_status_email]       CHAR (1)      NULL,
    CONSTRAINT [PK_Fila_email] PRIMARY KEY CLUSTERED ([cd_consulta] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Fila_email]
    ON [dbo].[Fila_Email]([dt_geracao_email] ASC) WITH (FILLFACTOR = 90);

