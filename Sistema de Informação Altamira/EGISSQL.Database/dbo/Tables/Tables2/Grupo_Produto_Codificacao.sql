CREATE TABLE [dbo].[Grupo_Produto_Codificacao] (
    [cd_grupo_produto]         INT          NOT NULL,
    [cd_tipo_codificacao]      INT          NOT NULL,
    [cd_item_codificacao]      INT          NOT NULL,
    [qt_digito_codificacao]    INT          NULL,
    [nm_obs_grupo_codificacao] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grupo_Produto_Codificacao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_tipo_codificacao] ASC, [cd_item_codificacao] ASC) WITH (FILLFACTOR = 90)
);

