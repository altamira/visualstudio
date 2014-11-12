CREATE TABLE [dbo].[cliente_prospeccao_historico] (
    [cd_cliente_prospeccao]   INT          NOT NULL,
    [cd_sequecia_historico]   INT          NOT NULL,
    [dt_historico_lancamento] DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_historico_lancamento] TEXT         NULL,
    [nm_assunto]              VARCHAR (50) NULL,
    [cd_cliente_fase]         INT          NULL,
    [cd_vendedor]             INT          NULL,
    [cd_contato]              INT          NULL,
    [cd_cliente_assunto]      INT          NULL,
    [cd_concorrente]          INT          NULL,
    [dt_historico_retorno]    DATETIME     NULL,
    [dt_real_retorno]         DATETIME     NULL,
    CONSTRAINT [PK_cliente_prospeccao_historico] PRIMARY KEY CLUSTERED ([cd_cliente_prospeccao] ASC, [cd_sequecia_historico] ASC) WITH (FILLFACTOR = 90)
);

