CREATE TABLE [dbo].[Unidade_Divergente_Entrada] (
    [cd_unidade_medida]         INT        NULL,
    [ic_liquida_pedido]         CHAR (1)   NULL,
    [pc_tolerancia_divergencia] FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [FK_Unidade_Divergente_Entrada_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

