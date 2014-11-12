CREATE TABLE [dbo].[Controle_Folha] (
    [cd_controle_folha]     INT        NOT NULL,
    [dt_calculo]            DATETIME   NULL,
    [dt_base]               DATETIME   NULL,
    [dt_pagamento]          DATETIME   NULL,
    [cd_tipo_calculo_folha] INT        NULL,
    [ic_sct]                CHAR (1)   NULL,
    [ic_sfi]                CHAR (1)   NULL,
    [ic_encerrada]          CHAR (1)   NULL,
    [ds_controle]           TEXT       NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [ic_aberto]             CHAR (1)   NULL,
    [vl_arredondamento]     FLOAT (53) NULL,
    [ic_processo]           CHAR (1)   NULL,
    CONSTRAINT [PK_Controle_Folha] PRIMARY KEY CLUSTERED ([cd_controle_folha] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Controle_Folha_Tipo_Calculo_Folha] FOREIGN KEY ([cd_tipo_calculo_folha]) REFERENCES [dbo].[Tipo_Calculo_Folha] ([cd_tipo_calculo_folha])
);

