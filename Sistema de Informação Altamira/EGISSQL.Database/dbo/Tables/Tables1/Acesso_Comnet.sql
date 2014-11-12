CREATE TABLE [dbo].[Acesso_Comnet] (
    [cd_fornecedor]         INT      NOT NULL,
    [cd_acesso_comnet]      INT      NOT NULL,
    [cd_contato_fornecedor] INT      NULL,
    [dt_acesso_comnet]      DATETIME NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Acesso_Comnet] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_acesso_comnet] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Acesso_Comnet_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

