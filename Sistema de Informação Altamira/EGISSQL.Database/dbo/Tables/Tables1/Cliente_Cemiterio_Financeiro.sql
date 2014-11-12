CREATE TABLE [dbo].[Cliente_Cemiterio_Financeiro] (
    [cd_cliente]                INT          NOT NULL,
    [cd_cliente_financeiro]     INT          NOT NULL,
    [cd_tipo_pagamento]         INT          NULL,
    [vl_pagto_cliente]          FLOAT (53)   NULL,
    [dt_pagto_cliente]          DATETIME     NULL,
    [nm_obs_cliente_financeiro] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Cemiterio_Financeiro] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_cliente_financeiro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Cemiterio_Financeiro_Tipo_Pagamento_Documento] FOREIGN KEY ([cd_tipo_pagamento]) REFERENCES [dbo].[Tipo_Pagamento_Documento] ([cd_tipo_pagamento])
);

