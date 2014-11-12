CREATE TABLE [dbo].[Ordem_Separacao] (
    [cd_ordem_separacao] INT      NOT NULL,
    [dt_ordem_separacao] DATETIME NULL,
    [cd_pedido_venda]    INT      NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    [ic_status_ordem]    CHAR (1) NULL,
    CONSTRAINT [PK_Ordem_Separacao] PRIMARY KEY CLUSTERED ([cd_ordem_separacao] ASC) WITH (FILLFACTOR = 90)
);

