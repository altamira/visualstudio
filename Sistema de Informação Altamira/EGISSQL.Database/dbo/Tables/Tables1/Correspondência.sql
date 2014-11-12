CREATE TABLE [dbo].[Correspondência] (
    [cd_correspondencia]      INT      NOT NULL,
    [cd_contrato_concessao]   INT      NULL,
    [dt_correspodencia]       DATETIME NULL,
    [cd_tipo_correspondencia] INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Correspondência] PRIMARY KEY CLUSTERED ([cd_correspondencia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Correspondência_Tipo_Correspondencia] FOREIGN KEY ([cd_tipo_correspondencia]) REFERENCES [dbo].[Tipo_Correspondencia] ([cd_tipo_correspondencia])
);

