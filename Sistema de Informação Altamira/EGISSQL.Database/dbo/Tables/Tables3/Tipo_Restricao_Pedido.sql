CREATE TABLE [dbo].[Tipo_Restricao_Pedido] (
    [cd_tipo_restricao_pedido] INT          NOT NULL,
    [sg_tipo_restricao]        CHAR (10)    NOT NULL,
    [ic_tipo_restricao_pedido] CHAR (1)     NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [nm_tipo_restricao_pedido] VARCHAR (30) NULL,
    [ic_lib_restricao_pedido]  CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Restricao_Pedido] PRIMARY KEY CLUSTERED ([cd_tipo_restricao_pedido] ASC) WITH (FILLFACTOR = 90)
);

