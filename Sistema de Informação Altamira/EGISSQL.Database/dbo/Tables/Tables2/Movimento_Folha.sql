CREATE TABLE [dbo].[Movimento_Folha] (
    [cd_lancamento_folha]      INT          NOT NULL,
    [dt_lancamento_folha]      DATETIME     NULL,
    [cd_tipo_lancamento_folha] INT          NULL,
    [cd_funcionario]           INT          NULL,
    [vl_lancamento_folha]      FLOAT (53)   NULL,
    [vl_hora_folha]            FLOAT (53)   NULL,
    [nm_obs_lancamento_folha]  VARCHAR (60) NULL,
    [cd_evento]                INT          NULL,
    [cd_historico_folha]       INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [ic_tipo_lancamento]       CHAR (1)     NULL,
    [cd_controle]              INT          NULL,
    [cd_tipo_calculo_folha]    INT          NULL,
    [dt_base_calculo_folha]    DATETIME     NULL,
    [dt_pagto_calculo_folha]   DATETIME     NULL,
    [cd_controle_folha]        INT          NULL,
    [cd_movimento_evento]      INT          NULL,
    CONSTRAINT [PK_Movimento_Folha] PRIMARY KEY CLUSTERED ([cd_lancamento_folha] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Folha_Historico_Folha] FOREIGN KEY ([cd_historico_folha]) REFERENCES [dbo].[Historico_Folha] ([cd_historico_folha])
);

