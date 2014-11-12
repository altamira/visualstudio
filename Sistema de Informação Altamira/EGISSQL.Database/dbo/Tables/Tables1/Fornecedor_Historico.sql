CREATE TABLE [dbo].[Fornecedor_Historico] (
    [cd_fornecedor]           INT          NOT NULL,
    [cd_tipo_contato]         INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_sequencia_historico]  INT          NOT NULL,
    [dt_historico_lancamento] DATETIME     NULL,
    [ds_historico_lancamento] TEXT         NULL,
    [dt_historico_retorno]    DATETIME     NULL,
    [cd_concorrente]          INT          NULL,
    [dt_real_retorno]         DATETIME     NULL,
    [cd_contato_fornecedor]   INT          NULL,
    [cd_comprador]            INT          NULL,
    [cd_fornecedor_fase]      INT          NULL,
    [cd_ocorrencia]           INT          NULL,
    [cd_fornecedor_assunto]   INT          NULL,
    [nm_assunto]              VARCHAR (40) NULL,
    [ds_fornecedor_historico] TEXT         NULL,
    [cd_registro_contato]     INT          NULL,
    CONSTRAINT [PK_Fornecedor_Historico] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_sequencia_historico] ASC) WITH (FILLFACTOR = 90)
);

