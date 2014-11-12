CREATE TABLE [dbo].[Grupo_Produto_Observacao] (
    [cd_grupo_produto]       INT          NOT NULL,
    [cd_item_obs_grupo_prod] INT          NOT NULL,
    [cd_obs_padrao_nf]       INT          NULL,
    [nm_compl_obs_padrao_nf] VARCHAR (60) NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Produto_Observacao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_item_obs_grupo_prod] ASC) WITH (FILLFACTOR = 90)
);

