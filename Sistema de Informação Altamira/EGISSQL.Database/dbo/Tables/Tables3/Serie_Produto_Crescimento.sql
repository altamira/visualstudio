CREATE TABLE [dbo].[Serie_Produto_Crescimento] (
    [cd_ano]                    INT          NOT NULL,
    [cd_serie_produto]          INT          NOT NULL,
    [pc_cresc_ano_serie_produt] FLOAT (53)   NULL,
    [nm_obs_cres_ano_serie_pro] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Serie_Produto_Crescimento] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_serie_produto] ASC) WITH (FILLFACTOR = 90)
);

