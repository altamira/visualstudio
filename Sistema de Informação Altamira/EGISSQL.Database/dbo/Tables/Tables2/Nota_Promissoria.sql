CREATE TABLE [dbo].[Nota_Promissoria] (
    [cd_nota_promissoria]     INT          NOT NULL,
    [dt_nota_promissoria]     DATETIME     NULL,
    [dt_vencimento_nota]      DATETIME     NULL,
    [dt_pagamento_nota]       DATETIME     NULL,
    [cd_identificacao_nota]   VARCHAR (15) NULL,
    [vl_nota_promissoria]     FLOAT (53)   NULL,
    [ds_nota_promissoria]     TEXT         NULL,
    [cd_cliente]              INT          NULL,
    [nm_obs_nota_promissoria] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_favorecido_nota]      VARCHAR (50) NULL,
    [cd_cnpj_nota]            VARCHAR (18) NULL,
    [nm_pagamento_nota]       VARCHAR (40) NULL,
    [nm_analista_1]           VARCHAR (60) NULL,
    [nm_analista_2]           VARCHAR (60) NULL,
    [nm_analista_3]           VARCHAR (60) NULL,
    CONSTRAINT [PK_Nota_Promissoria] PRIMARY KEY CLUSTERED ([cd_nota_promissoria] ASC) WITH (FILLFACTOR = 90)
);

