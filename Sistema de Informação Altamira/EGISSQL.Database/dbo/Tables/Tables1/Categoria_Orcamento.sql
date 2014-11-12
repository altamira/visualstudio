CREATE TABLE [dbo].[Categoria_Orcamento] (
    [cd_categoria_orcamento]       INT          NOT NULL,
    [nm_categoria_orcamento]       VARCHAR (40) NULL,
    [sg_categoria_orcamento]       CHAR (15)    NULL,
    [cd_mascara_cat_orcamento]     VARCHAR (20) NULL,
    [cd_grupo_orcamento]           INT          NULL,
    [cd_operacao]                  INT          NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [cd_cat_orcamento_pai]         INT          NULL,
    [cd_formula_orcamento]         INT          NULL,
    [cd_mao_obra]                  INT          NULL,
    [ic_ativo_categoria_orcamento] CHAR (1)     NULL,
    CONSTRAINT [PK_Categoria_Orcamento] PRIMARY KEY CLUSTERED ([cd_categoria_orcamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Orcamento_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

