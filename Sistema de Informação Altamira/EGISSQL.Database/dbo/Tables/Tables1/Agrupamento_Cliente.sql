CREATE TABLE [dbo].[Agrupamento_Cliente] (
    [cd_agrupamento]           INT      NOT NULL,
    [cd_cliente]               INT      NOT NULL,
    [cd_classificacao_cliente] INT      NULL,
    [cd_cliente_grupo]         INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Agrupamento_Cliente] PRIMARY KEY CLUSTERED ([cd_agrupamento] ASC),
    CONSTRAINT [FK_Agrupamento_Cliente_Cliente_Grupo] FOREIGN KEY ([cd_cliente_grupo]) REFERENCES [dbo].[Cliente_Grupo] ([cd_cliente_grupo])
);

