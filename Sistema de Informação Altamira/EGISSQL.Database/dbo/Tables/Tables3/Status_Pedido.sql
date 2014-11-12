CREATE TABLE [dbo].[Status_Pedido] (
    [cd_status_pedido]        INT          NOT NULL,
    [nm_status_pedido]        VARCHAR (30) NULL,
    [sg_status_pedido]        CHAR (15)    NULL,
    [ic_status_pedido]        CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_atraso_status_pedido] CHAR (1)     NULL,
    CONSTRAINT [PK_Status_Pedido] PRIMARY KEY CLUSTERED ([cd_status_pedido] ASC) WITH (FILLFACTOR = 90)
);

