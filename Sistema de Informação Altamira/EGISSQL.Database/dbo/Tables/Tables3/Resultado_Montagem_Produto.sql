CREATE TABLE [dbo].[Resultado_Montagem_Produto] (
    [cd_resultado_montagem] INT      NOT NULL,
    [cd_montagem_produto]   INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Resultado_Montagem_Produto] PRIMARY KEY CLUSTERED ([cd_resultado_montagem] ASC, [cd_montagem_produto] ASC) WITH (FILLFACTOR = 90)
);

