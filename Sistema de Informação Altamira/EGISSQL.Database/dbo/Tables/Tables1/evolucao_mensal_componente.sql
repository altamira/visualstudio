CREATE TABLE [dbo].[evolucao_mensal_componente] (
    [dt_base_evolucao_mensal]   DATETIME   NOT NULL,
    [cd_grupo_produto]          INT        NOT NULL,
    [cd_produto]                INT        NOT NULL,
    [cd_moeda]                  INT        NOT NULL,
    [cd_condicao_pagamento]     INT        NOT NULL,
    [vl_uni_estimado_reposicao] MONEY      NOT NULL,
    [pc_imposto_composto]       FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_evolucao_mensal_componente] PRIMARY KEY CLUSTERED ([dt_base_evolucao_mensal] ASC, [cd_grupo_produto] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_evolucao_mensal_componente_Condicao_Pagamento] FOREIGN KEY ([cd_condicao_pagamento]) REFERENCES [dbo].[Condicao_Pagamento] ([cd_condicao_pagamento]),
    CONSTRAINT [FK_evolucao_mensal_componente_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

