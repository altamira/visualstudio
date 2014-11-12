CREATE TABLE [dbo].[Status_Pedido_Nextel] (
    [cd_status_pedido_nextel] INT          NOT NULL,
    [nm_status_pedido_nextel] VARCHAR (40) NULL,
    [sg_status_pedido_nextel] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_gera_pedido]          CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Pedido_Nextel] PRIMARY KEY CLUSTERED ([cd_status_pedido_nextel] ASC) WITH (FILLFACTOR = 90)
);

