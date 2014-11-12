CREATE TABLE [dbo].[Tipo_Alteracao_Pedido] (
    [cd_tipo_alteracao_pedido] INT          NOT NULL,
    [nm_tipo_alteracao_pedido] VARCHAR (30) NOT NULL,
    [sg_tipo_alteracao_pedido] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [ic_tipo_alteracao_pedido] CHAR (1)     COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [ic_departamento_aviso]    CHAR (1)     NULL
);

