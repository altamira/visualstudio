CREATE TABLE [dbo].[Grupo_Produto_Proposta] (
    [cd_grupo_produto]        INT      NOT NULL,
    [cd_componente_proposta]  INT      NOT NULL,
    [ds_texto_proposta_grupo] TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Grupo_Produto_Proposta] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_componente_proposta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Proposta_Componente_Proposta] FOREIGN KEY ([cd_componente_proposta]) REFERENCES [dbo].[Componente_Proposta] ([cd_componente_proposta])
);

