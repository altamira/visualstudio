CREATE TABLE [dbo].[Despesa_Padrao_comex_idioma] (
    [cd_despesa_padrao_comex]        INT      NOT NULL,
    [cd_despesa_padrao_comex_idioma] INT      NOT NULL,
    [ds_despesa_padrao_comex]        TEXT     NULL,
    [cd_usuario]                     INT      NULL,
    [dt_usuario]                     DATETIME NULL,
    CONSTRAINT [PK_Despesa_Padrao_comex_idioma] PRIMARY KEY CLUSTERED ([cd_despesa_padrao_comex] ASC, [cd_despesa_padrao_comex_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Despesa_Padrao_comex_idioma_Idioma] FOREIGN KEY ([cd_despesa_padrao_comex_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

