CREATE TABLE [dbo].[Tipo_Cancelamento_Pedido] (
    [cd_tipo_cancelament_pedid] INT          NOT NULL,
    [nm_tipo_cancelament_pedid] VARCHAR (40) NULL,
    [sg_tipo_cancelament_pedid] CHAR (10)    NULL,
    [ic_tipo_cancelament_pedid] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Cancelamento_Pedido] PRIMARY KEY CLUSTERED ([cd_tipo_cancelament_pedid] ASC) WITH (FILLFACTOR = 90)
);

