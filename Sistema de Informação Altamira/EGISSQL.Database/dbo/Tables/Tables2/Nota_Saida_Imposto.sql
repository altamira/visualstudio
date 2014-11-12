CREATE TABLE [dbo].[Nota_Saida_Imposto] (
    [cd_nota_saida]        INT      NOT NULL,
    [cd_nota_saida_gerada] INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Nota_Saida_Imposto] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC, [cd_nota_saida_gerada] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_Saida_Imposto_Nota_Saida] FOREIGN KEY ([cd_nota_saida]) REFERENCES [dbo].[Nota_Saida] ([cd_nota_saida])
);

