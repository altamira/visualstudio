CREATE TABLE [dbo].[Contrato_Concessao_Cancelado] (
    [cd_contrato]              INT          NOT NULL,
    [dt_cancelamento_contrato] DATETIME     NULL,
    [nm_motivo_cancelamento]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Contrato_Concessao_Cancelado] PRIMARY KEY CLUSTERED ([cd_contrato] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Concessao_Cancelado_Contrato_Concessao] FOREIGN KEY ([cd_contrato]) REFERENCES [dbo].[Contrato_Concessao] ([cd_contrato])
);

