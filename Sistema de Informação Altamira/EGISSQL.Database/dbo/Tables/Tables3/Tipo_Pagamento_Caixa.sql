CREATE TABLE [dbo].[Tipo_Pagamento_Caixa] (
    [cd_tipo_pagamento]          INT          NOT NULL,
    [nm_tipo_pagamento]          VARCHAR (40) NULL,
    [ic_tipo]                    CHAR (3)     NULL,
    [ic_baixa_autom_cta_receb]   CHAR (1)     NULL,
    [cd_plano_financeiro]        INT          NULL,
    [cd_portador]                INT          NULL,
    [cd_tipo_pagamento_cupom]    CHAR (2)     NULL,
    [qt_dia_vcto_cartao_credito] INT          NULL,
    [pc_adm_cartao_credito]      FLOAT (53)   NULL,
    [ic_padrao_tipo_pagamento]   CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Pagamento_Caixa] PRIMARY KEY CLUSTERED ([cd_tipo_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Pagamento_Caixa_Portador] FOREIGN KEY ([cd_portador]) REFERENCES [dbo].[Portador] ([cd_portador])
);

