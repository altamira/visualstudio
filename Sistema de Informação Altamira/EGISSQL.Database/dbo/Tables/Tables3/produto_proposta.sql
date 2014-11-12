CREATE TABLE [dbo].[produto_proposta] (
    [cd_produto]                INT      NOT NULL,
    [cd_componente_proposta]    INT      NOT NULL,
    [ds_texto_proposta_produto] TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_produto_proposta] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_componente_proposta] ASC) WITH (FILLFACTOR = 90)
);

