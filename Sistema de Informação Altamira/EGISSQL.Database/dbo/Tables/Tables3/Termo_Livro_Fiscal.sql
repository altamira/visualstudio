CREATE TABLE [dbo].[Termo_Livro_Fiscal] (
    [cd_termo_livro_fiscal]     INT      NOT NULL,
    [cd_usuario]                INT      NULL,
    [ds_termo_livro_fiscal]     TEXT     NULL,
    [cd_tipo_termo_livr_fiscal] INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Termo_Livro_Fiscal] PRIMARY KEY CLUSTERED ([cd_termo_livro_fiscal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Termo_Livro_Fiscal_Tipo_Termo_Livro_Fiscal] FOREIGN KEY ([cd_tipo_termo_livr_fiscal]) REFERENCES [dbo].[Tipo_Termo_Livro_Fiscal] ([cd_tipo_termo_livr_fiscal])
);

