CREATE TABLE [dbo].[Fornecedor_Servico_Preco] (
    [cd_fornecedor]         INT          NOT NULL,
    [cd_servico]            INT          NOT NULL,
    [cd_moeda]              INT          NOT NULL,
    [cd_item_servico_moeda] INT          NOT NULL,
    [vl_servico_moeda]      FLOAT (53)   NULL,
    [dt_servico_moeda]      DATETIME     NULL,
    [nm_obs_servico_moeda]  VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Servico_Preco] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_servico] ASC, [cd_moeda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Servico_Preco_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

