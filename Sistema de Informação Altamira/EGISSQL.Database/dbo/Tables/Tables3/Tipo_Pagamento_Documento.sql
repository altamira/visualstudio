CREATE TABLE [dbo].[Tipo_Pagamento_Documento] (
    [cd_tipo_pagamento]         INT          NOT NULL,
    [nm_tipo_pagamento]         VARCHAR (30) NOT NULL,
    [sg_tipo_pagamento]         CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [cd_tipo_documento_pagamen] INT          NULL,
    [nm_tipo_documento_pagamen] VARCHAR (30) NULL,
    [sg_tipo_documento_pagamen] CHAR (10)    NULL,
    [ic_pad_tipo_pagamento]     CHAR (1)     NULL,
    [ic_fechamento_cambio]      CHAR (1)     NULL,
    [cd_conta]                  INT          NULL,
    [ic_caixa_tipo_pagamento]   CHAR (1)     NULL,
    [ic_fluxo_tipo_pagamento]   CHAR (1)     NULL,
    [ic_zera_tipo_pagamento]    CHAR (1)     NULL,
    [ic_mov_tipo_pagamento]     CHAR (1)     NULL,
    [cd_situacao_documento]     INT          NULL,
    CONSTRAINT [PK_Tipo_Pagamento_Documento] PRIMARY KEY CLUSTERED ([cd_tipo_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Pagamento_Documento_Situacao_Documento_Pagar] FOREIGN KEY ([cd_situacao_documento]) REFERENCES [dbo].[Situacao_Documento_Pagar] ([cd_situacao_documento])
);

