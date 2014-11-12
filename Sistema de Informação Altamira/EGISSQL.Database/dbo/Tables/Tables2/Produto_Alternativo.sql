CREATE TABLE [dbo].[Produto_Alternativo] (
    [cd_produto]               INT          NOT NULL,
    [cd_item_alternativo_prod] INT          NOT NULL,
    [cd_produto_alternativo]   INT          NULL,
    [nm_obs_alternativo_prod]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Produto_Alternativo] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_item_alternativo_prod] ASC) WITH (FILLFACTOR = 90)
);

