CREATE TABLE [dbo].[Grupo_Produto_Crescimento] (
    [cd_ano]                    INT          NOT NULL,
    [cd_grupo_produto]          INT          NOT NULL,
    [pc_cresc_ano_grupo_produt] FLOAT (53)   NOT NULL,
    [nm_obs_cresc_ano_grup_pro] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Grupo_Produto_Crescimento] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_grupo_produto] ASC) WITH (FILLFACTOR = 90)
);

