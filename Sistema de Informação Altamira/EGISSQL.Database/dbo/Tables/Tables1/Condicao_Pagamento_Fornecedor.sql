CREATE TABLE [dbo].[Condicao_Pagamento_Fornecedor] (
    [cd_condicao_pagamento]     INT          NOT NULL,
    [cd_fornecedor]             INT          NOT NULL,
    [pc_desc_comercial_fornec]  FLOAT (53)   NOT NULL,
    [pc_desc_financeiro_fornec] FLOAT (53)   NOT NULL,
    [nm_obs_cond_pagto_fornec]  VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Condicao_Pagamento_Fornecedor] PRIMARY KEY CLUSTERED ([cd_condicao_pagamento] ASC, [cd_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

