CREATE TABLE [dbo].[Forma_Pagamento] (
    [cd_forma_pagamento]         INT          NOT NULL,
    [nm_forma_pagamento]         VARCHAR (40) NULL,
    [sg_forma_pagamento]         CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_tipo_forma_pagamento]    CHAR (1)     NULL,
    [ic_caixa_forma_pagamento]   CHAR (1)     NULL,
    [ic_boleto_forma_pagamento]  CHAR (1)     NULL,
    [ic_nota_forma_pagamento]    CHAR (1)     NULL,
    [ic_credito_forma_pagamento] CHAR (1)     NULL,
    CONSTRAINT [PK_Forma_Pagamento] PRIMARY KEY CLUSTERED ([cd_forma_pagamento] ASC) WITH (FILLFACTOR = 90)
);

