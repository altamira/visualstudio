CREATE TABLE [dbo].[Parametro_Entrega] (
    [cd_empresa]                INT        NOT NULL,
    [vl_entrega_pedido]         FLOAT (53) NULL,
    [cd_tipo_local_entrega]     INT        NULL,
    [ic_entrega_regiao_cliente] CHAR (1)   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Parametro_Entrega] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Entrega_Tipo_Local_Entrega] FOREIGN KEY ([cd_tipo_local_entrega]) REFERENCES [dbo].[Tipo_Local_Entrega] ([cd_tipo_local_entrega])
);

