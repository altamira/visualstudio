CREATE TABLE [dbo].[Diario_Caixa_Veiculo_Pagamento] (
    [cd_diario_pagamento]     INT          NOT NULL,
    [cd_diario_caixa]         INT          NOT NULL,
    [cd_forma_pagamento]      INT          NOT NULL,
    [vl_diario_pagamento]     FLOAT (53)   NULL,
    [nm_obs_diario_pagamento] VARCHAR (40) NULL,
    [qt_diario_pagamento]     FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Diario_Caixa_Veiculo_Pagamento] PRIMARY KEY CLUSTERED ([cd_diario_pagamento] ASC, [cd_diario_caixa] ASC, [cd_forma_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Diario_Caixa_Veiculo_Pagamento_Forma_Pagamento] FOREIGN KEY ([cd_forma_pagamento]) REFERENCES [dbo].[Forma_Pagamento] ([cd_forma_pagamento])
);

