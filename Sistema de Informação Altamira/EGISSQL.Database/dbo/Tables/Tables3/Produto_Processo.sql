CREATE TABLE [dbo].[Produto_Processo] (
    [cd_produto]              INT      NOT NULL,
    [cd_processo_produto]     INT      NOT NULL,
    [cd_fase_produto]         INT      NULL,
    [nm_obs_processo_produto] TEXT     NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [ic_pcp_produto]          CHAR (1) NULL,
    [ic_processo_padrao]      CHAR (1) NULL,
    [cd_tipo_produto_projeto] INT      NULL,
    CONSTRAINT [PK_Produto_Processo] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_processo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Processo_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto]),
    CONSTRAINT [FK_Produto_Processo_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Produto_Processo_Tipo_Produto_Projeto] FOREIGN KEY ([cd_tipo_produto_projeto]) REFERENCES [dbo].[Tipo_Produto_Projeto] ([cd_tipo_produto_projeto])
);

