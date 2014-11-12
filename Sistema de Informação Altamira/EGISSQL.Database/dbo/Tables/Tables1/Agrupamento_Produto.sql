CREATE TABLE [dbo].[Agrupamento_Produto] (
    [cd_agrupamento_produto]  INT          NOT NULL,
    [nm_agrupamento_produto]  VARCHAR (30) NULL,
    [sg_agrupamento_produto]  CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_agrupamento_prod_pai] INT          NULL,
    CONSTRAINT [PK_Agrupamento_Produto] PRIMARY KEY CLUSTERED ([cd_agrupamento_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agrupamento_Produto_Agrupamento_Produto] FOREIGN KEY ([cd_agrupamento_prod_pai]) REFERENCES [dbo].[Agrupamento_Produto] ([cd_agrupamento_produto])
);

