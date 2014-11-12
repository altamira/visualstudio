CREATE TABLE [dbo].[Cliente_Historico_Cobranca] (
    [cd_cliente]               INT           NOT NULL,
    [cd_cliente_hist_cobranca] INT           NOT NULL,
    [dt_cliente_hist_cobranca] DATETIME      NULL,
    [nm_observacao]            VARCHAR (256) NULL,
    [ds_historico_cobranca]    TEXT          NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Cliente_Historico_Cobranca] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_cliente_hist_cobranca] ASC) WITH (FILLFACTOR = 90)
);

