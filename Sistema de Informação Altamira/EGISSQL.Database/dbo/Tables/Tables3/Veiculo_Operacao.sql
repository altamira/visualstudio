﻿CREATE TABLE [dbo].[Veiculo_Operacao] (
    [cd_operacao]            INT          NOT NULL,
    [dt_operacao]            DATETIME     NULL,
    [cd_veiculo]             INT          NULL,
    [cd_motorista]           INT          NULL,
    [cd_local_saida]         INT          NULL,
    [cd_local_chegada]       INT          NULL,
    [dt_saida_operacao]      DATETIME     NULL,
    [dt_chegada_operacao]    DATETIME     NULL,
    [hr_saida_operacao]      VARCHAR (8)  NULL,
    [hr_chegada_operacao]    VARCHAR (8)  NULL,
    [qt_km_inicial_operacao] FLOAT (53)   NULL,
    [qt_km_final_operacao]   FLOAT (53)   NULL,
    [cd_motivo_deslocamento] INT          NULL,
    [ds_operacao]            TEXT         NULL,
    [nm_obs_operacao]        VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_ocorrencia_veiculo]  INT          NULL,
    [cd_requisicao_viagem]   INT          NULL,
    CONSTRAINT [PK_Veiculo_Operacao] PRIMARY KEY CLUSTERED ([cd_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Operacao_Motivo_Deslocamento] FOREIGN KEY ([cd_motivo_deslocamento]) REFERENCES [dbo].[Motivo_Deslocamento] ([cd_motivo_deslocamento]),
    CONSTRAINT [FK_Veiculo_Operacao_Ocorrencia_Veiculo] FOREIGN KEY ([cd_ocorrencia_veiculo]) REFERENCES [dbo].[Ocorrencia_Veiculo] ([cd_ocorrencia_veiculo]),
    CONSTRAINT [FK_Veiculo_Operacao_Requisicao_Viagem] FOREIGN KEY ([cd_requisicao_viagem]) REFERENCES [dbo].[Requisicao_Viagem] ([cd_requisicao_viagem])
);

