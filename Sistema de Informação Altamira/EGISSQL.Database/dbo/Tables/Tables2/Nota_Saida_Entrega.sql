CREATE TABLE [dbo].[Nota_Saida_Entrega] (
    [cd_nota_saida]         INT      NOT NULL,
    [ds_entrega_nota_saida] TEXT     NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Nota_Saida_Entrega] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_Saida_Entrega_Nota_Saida] FOREIGN KEY ([cd_nota_saida]) REFERENCES [dbo].[Nota_Saida] ([cd_nota_saida])
);

