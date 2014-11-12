CREATE TABLE [dbo].[Fornecedor_Acesso_Intranet] (
    [cd_fornecedor]      CHAR (15) NOT NULL,
    [ic_acesso_intranet] CHAR (1)  NOT NULL,
    [cd_usuario]         INT       NOT NULL,
    [dt_usuario]         DATETIME  NOT NULL
);

