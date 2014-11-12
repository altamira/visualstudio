CREATE TABLE [dbo].[Campo_Recibo_Pagamento] (
    [cd_campo_recibo_pagamento] INT          NOT NULL,
    [nm_campo_recibo_pagamento] VARCHAR (50) NULL,
    [ds_campo_recibo_pagamento] TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Campo_Recibo_Pagamento] PRIMARY KEY CLUSTERED ([cd_campo_recibo_pagamento] ASC) WITH (FILLFACTOR = 90)
);

