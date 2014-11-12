CREATE TABLE [dbo].[Contrato_Compra_Programacao] (
    [cd_contrato_compra]      INT          NOT NULL,
    [cd_item_contrato_compra] INT          NOT NULL,
    [cd_produto]              INT          NULL,
    [qt_programacao_produto]  FLOAT (53)   NULL,
    [cd_servico]              INT          NULL,
    [cd_ano]                  INT          NULL,
    [cd_mes]                  INT          NULL,
    [cd_usuario_liberacao]    INT          NULL,
    [dt_liberacao]            DATETIME     NULL,
    [qt_liberacao]            FLOAT (53)   NULL,
    [nm_item_obs_programacao] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Contrato_Compra_Programacao] PRIMARY KEY CLUSTERED ([cd_contrato_compra] ASC, [cd_item_contrato_compra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Compra_Programacao_Contrato_Compra] FOREIGN KEY ([cd_contrato_compra]) REFERENCES [dbo].[Contrato_Compra] ([cd_contrato_compra])
);

