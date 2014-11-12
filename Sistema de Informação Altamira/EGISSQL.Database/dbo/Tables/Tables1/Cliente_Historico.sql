CREATE TABLE [dbo].[Cliente_Historico] (
    [cd_cliente]              INT          NOT NULL,
    [dt_historico_lancamento] DATETIME     NOT NULL,
    [cd_sequencia_historico]  INT          NOT NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_historico_lancamento] TEXT         NULL,
    [nm_assunto]              VARCHAR (50) NULL,
    [cd_cliente_fase]         INT          NULL,
    [cd_vendedor]             INT          NULL,
    [cd_contato]              INT          NULL,
    [cd_cliente_assunto]      INT          NULL,
    [dt_historico_retorno]    DATETIME     NULL,
    [cd_concorrente]          INT          NULL,
    [dt_real_retorno]         DATETIME     NULL,
    [cd_ocorrencia]           INT          NULL,
    [cd_registro_contato]     INT          NULL,
    [cd_controle]             INT          NULL,
    [ds_acao_programada]      TEXT         NULL,
    CONSTRAINT [PK_Cliente_Historico] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_sequencia_historico] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [dt_Cliente_Historico]
    ON [dbo].[Cliente_Historico]([dt_historico_lancamento] ASC) WITH (FILLFACTOR = 90);

