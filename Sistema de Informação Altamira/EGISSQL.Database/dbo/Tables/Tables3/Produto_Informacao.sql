CREATE TABLE [dbo].[Produto_Informacao] (
    [cd_produto]                INT          NOT NULL,
    [cd_produto_informacao]     INT          NOT NULL,
    [cd_tp_informacao_produto]  INT          NULL,
    [ds_produto_informacao]     TEXT         NULL,
    [nm_obs_produto_informacao] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Produto_Informacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_produto_informacao] ASC) WITH (FILLFACTOR = 90)
);

