CREATE TABLE [dbo].[Banco_Historico] (
    [cd_banco]                  INT          NOT NULL,
    [cd_sequencia_historico]    INT          NOT NULL,
    [cd_agencia_banco]          INT          NOT NULL,
    [dt_historico_lancamento]   DATETIME     NULL,
    [ds_historico_lancamento]   TEXT         NULL,
    [dt_historico_retorno]      DATETIME     NULL,
    [dt_real_retorno]           DATETIME     NULL,
    [cd_banco_assunto]          INT          NULL,
    [nm_assunto]                VARCHAR (50) NULL,
    [cd_ocorrencia]             INT          NULL,
    [cd_banco_fase]             INT          NULL,
    [cd_contato_agencia]        INT          NULL,
    [cd_tipo_contato]           INT          NULL,
    [ds_banco_historico]        TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_operador_telemarketing] INT          NULL,
    [cd_registro_contato]       INT          NULL,
    CONSTRAINT [PK_Banco_Historico] PRIMARY KEY CLUSTERED ([cd_banco] ASC, [cd_sequencia_historico] ASC, [cd_agencia_banco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Banco_Historico_Banco_Fase] FOREIGN KEY ([cd_banco_fase]) REFERENCES [dbo].[Banco_Fase] ([cd_banco_fase]),
    CONSTRAINT [FK_Banco_Historico_Operador_Telemarketing] FOREIGN KEY ([cd_operador_telemarketing]) REFERENCES [dbo].[Operador_Telemarketing] ([cd_operador_telemarketing])
);

