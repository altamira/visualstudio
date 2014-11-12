CREATE TABLE [dbo].[Divergencia_Pedido_Compra] (
    [cd_divergencia_ped_compra] INT          NOT NULL,
    [nm_divergencia_ped_compra] VARCHAR (30) NULL,
    [sg_divergencia_ped_compra] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Divergencia_Pedido_Compra] PRIMARY KEY CLUSTERED ([cd_divergencia_ped_compra] ASC) WITH (FILLFACTOR = 90)
);

