CREATE TABLE [dbo].[Nota_Entrada_Registro] (
    [cd_sequencial]           INT          NOT NULL,
    [cd_fornecedor]           INT          NULL,
    [cd_nota_entrada]         INT          NULL,
    [cd_serie_nota_fiscal]    INT          NULL,
    [cd_operacao_fiscal]      INT          NULL,
    [cd_rem]                  INT          NULL,
    [dt_rem]                  DATETIME     NULL,
    [nm_fornec_nota_registro] VARCHAR (45) NULL,
    [vl_total_rem]            FLOAT (53)   NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tributacao]           INT          NULL,
    [cd_destinacao_producao]  INT          NULL,
    [cd_nota_saida]           INT          NULL,
    [cd_livro_entrada]        INT          NULL,
    [qt_folha_livro_entrada]  INT          NULL,
    CONSTRAINT [PK_Nota_Entrada_Registro] PRIMARY KEY CLUSTERED ([cd_sequencial] ASC) WITH (FILLFACTOR = 90)
);

