CREATE TABLE [dbo].[Motivo_Cancelamento_Pedido] (
    [cd_motivo_cancel_pedido] INT          NOT NULL,
    [nm_motivo_cancel_pedido] VARCHAR (40) NOT NULL,
    [sg_motivo_cancel_pedido] CHAR (10)    NOT NULL,
    [ic_motivo_cancel_pedido] CHAR (1)     NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Motivo_Cancelamento_Pedido] PRIMARY KEY CLUSTERED ([cd_motivo_cancel_pedido] ASC) WITH (FILLFACTOR = 90)
);

