CREATE TABLE [dbo].[Produto_Desenvolvimento] (
    [cd_produto_desenv]      INT           NOT NULL,
    [nm_produto_desenv]      VARCHAR (40)  NULL,
    [nm_fantasia_produto]    VARCHAR (15)  NULL,
    [cd_unidade_medida]      INT           NULL,
    [nm_foto_produto_desenv] VARCHAR (100) NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [nm_obs_produto_desenv]  VARCHAR (40)  NULL,
    [ds_produto_desenv]      TEXT          NULL,
    CONSTRAINT [PK_Produto_Desenvolvimento] PRIMARY KEY CLUSTERED ([cd_produto_desenv] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Desenvolvimento_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

