CREATE TABLE [dbo].[Produto_Agrupamento] (
    [cd_agrupamento_produto] INT          NOT NULL,
    [nm_agrupamento_produto] VARCHAR (30) NULL,
    [sg_agrupamento_produto] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Produto_Agrupamento] PRIMARY KEY CLUSTERED ([cd_agrupamento_produto] ASC) WITH (FILLFACTOR = 90)
);

