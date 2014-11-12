CREATE TABLE [dbo].[Tipo_Calculo_Folha] (
    [cd_tipo_calculo_folha]      INT          NOT NULL,
    [nm_tipo_calculo_folha]      VARCHAR (40) NULL,
    [sg_tipo_calculo_folha]      CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_ordem_tipo_calculo]      INT          NULL,
    [cd_forma_calculo]           CHAR (2)     NULL,
    [cd_evento]                  INT          NULL,
    [ic_gera_movimento]          CHAR (1)     NULL,
    [cd_tipo_ap]                 INT          NULL,
    [sg_identificacao_documento] CHAR (5)     NULL,
    [qt_dia_pagamento]           INT          NULL,
    [ic_impostos_folha]          CHAR (1)     NULL,
    [cd_tipo_regime]             INT          NULL,
    CONSTRAINT [PK_Tipo_Calculo_Folha] PRIMARY KEY CLUSTERED ([cd_tipo_calculo_folha] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Calculo_Folha_Evento_Folha] FOREIGN KEY ([cd_evento]) REFERENCES [dbo].[Evento_Folha] ([cd_evento]),
    CONSTRAINT [FK_Tipo_Calculo_Folha_Tipo_Autorizacao_Pagamento] FOREIGN KEY ([cd_tipo_ap]) REFERENCES [dbo].[Tipo_Autorizacao_Pagamento] ([cd_tipo_ap]),
    CONSTRAINT [FK_Tipo_Calculo_Folha_Tipo_Regime_Funcionario] FOREIGN KEY ([cd_tipo_regime]) REFERENCES [dbo].[Tipo_Regime_Funcionario] ([cd_tipo_regime])
);

