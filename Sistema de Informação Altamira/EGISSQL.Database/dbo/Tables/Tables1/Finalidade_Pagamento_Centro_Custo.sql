CREATE TABLE [dbo].[Finalidade_Pagamento_Centro_Custo] (
    [cd_centro_custo]         INT      NOT NULL,
    [cd_finalidade_pagamento] INT      NOT NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Finalidade_Pagamento_Centro_Custo] PRIMARY KEY CLUSTERED ([cd_centro_custo] ASC, [cd_finalidade_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Finalidade_Pagamento_Centro_Custo_Finalidade_Pagamento] FOREIGN KEY ([cd_finalidade_pagamento]) REFERENCES [dbo].[Finalidade_Pagamento] ([cd_finalidade_pagamento])
);

