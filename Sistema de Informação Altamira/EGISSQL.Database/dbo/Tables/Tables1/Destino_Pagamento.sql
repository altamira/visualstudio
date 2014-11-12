CREATE TABLE [dbo].[Destino_Pagamento] (
    [cd_destino_pagamento] INT          NOT NULL,
    [nm_destino_pagamento] VARCHAR (40) NULL,
    [sg_destino_pagamento] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Destino_Pagamento] PRIMARY KEY CLUSTERED ([cd_destino_pagamento] ASC) WITH (FILLFACTOR = 90)
);

