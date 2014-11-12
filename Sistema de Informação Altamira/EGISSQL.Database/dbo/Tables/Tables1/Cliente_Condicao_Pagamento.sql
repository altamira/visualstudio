CREATE TABLE [dbo].[Cliente_Condicao_Pagamento] (
    [cd_cliente]            INT      NOT NULL,
    [cd_condicao_pagamento] INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Cliente_Condicao_Pagamento] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_condicao_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Condicao_Pagamento_Condicao_Pagamento] FOREIGN KEY ([cd_condicao_pagamento]) REFERENCES [dbo].[Condicao_Pagamento] ([cd_condicao_pagamento])
);

