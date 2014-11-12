CREATE TABLE [dbo].[Resultado_Montagem] (
    [cd_resultado_montagem]   INT          NOT NULL,
    [dt_resultado_montagem]   DATETIME     NULL,
    [cd_usuario_montagem]     INT          NULL,
    [nm_obs_montagem_produto] VARCHAR (40) NULL,
    [cd_consulta]             INT          NULL,
    [cd_item_consulta]        INT          NULL,
    [cd_grupo_modelo_produto] INT          NULL,
    [cd_item_composicao]      INT          NULL,
    [cd_modelo_produto]       INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Resultado_Montagem] PRIMARY KEY CLUSTERED ([cd_resultado_montagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Resultado_Montagem_Grupo_Modelo_Produto] FOREIGN KEY ([cd_grupo_modelo_produto]) REFERENCES [dbo].[Grupo_Modelo_Produto] ([cd_grupo_modelo_produto])
);

