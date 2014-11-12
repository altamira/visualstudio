CREATE TABLE [dbo].[Relatorio_Produto_Check_Item] (
    [cd_produto_check]      INT      NOT NULL,
    [cd_produto_check_list] INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [cd_tipo_fornecimento]  INT      NULL,
    [cd_tipo_participacao]  INT      NULL,
    CONSTRAINT [PK_Relatorio_Produto_Check_Item] PRIMARY KEY CLUSTERED ([cd_produto_check] ASC, [cd_produto_check_list] ASC) WITH (FILLFACTOR = 90)
);

