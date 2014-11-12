CREATE TABLE [dbo].[Fornecedor_Logotipo] (
    [cd_fornecedor]          INT           NOT NULL,
    [nm_fornecedor_logotipo] VARCHAR (100) NOT NULL,
    [cd_usuario]             INT           NOT NULL,
    [dt_usuario]             DATETIME      NOT NULL,
    CONSTRAINT [PK_Fornecedor_Logotipo] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Logotipo_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]) ON DELETE CASCADE
);

