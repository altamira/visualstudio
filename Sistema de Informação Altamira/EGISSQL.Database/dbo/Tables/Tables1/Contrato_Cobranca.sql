CREATE TABLE [dbo].[Contrato_Cobranca] (
    [cd_contrato_cobranca] INT      NOT NULL,
    [dt_contrato_cobranca] DATETIME NULL,
    [cd_cliente]           INT      NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Contrato_Cobranca] PRIMARY KEY CLUSTERED ([cd_contrato_cobranca] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Contrato_Cobranca_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

