CREATE TABLE [dbo].[Produto_ECF] (
    [cd_produto]              INT          NOT NULL,
    [ic_ecf_produto]          CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_numero_serie_produto] VARCHAR (20) NULL,
    CONSTRAINT [PK_Produto_ECF] PRIMARY KEY CLUSTERED ([cd_produto] ASC),
    CONSTRAINT [FK_Produto_ECF_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

