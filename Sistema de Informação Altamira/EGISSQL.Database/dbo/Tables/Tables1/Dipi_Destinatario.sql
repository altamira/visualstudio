CREATE TABLE [dbo].[Dipi_Destinatario] (
    [cd_ano]               INT        NOT NULL,
    [cd_cliente]           INT        NOT NULL,
    [vl_nota_saida_dipi]   FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [cd_tipo_destinatario] INT        NOT NULL,
    CONSTRAINT [PK_Dipi_Destinatario] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_cliente] ASC, [cd_tipo_destinatario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Dipi_Destinatario_Tipo_Destinatario] FOREIGN KEY ([cd_tipo_destinatario]) REFERENCES [dbo].[Tipo_Destinatario] ([cd_tipo_destinatario])
);

