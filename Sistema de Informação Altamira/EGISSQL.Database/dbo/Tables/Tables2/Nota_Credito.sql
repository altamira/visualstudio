CREATE TABLE [dbo].[Nota_Credito] (
    [cd_nota_credito]           INT          NULL,
    [dt_emissao_nota_credito]   DATETIME     NULL,
    [dt_vencto_nota_credito]    DATETIME     NULL,
    [vl_nota_credito]           FLOAT (53)   NULL,
    [ds_nota_credito]           TEXT         NULL,
    [ic_emitida_nota_credito]   CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_cliente]                INT          NULL,
    [nm_motivo_cancelamento]    VARCHAR (30) NULL,
    [dt_cancelamento_nota_cred] DATETIME     NULL,
    [vl_pagamento_nota_credito] FLOAT (53)   NULL,
    [dt_pagamento_nota_credito] DATETIME     NULL
);

