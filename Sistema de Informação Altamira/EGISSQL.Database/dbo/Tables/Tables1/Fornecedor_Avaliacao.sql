CREATE TABLE [dbo].[Fornecedor_Avaliacao] (
    [cd_fornecedor]               INT          NOT NULL,
    [cd_fornecedor_avaliacao]     INT          NOT NULL,
    [dt_avaliacao_fornecedor]     DATETIME     NULL,
    [nm_obs_fornecedor_avaliacao] VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Avaliacao] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_fornecedor_avaliacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Avaliacao_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

