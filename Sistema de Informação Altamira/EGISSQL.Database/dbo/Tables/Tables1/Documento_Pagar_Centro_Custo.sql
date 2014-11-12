CREATE TABLE [dbo].[Documento_Pagar_Centro_Custo] (
    [cd_documento_pagar]   INT        NOT NULL,
    [cd_centro_custo]      INT        NULL,
    [cd_item_centro_custo] INT        NULL,
    [pc_centro_custo]      FLOAT (53) NULL,
    [vl_centro_custo]      FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_item_documento]    INT        NOT NULL,
    [cd_nota_centro_custo] INT        NULL,
    CONSTRAINT [PK_Documento_Pagar_Centro_Custo] PRIMARY KEY CLUSTERED ([cd_documento_pagar] ASC, [cd_item_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Pagar_Centro_Custo_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
);

