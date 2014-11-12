CREATE TABLE [dbo].[Dipi_Remetente] (
    [cd_ano]               INT        NOT NULL,
    [cd_fornecedor]        INT        NOT NULL,
    [vl_nota_entrada_dipi] FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_tipo_destinatario] INT        NOT NULL,
    CONSTRAINT [PK_Dipi_Remetente] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_fornecedor] ASC, [cd_tipo_destinatario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Dipi_Remetente_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario])
);

