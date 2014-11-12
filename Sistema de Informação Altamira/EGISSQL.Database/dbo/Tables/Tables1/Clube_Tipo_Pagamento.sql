CREATE TABLE [dbo].[Clube_Tipo_Pagamento] (
    [cd_tipo_pagamento] INT          NOT NULL,
    [nm_tipo_pagamento] VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Clube_Tipo_Pagamento] PRIMARY KEY CLUSTERED ([cd_tipo_pagamento] ASC)
);

