CREATE TABLE [dbo].[Tipo_Pagamento_Contabilizacao] (
    [cd_tipo_pagto_contabilizacao] INT      NOT NULL,
    [cd_tipo_pagamento]            INT      NULL,
    [cd_banco]                     INT      NULL,
    [cd_tipo_conta_pagar]          INT      NULL,
    [cd_lancamento_pagamento]      INT      NULL,
    [cd_lancamento_juros]          INT      NULL,
    [cd_lancamento_desconto]       INT      NULL,
    [cd_lancamento_abatimento]     INT      NULL,
    [cd_lancamento_devolucao]      INT      NULL,
    [cd_usuario]                   INT      NULL,
    [dt_usuario]                   DATETIME NULL,
    CONSTRAINT [PK_Tipo_Pagamento_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_tipo_pagto_contabilizacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Pagamento_Contabilizacao_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_devolucao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

