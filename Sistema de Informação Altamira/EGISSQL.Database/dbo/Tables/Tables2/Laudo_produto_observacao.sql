CREATE TABLE [dbo].[Laudo_produto_observacao] (
    [cd_produto]       INT      NOT NULL,
    [ds_obs_cabecalho] TEXT     NULL,
    [ds_obs_rodape]    TEXT     NULL,
    [cd_usuario]       INT      NULL,
    [dt_usuario]       DATETIME NULL,
    CONSTRAINT [PK_Laudo_produto_observacao] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90)
);

