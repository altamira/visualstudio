CREATE TABLE [dbo].[Tipo_Status_Pedido] (
    [cd_tipo_status_pedido] INT          NOT NULL,
    [nm_tipo_status_pedido] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_status_pedido] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [ic_tipo_status_pedido] CHAR (1)     COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [pk_cd_tipo_status_pedido] PRIMARY KEY CLUSTERED ([cd_tipo_status_pedido] ASC) WITH (FILLFACTOR = 90)
);

