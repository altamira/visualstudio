CREATE TABLE [dbo].[Meio_Pagamento] (
    [cd_meio_pagamento] INT          NOT NULL,
    [nm_meio_pagamento] VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Meio_Pagamento] PRIMARY KEY CLUSTERED ([cd_meio_pagamento] ASC) WITH (FILLFACTOR = 90)
);

