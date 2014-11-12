CREATE TABLE [dbo].[Cobranca_Historico_Cliente] (
    [cd_cobranca_historico]     INT          NOT NULL,
    [cd_cliente]                INT          NULL,
    [dt_cobranca_historico]     DATETIME     NULL,
    [ds_cobranca_historico]     TEXT         NULL,
    [nm_obs_cobranca_historico] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cobranca_Historico_Cliente] PRIMARY KEY CLUSTERED ([cd_cobranca_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cobranca_Historico_Cliente_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

