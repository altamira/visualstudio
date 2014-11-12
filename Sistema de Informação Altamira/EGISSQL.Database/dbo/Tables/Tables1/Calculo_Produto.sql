CREATE TABLE [dbo].[Calculo_Produto] (
    [cd_produto]         INT        NOT NULL,
    [vl_calculo_produto] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Calculo_Produto] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Calculo_Produto_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

