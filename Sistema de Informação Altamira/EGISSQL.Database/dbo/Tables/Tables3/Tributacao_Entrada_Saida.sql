CREATE TABLE [dbo].[Tributacao_Entrada_Saida] (
    [cd_tributacao_saida]   INT      NULL,
    [cd_tributacao_entrada] INT      NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [FK_Tributacao_Entrada_Saida_Tributacao] FOREIGN KEY ([cd_tributacao_entrada]) REFERENCES [dbo].[Tributacao] ([cd_tributacao])
);

