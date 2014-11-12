CREATE TABLE [dbo].[Oficina] (
    [cd_oficina]          INT          NOT NULL,
    [nm_oficina]          VARCHAR (40) NULL,
    [nm_fantasia_oficina] VARCHAR (15) NULL,
    [dt_cadastro_oficina] DATETIME     NULL,
    [cd_ddd_oficina]      CHAR (4)     NULL,
    [cd_fone_oficina]     VARCHAR (15) NULL,
    [cd_fornecedor]       INT          NULL,
    [ds_oficina]          TEXT         NULL,
    [nm_obs_oficina]      VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Oficina] PRIMARY KEY CLUSTERED ([cd_oficina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Oficina_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

