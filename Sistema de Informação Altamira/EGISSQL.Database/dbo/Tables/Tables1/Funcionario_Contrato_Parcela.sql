CREATE TABLE [dbo].[Funcionario_Contrato_Parcela] (
    [cd_contrato_funcionario]  INT        NOT NULL,
    [cd_parcela_contrato]      CHAR (18)  NOT NULL,
    [pc_juro_parcela_contrato] FLOAT (53) NOT NULL,
    [vl_parcela_contrato]      FLOAT (53) NOT NULL,
    [ic_folha_parcela]         CHAR (18)  NOT NULL,
    [dt_pagto_parcela]         DATETIME   NOT NULL,
    [cd_usuario]               INT        NOT NULL,
    [dt_usuario]               DATETIME   NOT NULL,
    CONSTRAINT [PK_Funcionario_Contrato_Parcela] PRIMARY KEY CLUSTERED ([cd_contrato_funcionario] ASC, [cd_parcela_contrato] ASC) WITH (FILLFACTOR = 90)
);

