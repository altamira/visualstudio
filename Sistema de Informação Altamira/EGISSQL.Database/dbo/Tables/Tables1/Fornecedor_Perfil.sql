CREATE TABLE [dbo].[Fornecedor_Perfil] (
    [cd_fornecedor]        INT      NOT NULL,
    [ds_perfil_fornecedor] TEXT     NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Fornecedor_Perfil] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

