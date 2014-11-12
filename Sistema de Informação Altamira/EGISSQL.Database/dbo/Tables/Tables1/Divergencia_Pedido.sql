CREATE TABLE [dbo].[Divergencia_Pedido] (
    [cd_divergencia_pedido] INT          NOT NULL,
    [nm_divergencia_pedido] VARCHAR (30) NULL,
    [sg_divergencia_pedido] CHAR (10)    NULL,
    [ic_divergencia_pedido] CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Divergencia_Pedido] PRIMARY KEY CLUSTERED ([cd_divergencia_pedido] ASC) WITH (FILLFACTOR = 90)
);

