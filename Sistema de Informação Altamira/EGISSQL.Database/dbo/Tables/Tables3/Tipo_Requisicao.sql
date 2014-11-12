CREATE TABLE [dbo].[Tipo_Requisicao] (
    [cd_tipo_requisicao]         INT          NOT NULL,
    [nm_tipo_requisicao]         VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_requisicao]         CHAR (10)    COLLATE Latin1_General_CI_AS NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_tipo_requisicao]         CHAR (1)     NULL,
    [nm_cor_prioridade_bk]       CHAR (15)    NULL,
    [nm_cor_prioridade_fg]       CHAR (15)    NULL,
    [qt_prior_tipo_requisicao]   INT          NULL,
    [ic_pad_tipo_requisicao]     CHAR (1)     NULL,
    [cd_destinacao_produto]      INT          NULL,
    [ic_importacao]              CHAR (1)     NULL,
    [cd_fase_produto]            INT          NULL,
    [ic_servico_tipo_requisicao] CHAR (1)     NULL,
    [ic_frota_requisicao]        CHAR (1)     NULL,
    [cd_motivo_requisicao]       INT          NULL,
    [cd_tipo_pedido]             INT          NULL,
    [ic_gera_pedido_compra]      CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Requisicao] PRIMARY KEY CLUSTERED ([cd_tipo_requisicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Requisicao_Motivo_Requisicao] FOREIGN KEY ([cd_motivo_requisicao]) REFERENCES [dbo].[Motivo_Requisicao] ([cd_motivo_requisicao])
);

