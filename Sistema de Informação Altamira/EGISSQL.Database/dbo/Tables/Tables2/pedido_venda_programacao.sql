CREATE TABLE [dbo].[pedido_venda_programacao] (
    [cd_programacao]        INT        NOT NULL,
    [cd_pedido_venda]       INT        NULL,
    [cd_produto]            INT        NULL,
    [qt_programada]         FLOAT (53) NULL,
    [qt_saldo]              FLOAT (53) NULL,
    [dt_programada]         DATETIME   NULL,
    [dt_usuario]            DATETIME   NULL,
    [cd_usuario]            INT        NULL,
    [cd_status_programacao] INT        NULL,
    CONSTRAINT [PK_pedido_venda_programacao] PRIMARY KEY CLUSTERED ([cd_programacao] ASC) WITH (FILLFACTOR = 90)
);

