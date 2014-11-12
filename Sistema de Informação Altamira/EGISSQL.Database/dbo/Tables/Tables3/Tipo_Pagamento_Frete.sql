CREATE TABLE [dbo].[Tipo_Pagamento_Frete] (
    [cd_tipo_pagamento_frete]   INT          NOT NULL,
    [nm_tipo_pagamento_frete]   VARCHAR (30) NOT NULL,
    [sg_tipo_pagamento_frete]   CHAR (10)    NOT NULL,
    [cd_identifica_nota_fiscal] CHAR (1)     NOT NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [ic_tipo_pagamento_frete]   CHAR (1)     NULL,
    [ic_pagar_pagamento_frete]  CHAR (1)     NULL,
    [cd_sped_fiscal]            VARCHAR (15) NULL,
    CONSTRAINT [PK_Tipo_Pagamento_Frete] PRIMARY KEY CLUSTERED ([cd_tipo_pagamento_frete] ASC) WITH (FILLFACTOR = 90)
);

