CREATE TABLE [dbo].[Solicitacao_Pagamento_Baixa] (
    [cd_solicitacao]         INT          NOT NULL,
    [cd_item_baixa]          INT          NOT NULL,
    [dt_baixa_pagamento]     DATETIME     NULL,
    [vl_baixa_pagamento]     FLOAT (53)   NULL,
    [nm_obs_baixa_pagamento] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Solicitacao_Pagamento_Baixa] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC, [cd_item_baixa] ASC) WITH (FILLFACTOR = 90)
);

