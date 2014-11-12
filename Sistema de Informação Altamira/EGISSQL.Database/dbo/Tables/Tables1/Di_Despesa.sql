CREATE TABLE [dbo].[Di_Despesa] (
    [cd_di]                     INT          NOT NULL,
    [cd_di_despesa]             INT          NOT NULL,
    [cd_tipo_despesa_comex]     INT          NULL,
    [vl_di_despesa]             FLOAT (53)   NULL,
    [ic_di_despesa_ii]          CHAR (1)     NULL,
    [ic_di_despesa_ipi]         CHAR (1)     NULL,
    [ic_di_despesa_icm]         CHAR (1)     NULL,
    [dt_previsao_pagto]         DATETIME     NULL,
    [dt_pagamento]              DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_di_despesa_complemento] VARCHAR (50) NULL,
    [cd_tipo_despesa_di]        INT          NULL,
    [vl_base_rateio_di_despesa] FLOAT (53)   NULL,
    CONSTRAINT [PK_Di_Despesa] PRIMARY KEY CLUSTERED ([cd_di] ASC, [cd_di_despesa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Di_Despesa_Tipo_Despesa_Comex] FOREIGN KEY ([cd_tipo_despesa_comex]) REFERENCES [dbo].[Tipo_Despesa_Comex] ([cd_tipo_despesa_comex])
);

