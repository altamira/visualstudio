CREATE TABLE [dbo].[Parametro_Qualidade] (
    [cd_empresa]              INT      NOT NULL,
    [ic_analise_proposta]     CHAR (1) NULL,
    [ic_analise_pedido_venda] CHAR (1) NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Parametro_Qualidade] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

