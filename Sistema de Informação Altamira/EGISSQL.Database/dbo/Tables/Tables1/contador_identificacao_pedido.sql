CREATE TABLE [dbo].[contador_identificacao_pedido] (
    [cd_ano_identificacao_ped]       INT      NOT NULL,
    [cd_sequencia_identificacao_ped] INT      NULL,
    [cd_usuario]                     INT      NULL,
    [dt_usuario]                     DATETIME NULL,
    CONSTRAINT [PK_contador_identificacao_pedido] PRIMARY KEY CLUSTERED ([cd_ano_identificacao_ped] ASC) WITH (FILLFACTOR = 90)
);

