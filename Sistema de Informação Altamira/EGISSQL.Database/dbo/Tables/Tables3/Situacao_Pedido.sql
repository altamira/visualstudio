CREATE TABLE [dbo].[Situacao_Pedido] (
    [cd_situacao_pedido] INT          NOT NULL,
    [nm_situacao_pedido] VARCHAR (50) NULL,
    [sg_situacao_pedido] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Situacao_Pedido] PRIMARY KEY CLUSTERED ([cd_situacao_pedido] ASC) WITH (FILLFACTOR = 90)
);

