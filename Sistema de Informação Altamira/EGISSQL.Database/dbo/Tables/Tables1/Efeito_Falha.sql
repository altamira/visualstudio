CREATE TABLE [dbo].[Efeito_Falha] (
    [cd_efeio_falha]         INT          NOT NULL,
    [nm_efeito_falha]        VARCHAR (50) NULL,
    [ds_efeito_falha]        TEXT         NULL,
    [cd_criterio_severidade] INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Efeito_Falha] PRIMARY KEY CLUSTERED ([cd_efeio_falha] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Efeito_Falha_Criterio_Severidade] FOREIGN KEY ([cd_criterio_severidade]) REFERENCES [dbo].[Criterio_Severidade] ([cd_criterio_severidade])
);

