CREATE TABLE [dbo].[Abertura_Caixa_Composicao] (
    [cd_abertura_caixa]      INT        NOT NULL,
    [cd_item_abertura_caixa] INT        NOT NULL,
    [qt_item_abertura_caixa] FLOAT (53) NULL,
    [vl_item_abertura_caixa] MONEY      NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [cd_tipo_objeto_caixa]   INT        NULL,
    CONSTRAINT [PK_Abertura_Caixa_Composicao] PRIMARY KEY CLUSTERED ([cd_abertura_caixa] ASC, [cd_item_abertura_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Abertura_Caixa_Composicao_Abertura_Caixa] FOREIGN KEY ([cd_abertura_caixa]) REFERENCES [dbo].[Abertura_Caixa] ([cd_abertura_caixa]),
    CONSTRAINT [FK_Abertura_Caixa_Composicao_Tipo_Objeto_Caixa] FOREIGN KEY ([cd_tipo_objeto_caixa]) REFERENCES [dbo].[Tipo_Objeto_Caixa] ([cd_tipo_objeto_caixa])
);

