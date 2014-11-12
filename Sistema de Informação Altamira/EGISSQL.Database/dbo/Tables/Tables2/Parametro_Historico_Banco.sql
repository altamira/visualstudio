CREATE TABLE [dbo].[Parametro_Historico_Banco] (
    [cd_empresa]                 INT          NOT NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_operador]                CHAR (1)     NULL,
    [ic_contato]                 CHAR (1)     NULL,
    [ic_assunto]                 CHAR (1)     NULL,
    [ic_descritivo]              CHAR (1)     NULL,
    [ic_historico]               CHAR (1)     NULL,
    [cd_ocorrencia_tipo_assunto] INT          NULL,
    [ic_ocorrencia]              CHAR (1)     NULL,
    [nm_assunto_ocorrencia]      VARCHAR (40) NULL,
    [cd_tipo_destinatario]       INT          NULL,
    CONSTRAINT [PK_Parametro_Historico_Banco] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

