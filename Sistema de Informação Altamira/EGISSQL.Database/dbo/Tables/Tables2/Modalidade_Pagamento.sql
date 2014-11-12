CREATE TABLE [dbo].[Modalidade_Pagamento] (
    [cd_modalidade_pagamento]   INT          NOT NULL,
    [nm_modalidade_pagamento]   VARCHAR (30) NOT NULL,
    [sg_modalidade_pagamento]   CHAR (10)    NULL,
    [ds_modalidade_pagamento]   TEXT         NOT NULL,
    [ic_comex_modalidade_pagto] CHAR (1)     NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [sg_modalidade_pagemento]   CHAR (10)    NULL,
    [ic_pad_modalidade_pagto]   CHAR (1)     NULL,
    [ic_ativo_modalidade]       CHAR (1)     NULL,
    [ic_desconto_modalidade]    FLOAT (53)   NULL,
    [nm_obs_modalidade]         VARCHAR (40) NULL,
    [qt_desconto_modalidade]    FLOAT (53)   NULL,
    CONSTRAINT [PK_Modalidade_Pagamento] PRIMARY KEY CLUSTERED ([cd_modalidade_pagamento] ASC) WITH (FILLFACTOR = 90)
);

