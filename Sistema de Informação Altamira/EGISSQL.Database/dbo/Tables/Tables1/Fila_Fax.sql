CREATE TABLE [dbo].[Fila_Fax] (
    [cd_consulta]         INT           NOT NULL,
    [dt_geracao_fax]      DATETIME      NOT NULL,
    [nm_arquivo_fax]      VARCHAR (100) NOT NULL,
    [nm_remetente_fax]    VARCHAR (30)  NOT NULL,
    [cd_fax]              CHAR (15)     NOT NULL,
    [nm_cliente_fax]      VARCHAR (40)  NOT NULL,
    [nm_destinatario_fax] VARCHAR (30)  NOT NULL,
    [nm_depto_fax]        VARCHAR (30)  NOT NULL,
    [ic_prioridade_fax]   CHAR (1)      NOT NULL,
    [ic_status_fax]       CHAR (1)      NOT NULL,
    [ic_atualizado_sap]   CHAR (1)      NULL,
    [dt_envio_fax]        DATETIME      NULL,
    [cd_ordem_fax]        INT           NULL,
    [qt_rediscagens_fax]  INT           CONSTRAINT [DF_Fila_Fax_qt_rediscagens_fax] DEFAULT (0) NULL,
    CONSTRAINT [PK_Fila_Fax] PRIMARY KEY NONCLUSTERED ([cd_consulta] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE CLUSTERED INDEX [IX_Fila_Fax]
    ON [dbo].[Fila_Fax]([dt_geracao_fax] ASC, [cd_consulta] ASC) WITH (FILLFACTOR = 90);

