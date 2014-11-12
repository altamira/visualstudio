CREATE TABLE [dbo].[Aviso_Pedido] (
    [cd_aviso_pedido] INT          NOT NULL,
    [nm_aviso_pedido] VARCHAR (50) NULL,
    [sg_aviso_pedido] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Aviso_Pedido] PRIMARY KEY CLUSTERED ([cd_aviso_pedido] ASC) WITH (FILLFACTOR = 90)
);

