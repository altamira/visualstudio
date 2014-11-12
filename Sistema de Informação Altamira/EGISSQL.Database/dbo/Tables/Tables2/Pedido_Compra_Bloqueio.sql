CREATE TABLE [dbo].[Pedido_Compra_Bloqueio] (
    [cd_pedido_compra]          INT          NULL,
    [ic_bloqueio_pedido]        CHAR (1)     NULL,
    [dt_bloqueio_pedido]        DATETIME     NULL,
    [cd_usuario_liberacao]      INT          NULL,
    [dt_liberacao_bloqueio]     DATETIME     NULL,
    [nm_obs_liberacao_bloqueio] VARCHAR (60) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL
);

