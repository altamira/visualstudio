CREATE TABLE [dbo].[Norma_Tecnica_Produto] (
    [cd_norma_tecnica_produto] INT          NOT NULL,
    [cd_produto]               INT          NOT NULL,
    [cd_norma_tecnica]         INT          NOT NULL,
    [ds_norma_tecnica_produto] TEXT         NULL,
    [nm_obs_norma_tecnica]     VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [FK_Norma_Tecnica_Produto_Norma_Tecnica] FOREIGN KEY ([cd_norma_tecnica]) REFERENCES [dbo].[Norma_Tecnica] ([cd_norma_tecnica])
);

