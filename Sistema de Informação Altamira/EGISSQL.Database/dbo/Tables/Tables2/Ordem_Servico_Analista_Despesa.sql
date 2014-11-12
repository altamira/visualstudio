CREATE TABLE [dbo].[Ordem_Servico_Analista_Despesa] (
    [cd_ordem_servico]       INT          NOT NULL,
    [cd_item_despesa_ordem]  INT          NOT NULL,
    [cd_tipo_despesa]        INT          NULL,
    [nm_obs_tipo_despesa]    VARCHAR (40) NULL,
    [qt_item_despesa_ordem]  FLOAT (53)   NULL,
    [vl_item_despesa_ordem]  FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_empresa_despesa]     CHAR (1)     NULL,
    [ic_cliente_despesa]     CHAR (1)     NULL,
    [cd_documento_despesa]   VARCHAR (15) NULL,
    [dt_despesa]             DATETIME     NULL,
    [ic_consultor_despesa]   CHAR (1)     NULL,
    [cd_documento_pagar]     INT          NULL,
    [cd_nota_debito_despesa] INT          NULL,
    [dt_vencimento_despesa]  DATETIME     NULL,
    CONSTRAINT [PK_Ordem_Servico_Analista_Despesa] PRIMARY KEY CLUSTERED ([cd_ordem_servico] ASC, [cd_item_despesa_ordem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ordem_Servico_Analista_Despesa_Tipo_Despesa] FOREIGN KEY ([cd_tipo_despesa]) REFERENCES [dbo].[Tipo_Despesa] ([cd_tipo_despesa])
);

