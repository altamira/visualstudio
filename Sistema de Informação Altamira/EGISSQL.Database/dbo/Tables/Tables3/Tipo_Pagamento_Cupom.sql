CREATE TABLE [dbo].[Tipo_Pagamento_Cupom] (
    [cd_tipo_pagamento_cupom] INT          NOT NULL,
    [nm_tipo_pagamento_cupom] VARCHAR (20) NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_usuario]              INT          NULL,
    [sg_tipo_pagamento_cupom] CHAR (10)    NULL,
    CONSTRAINT [PK_Tipo_Pagamento_Cupom] PRIMARY KEY CLUSTERED ([cd_tipo_pagamento_cupom] ASC) WITH (FILLFACTOR = 90)
);

