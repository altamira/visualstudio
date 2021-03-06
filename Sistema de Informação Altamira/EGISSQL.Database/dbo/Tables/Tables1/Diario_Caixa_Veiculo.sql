﻿CREATE TABLE [dbo].[Diario_Caixa_Veiculo] (
    [cd_diario_caixa]       INT          NOT NULL,
    [dt_diario_caixa]       DATETIME     NULL,
    [dt_entrega_diario]     DATETIME     NULL,
    [cd_veiculo]            INT          NULL,
    [cd_motorista]          INT          NULL,
    [vl_estorno_diario]     FLOAT (53)   NULL,
    [vl_devolucao_diario]   FLOAT (53)   NULL,
    [vl_repasse_diario]     FLOAT (53)   NULL,
    [vl_total_diario]       FLOAT (53)   NULL,
    [vl_total_prazo_diario] FLOAT (53)   NULL,
    [vl_total_vista_diario] FLOAT (53)   NULL,
    [vl_saldo_diario]       FLOAT (53)   NULL,
    [vl_recebido_diario]    FLOAT (53)   NULL,
    [nm_obs_diario_caixa]   VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [qt_nota_diario]        FLOAT (53)   NULL,
    [qt_entrega_diario]     FLOAT (53)   NULL,
    [cd_interface]          INT          NULL,
    [dt_faturamento_diario] DATETIME     NULL,
    CONSTRAINT [PK_Diario_Caixa_Veiculo] PRIMARY KEY CLUSTERED ([cd_diario_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Diario_Caixa_Veiculo_Motorista] FOREIGN KEY ([cd_motorista]) REFERENCES [dbo].[Motorista] ([cd_motorista])
);

