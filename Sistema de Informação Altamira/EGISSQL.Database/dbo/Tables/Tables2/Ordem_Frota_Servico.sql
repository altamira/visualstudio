CREATE TABLE [dbo].[Ordem_Frota_Servico] (
    [cd_ordem]              INT          NOT NULL,
    [dt_ordem]              DATETIME     NULL,
    [cd_veiculo]            INT          NULL,
    [cd_oficina]            INT          NULL,
    [cd_fornecedor]         INT          NULL,
    [cd_tipo_ordem]         INT          NULL,
    [qt_dia_ordem]          FLOAT (53)   NULL,
    [cd_condicao_pagamento] INT          NULL,
    [vl_ordem]              FLOAT (53)   NULL,
    [ds_ordem]              TEXT         NULL,
    [nm_obs_ordem]          VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [dt_baixa_ordem]        DATETIME     NULL,
    [cd_nota_entrada]       INT          NULL,
    [dt_inicio_ordem]       DATETIME     NULL,
    [dt_fim_ordem]          DATETIME     NULL,
    [cd_tipo_prioridade]    INT          NULL,
    [dt_necessidade_ordem]  DATETIME     NULL,
    [cd_tipo_manutencao]    INT          NULL,
    CONSTRAINT [PK_Ordem_Frota_Servico] PRIMARY KEY CLUSTERED ([cd_ordem] ASC) WITH (FILLFACTOR = 90)
);

