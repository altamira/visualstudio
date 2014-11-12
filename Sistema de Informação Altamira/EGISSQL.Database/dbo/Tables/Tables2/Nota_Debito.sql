CREATE TABLE [dbo].[Nota_Debito] (
    [cd_nota_debito]            INT          NOT NULL,
    [dt_nota_debito]            DATETIME     NOT NULL,
    [dt_vencimento_nota_debito] DATETIME     NOT NULL,
    [dt_pagamento_nota_debito]  DATETIME     NOT NULL,
    [vl_nota_debito]            FLOAT (53)   NOT NULL,
    [vl_pagamento_nota_debito]  FLOAT (53)   NOT NULL,
    [ic_emissao_nota_debito]    CHAR (1)     NOT NULL,
    [dt_cancelamento_nota_debi] DATETIME     NOT NULL,
    [nm_cancelamento_nota_debi] VARCHAR (30) NOT NULL,
    [cd_cliente]                INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Nota_Debito] PRIMARY KEY CLUSTERED ([cd_nota_debito] ASC) WITH (FILLFACTOR = 90)
);

