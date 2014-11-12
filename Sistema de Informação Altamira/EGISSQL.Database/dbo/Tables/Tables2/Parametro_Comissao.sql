CREATE TABLE [dbo].[Parametro_Comissao] (
    [cd_parametro_comissao]      INT        NOT NULL,
    [dt_base_comissao]           DATETIME   NOT NULL,
    [cd_tipo_parametro_comis]    INT        NULL,
    [cd_usuario]                 INT        NOT NULL,
    [dt_usuario]                 DATETIME   NULL,
    [ic_consistencia_comissao]   CHAR (1)   NOT NULL,
    [ic_consistencia_automatica] CHAR (1)   NULL,
    [cd_plano_financeiro]        INT        NULL,
    [ic_consistencia_automatic]  CHAR (1)   NULL,
    [cd_lancamento_padrao]       INT        NULL,
    [qt_dia_pagamento_comissao]  INT        NULL,
    [pc_comissao_empresa]        FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Comissao] PRIMARY KEY CLUSTERED ([cd_parametro_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Comissao_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao]),
    CONSTRAINT [FK_Parametro_Comissao_Tipo_Parametro_Comissao] FOREIGN KEY ([cd_tipo_parametro_comis]) REFERENCES [dbo].[Tipo_Parametro_Comissao] ([cd_tipo_parametro_comis])
);

