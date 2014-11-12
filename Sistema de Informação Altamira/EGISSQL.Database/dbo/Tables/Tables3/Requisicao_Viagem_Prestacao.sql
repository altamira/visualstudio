CREATE TABLE [dbo].[Requisicao_Viagem_Prestacao] (
    [cd_requisicao_viagem]    INT          NOT NULL,
    [cd_item_prestacao_req]   INT          NOT NULL,
    [cd_tipo_despesa_viagem]  INT          NULL,
    [vl_prestacao_req_viagem] FLOAT (53)   NULL,
    [dt_prestacao_viagem]     DATETIME     NULL,
    [cd_tipo_pagamento]       INT          NULL,
    [ds_observacao_prestacao] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tipo_cartao_credito]  INT          NULL,
    [cd_moeda]                INT          NULL,
    [cd_conta_debito]         INT          NULL,
    [cd_conta_credito]        INT          NULL,
    [nm_historico_prestacao]  VARCHAR (40) NULL,
    CONSTRAINT [PK_Requisicao_Viagem_Prestacao] PRIMARY KEY CLUSTERED ([cd_requisicao_viagem] ASC, [cd_item_prestacao_req] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Viagem_Prestacao_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Requisicao_Viagem_Prestacao_Tipo_Cartao_Credito] FOREIGN KEY ([cd_tipo_cartao_credito]) REFERENCES [dbo].[Tipo_cartao_credito] ([cd_cartao_credito]),
    CONSTRAINT [FK_Requisicao_Viagem_Prestacao_Tipo_Despesa_Viagem] FOREIGN KEY ([cd_tipo_despesa_viagem]) REFERENCES [dbo].[Tipo_Despesa_Viagem] ([cd_despesa_viagem]),
    CONSTRAINT [FK_Requisicao_Viagem_Prestacao_Tipo_Pagamento_Documento] FOREIGN KEY ([cd_tipo_pagamento]) REFERENCES [dbo].[Tipo_Pagamento_Documento] ([cd_tipo_pagamento])
);

