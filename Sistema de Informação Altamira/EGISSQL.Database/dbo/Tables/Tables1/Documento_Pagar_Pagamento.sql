CREATE TABLE [dbo].[Documento_Pagar_Pagamento] (
    [cd_documento_pagar]           INT          NOT NULL,
    [cd_item_pagamento]            INT          NOT NULL,
    [dt_pagamento_documento]       DATETIME     NULL,
    [vl_pagamento_documento]       FLOAT (53)   NULL,
    [cd_identifica_documento]      VARCHAR (30) NULL,
    [vl_juros_documento_pagar]     FLOAT (53)   NULL,
    [vl_desconto_documento]        FLOAT (53)   NULL,
    [vl_abatimento_documento]      FLOAT (53)   NULL,
    [cd_recibo_documento]          VARCHAR (10) NULL,
    [cd_tipo_pagamento]            INT          NULL,
    [nm_obs_documento_pagar]       VARCHAR (60) NULL,
    [ic_deposito_conta]            CHAR (1)     NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [dt_fluxo_doc_pagar_pagto]     DATETIME     NULL,
    [cd_conta_banco]               INT          NULL,
    [nm_contrato_cambio]           VARCHAR (20) NULL,
    [dt_moeda]                     DATETIME     NULL,
    [vl_moeda]                     FLOAT (53)   NULL,
    [vl_tarifa_contrato_cambio]    FLOAT (53)   NULL,
    [cd_fechamento_cambio]         INT          NULL,
    [cd_contrato_cambio]           INT          NULL,
    [cd_moeda]                     INT          NULL,
    [ic_fechamento_cambio]         CHAR (1)     NULL,
    [cd_lancamento]                INT          NULL,
    [cd_lancamento_caixa]          INT          NULL,
    [cd_tipo_caixa]                INT          NULL,
    [vl_multa_documento_pagamento] FLOAT (53)   NULL,
    [nm_obs_compl_documento]       VARCHAR (60) NULL,
    CONSTRAINT [PK_Documento_Pagar_Pagamento] PRIMARY KEY CLUSTERED ([cd_documento_pagar] ASC, [cd_item_pagamento] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_pagamento_documento]
    ON [dbo].[Documento_Pagar_Pagamento]([dt_pagamento_documento] ASC) WITH (FILLFACTOR = 90);

