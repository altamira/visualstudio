﻿CREATE TABLE [dbo].[Remessa_Viagem] (
    [CD_REMESSA_VIAGEM]      INT           NOT NULL,
    [DT_REMESSA_VIAGEM]      DATETIME      NULL,
    [CD_TRANSPORTADORA]      INT           NULL,
    [QT_KM_INICIAL]          FLOAT (53)    NULL,
    [QT_KM_FINAL]            FLOAT (53)    NULL,
    [NM_REMESSA_VIAGEM]      VARCHAR (100) NULL,
    [CD_COND_PAGTO_DESPESA]  INT           NULL,
    [CD_USUARIO]             INT           NULL,
    [DT_USUARIO]             DATETIME      NULL,
    [ic_fechada_remessa]     CHAR (1)      NULL,
    [dt_previsao_chegada]    DATETIME      NULL,
    [CD_CLIENTE]             INT           NULL,
    [CD_FROTA]               INT           NULL,
    [CD_VEICULO]             INT           NULL,
    [CD_MOTORISTA]           INT           NULL,
    [dt_previsao_saida]      DATETIME      NULL,
    [vl_KM_RODADO]           FLOAT (53)    NULL,
    [ic_quinzena]            CHAR (20)     NULL,
    [qt_entregas]            FLOAT (53)    NULL,
    [qt_veiculos]            FLOAT (53)    NULL,
    [CD_VIAGEM]              INT           NULL,
    [CD_LOCAL_CHEGADA]       INT           NULL,
    [CD_COND_PAGTO_RECEITA]  INT           NULL,
    [CD_LOCAL_DESLOCAMENTO]  INT           NULL,
    [qt_km_real_chegada]     FLOAT (53)    NULL,
    [dt_chegada]             DATETIME      NULL,
    [dt_fechamento_viagem]   DATETIME      NULL,
    [qt_consumo_combustivel] FLOAT (53)    NULL,
    CONSTRAINT [PK_Remessa_Viagem] PRIMARY KEY CLUSTERED ([CD_REMESSA_VIAGEM] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Remessa_Viagem_Local_Saida] FOREIGN KEY ([CD_LOCAL_DESLOCAMENTO]) REFERENCES [dbo].[Local_Saida] ([cd_local_saida])
);

