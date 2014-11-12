CREATE TABLE [dbo].[Fechamento_Caixa_Composicao] (
    [cd_fechamento_caixa]      INT        NOT NULL,
    [cd_item_fechamento_caixa] INT        NOT NULL,
    [cd_tipo_objeto_caixa]     INT        NULL,
    [qt_item_fechamento_caixa] FLOAT (53) NULL,
    [vl_item_fechamento_caixa] MONEY      NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [ic_correto]               CHAR (1)   NULL,
    [vl_real_movimento_caixa]  MONEY      NULL,
    CONSTRAINT [PK_Fechamento_Caixa_Composicao] PRIMARY KEY CLUSTERED ([cd_fechamento_caixa] ASC, [cd_item_fechamento_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fechamento_Caixa_Composicao_Fechamento_Caixa] FOREIGN KEY ([cd_fechamento_caixa]) REFERENCES [dbo].[Fechamento_Caixa] ([cd_fechamento_caixa]),
    CONSTRAINT [FK_Fechamento_Caixa_Composicao_Tipo_Objeto_Caixa] FOREIGN KEY ([cd_tipo_objeto_caixa]) REFERENCES [dbo].[Tipo_Objeto_Caixa] ([cd_tipo_objeto_caixa])
);

