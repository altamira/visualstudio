CREATE TABLE [dbo].[Loja_Vendedor] (
    [cd_loja]                INT      NOT NULL,
    [cd_vendedor]            INT      NOT NULL,
    [ic_ativo_loja_vendedor] CHAR (1) NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Loja_Vendedor] PRIMARY KEY CLUSTERED ([cd_loja] ASC, [cd_vendedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Loja_Vendedor_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

