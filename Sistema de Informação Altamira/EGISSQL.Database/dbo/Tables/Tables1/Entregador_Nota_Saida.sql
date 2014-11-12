CREATE TABLE [dbo].[Entregador_Nota_Saida] (
    [cd_entregador]            INT      NOT NULL,
    [dt_saida_nota]            DATETIME NOT NULL,
    [qt_ordem_entregador_nota] INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Entregador_Nota_Saida] PRIMARY KEY CLUSTERED ([cd_entregador] ASC, [dt_saida_nota] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Entregador_Nota_Saida_Entregador] FOREIGN KEY ([cd_entregador]) REFERENCES [dbo].[Entregador] ([cd_entregador])
);

