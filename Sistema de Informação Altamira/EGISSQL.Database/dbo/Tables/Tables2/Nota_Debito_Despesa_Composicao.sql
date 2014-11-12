CREATE TABLE [dbo].[Nota_Debito_Despesa_Composicao] (
    [cd_nota_debito_despesa]  INT          NOT NULL,
    [cd_item_nota_despesa]    INT          NOT NULL,
    [cd_tipo_despesa]         INT          NULL,
    [qt_nota_debito]          FLOAT (53)   NULL,
    [vl_item_nota_debito]     FLOAT (53)   NULL,
    [nm_obs_item_nota_debito] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [dt_despesa]              DATETIME     NULL,
    [cd_documento_despesa]    VARCHAR (15) NULL,
    [ic_empresa_despesa]      CHAR (1)     NULL,
    [ic_cliente_despesa]      CHAR (1)     NULL,
    [ic_consultor_despesa]    CHAR (1)     NULL,
    CONSTRAINT [PK_Nota_Debito_Despesa_Composicao] PRIMARY KEY CLUSTERED ([cd_nota_debito_despesa] ASC, [cd_item_nota_despesa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_Debito_Despesa_Composicao_Tipo_Despesa] FOREIGN KEY ([cd_tipo_despesa]) REFERENCES [dbo].[Tipo_Despesa] ([cd_tipo_despesa])
);

