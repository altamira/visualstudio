CREATE TABLE [dbo].[Parametro_Historico_Cliente] (
    [cd_empresa]                 INT          NOT NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_tipo]                    CHAR (1)     NULL,
    [ic_lookup]                  CHAR (1)     NULL,
    [ic_fase]                    CHAR (1)     NULL,
    [ic_assunto]                 CHAR (1)     NULL,
    [ic_descritivo]              CHAR (1)     NULL,
    [ic_historico]               CHAR (1)     NULL,
    [ic_concorrente]             CHAR (1)     NULL,
    [ic_ocorrencia]              CHAR (1)     NULL,
    [cd_ocorrencia_tipo_assunto] INT          NULL,
    [nm_assunto_ocorrencia]      VARCHAR (40) NULL,
    [cd_tipo_destinatario]       INT          NULL,
    CONSTRAINT [PK_Parametro_Historico_Cliente] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Historico_Cliente_Ocorrencia_Tipo_Assunto] FOREIGN KEY ([cd_ocorrencia_tipo_assunto]) REFERENCES [dbo].[Ocorrencia_Tipo_Assunto] ([cd_tipo_assunto]),
    CONSTRAINT [FK_Parametro_Historico_Cliente_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario])
);

