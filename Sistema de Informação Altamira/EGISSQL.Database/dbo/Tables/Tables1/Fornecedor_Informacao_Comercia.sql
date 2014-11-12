CREATE TABLE [dbo].[Fornecedor_Informacao_Comercia] (
    [cd_fornecedor]       INT      NOT NULL,
    [cd_usuario]          INT      NOT NULL,
    [dt_usuario]          DATETIME NOT NULL,
    [dt_suspensao_compra] DATETIME NULL
);

