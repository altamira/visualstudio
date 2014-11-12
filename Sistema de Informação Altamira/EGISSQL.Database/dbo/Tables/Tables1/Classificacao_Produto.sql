CREATE TABLE [dbo].[Classificacao_Produto] (
    [cd_classificacao_produto]  INT          NOT NULL,
    [nm_classificacao_produto]  VARCHAR (40) NULL,
    [nm_fantasia_classificacao] VARCHAR (15) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Classificacao_Produto] PRIMARY KEY CLUSTERED ([cd_classificacao_produto] ASC) WITH (FILLFACTOR = 90)
);

