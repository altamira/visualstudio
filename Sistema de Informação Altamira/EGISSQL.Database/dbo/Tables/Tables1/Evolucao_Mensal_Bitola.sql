CREATE TABLE [dbo].[Evolucao_Mensal_Bitola] (
    [dt_base_evo_mensal_bitola] DATETIME   NOT NULL,
    [cd_mat_prima]              INT        NOT NULL,
    [cd_bitola]                 INT        NOT NULL,
    [cd_condicao_pagamento]     INT        NOT NULL,
    [cd_moeda]                  INT        NOT NULL,
    [vl_uni_estimado_reposicao] FLOAT (53) NOT NULL,
    [pc_icms_bitola]            FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Evolucao_Mensal_Bitola] PRIMARY KEY CLUSTERED ([dt_base_evo_mensal_bitola] ASC, [cd_mat_prima] ASC, [cd_bitola] ASC, [cd_condicao_pagamento] ASC, [cd_moeda] ASC) WITH (FILLFACTOR = 90)
);

