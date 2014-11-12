CREATE TABLE [dbo].[Fase_Pedido] (
    [cd_fase_pedido] INT          NOT NULL,
    [nm_fase_pedido] VARCHAR (50) NULL,
    [sg_fase_pedido] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Fase_Pedido] PRIMARY KEY CLUSTERED ([cd_fase_pedido] ASC) WITH (FILLFACTOR = 90)
);

