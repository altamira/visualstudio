CREATE TABLE [dbo].[Boletim_Analise_Nota_Saida] (
    [cd_boletim_analise] INT      NOT NULL,
    [cd_nota_saida]      INT      NOT NULL,
    [cd_item_nota_saida] INT      NOT NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Boletim_Analise_Nota_Saida] PRIMARY KEY CLUSTERED ([cd_boletim_analise] ASC, [cd_nota_saida] ASC, [cd_item_nota_saida] ASC) WITH (FILLFACTOR = 90)
);

