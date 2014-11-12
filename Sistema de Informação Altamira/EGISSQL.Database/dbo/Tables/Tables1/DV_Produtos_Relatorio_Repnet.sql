CREATE TABLE [dbo].[DV_Produtos_Relatorio_Repnet] (
    [cd_diario_venda]       INT      NOT NULL,
    [cd_produtos_relatorio] INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_DV_Produtos_Relatorio_Repnet] PRIMARY KEY CLUSTERED ([cd_diario_venda] ASC, [cd_produtos_relatorio] ASC) WITH (FILLFACTOR = 90)
);

