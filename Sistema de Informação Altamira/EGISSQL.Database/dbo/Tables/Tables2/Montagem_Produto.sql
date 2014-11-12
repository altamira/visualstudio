CREATE TABLE [dbo].[Montagem_Produto] (
    [cd_montagem_produto]       INT          NOT NULL,
    [nm_montagem_produto]       VARCHAR (40) NULL,
    [ic_ativo_montagem_produto] CHAR (1)     NULL,
    [cd_ordem_montagem_produto] INT          NULL,
    [nm_obs_montagem_produto]   VARCHAR (40) NULL,
    [ds_montagem_produto]       TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_mascara_montagem]       VARCHAR (30) NULL,
    [cd_modelo_produto]         INT          NULL,
    [cd_grupo_modelo_produto]   INT          NULL,
    [ic_texto_padrao]           CHAR (1)     NULL,
    CONSTRAINT [PK_Montagem_Produto] PRIMARY KEY CLUSTERED ([cd_montagem_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Montagem_Produto_Grupo_Modelo_Produto] FOREIGN KEY ([cd_grupo_modelo_produto]) REFERENCES [dbo].[Grupo_Modelo_Produto] ([cd_grupo_modelo_produto]),
    CONSTRAINT [FK_Montagem_Produto_Modelo_Produto] FOREIGN KEY ([cd_modelo_produto]) REFERENCES [dbo].[Modelo_Produto] ([cd_modelo_produto])
);

