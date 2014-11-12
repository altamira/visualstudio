CREATE TABLE [dbo].[Imposto_Simples] (
    [cd_imposto_simples]     INT          NOT NULL,
    [pc_total_imposto]       FLOAT (53)   NULL,
    [vl_faturamento_inicial] FLOAT (53)   NULL,
    [vl_faturamento_final]   FLOAT (53)   NULL,
    [nm_obs_imposto]         VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [pc_irpj]                FLOAT (53)   NULL,
    [pc_csll]                FLOAT (53)   NULL,
    [pc_cofins]              FLOAT (53)   NULL,
    [pc_pis]                 FLOAT (53)   NULL,
    [pc_inss]                FLOAT (53)   NULL,
    [pc_icms]                FLOAT (53)   NULL,
    [pc_ipi]                 FLOAT (53)   NULL,
    [cd_dispositivo_legal]   INT          NULL,
    [nm_imposto_simples]     VARCHAR (60) NULL,
    CONSTRAINT [PK_Imposto_Simples] PRIMARY KEY CLUSTERED ([cd_imposto_simples] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Imposto_Simples_Dispositivo_Legal] FOREIGN KEY ([cd_dispositivo_legal]) REFERENCES [dbo].[Dispositivo_Legal] ([cd_dispositivo_legal])
);

