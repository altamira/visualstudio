CREATE TABLE [dbo].[Grupo_Estoque] (
    [cd_grupo_estoque]          INT          NOT NULL,
    [nm_grupo_estoque]          VARCHAR (40) NULL,
    [sg_grupo_estoque]          CHAR (10)    NULL,
    [cd_mascara_grupo_estoque]  INT          NULL,
    [cd_lancamento_padrao]      INT          NULL,
    [nm_obs_grupo_estoque]      VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_padrao_grupo_estoque]   CHAR (1)     NULL,
    [ic_lista_preco_fornecedor] CHAR (1)     NULL,
    [cd_sped_fiscal]            VARCHAR (15) NULL,
    CONSTRAINT [PK_Grupo_Estoque] PRIMARY KEY CLUSTERED ([cd_grupo_estoque] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Estoque_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

