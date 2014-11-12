CREATE TABLE [dbo].[Agente_Produto] (
    [cd_agente]                  INT          NOT NULL,
    [cd_produto]                 INT          NOT NULL,
    [pc_comissao_agente_produto] FLOAT (53)   NULL,
    [nm_obs_agente_produto]      VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Agente_Produto] PRIMARY KEY CLUSTERED ([cd_agente] ASC, [cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agente_Produto_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

