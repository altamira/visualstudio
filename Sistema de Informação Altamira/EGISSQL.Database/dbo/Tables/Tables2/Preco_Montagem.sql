CREATE TABLE [dbo].[Preco_Montagem] (
    [cd_preco_montagem_produto] INT          NOT NULL,
    [nm_preco_montagem_produto] VARCHAR (40) NOT NULL,
    [sg_preco_montagem_produto] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [vl_preco_montagem_produto] FLOAT (53)   NULL,
    [pc_preco_montagem_produto] FLOAT (53)   NULL,
    CONSTRAINT [PK_Preco_Montagem] PRIMARY KEY CLUSTERED ([cd_preco_montagem_produto] ASC) WITH (FILLFACTOR = 90)
);

