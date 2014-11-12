CREATE TABLE [dbo].[Finalidade_Pagamento] (
    [cd_finalidade_pagamento]     INT          NOT NULL,
    [nm_finalidade_pagamento]     VARCHAR (40) NULL,
    [sg_finalidade_pagamento]     CHAR (10)    NULL,
    [qt_vencimento_finalidade]    FLOAT (53)   NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_pad_finalidade_pagamento] CHAR (1)     NULL,
    [ic_tipo_finalidade]          CHAR (1)     NULL,
    [cd_conta]                    INT          NULL,
    [cd_tipo_despesa]             INT          NULL,
    CONSTRAINT [PK_Finalidade_Pagamento] PRIMARY KEY CLUSTERED ([cd_finalidade_pagamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Finalidade_Pagamento_Tipo_Despesa] FOREIGN KEY ([cd_tipo_despesa]) REFERENCES [dbo].[Tipo_Despesa] ([cd_tipo_despesa])
);

