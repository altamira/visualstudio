CREATE TABLE [dbo].[Ocorrencia_Pagamento] (
    [cd_ocorrencia_pagamento] INT           NOT NULL,
    [nm_ocorrencia_pagamento] VARCHAR (100) NULL,
    [sg_ocorrencia_pagamento] CHAR (10)     NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Ocorrencia_Pagamento] PRIMARY KEY CLUSTERED ([cd_ocorrencia_pagamento] ASC) WITH (FILLFACTOR = 90)
);

