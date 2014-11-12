CREATE TABLE [dbo].[Nota_Entrada_Complemento] (
    [cd_nota_entrada]      INT           NOT NULL,
    [cd_fornecedor]        INT           NOT NULL,
    [cd_operacao_fiscal]   INT           NOT NULL,
    [cd_serie_nota_fiscal] INT           NOT NULL,
    [nm_xml_nota_entrada]  VARCHAR (200) NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    CONSTRAINT [PK_Nota_Entrada_Complemento] PRIMARY KEY CLUSTERED ([cd_nota_entrada] ASC, [cd_fornecedor] ASC, [cd_operacao_fiscal] ASC, [cd_serie_nota_fiscal] ASC) WITH (FILLFACTOR = 90)
);

