CREATE TABLE [dbo].[Parametro_Condicao_Pagamento] (
    [cd_parametro_condicao]     INT          NOT NULL,
    [vl_total_inicial]          FLOAT (53)   NULL,
    [vl_total_final]            FLOAT (53)   NULL,
    [cd_condicao_pagamento]     INT          NULL,
    [nm_obs_parametro_condicao] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Parametro_Condicao_Pagamento] PRIMARY KEY CLUSTERED ([cd_parametro_condicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Condicao_Pagamento_Condicao_Pagamento] FOREIGN KEY ([cd_condicao_pagamento]) REFERENCES [dbo].[Condicao_Pagamento] ([cd_condicao_pagamento])
);

