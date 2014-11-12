CREATE TABLE [dbo].[DIRF_Evento_Folha] (
    [cd_evento_dirf]  INT      NOT NULL,
    [cd_evento_folha] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_DIRF_Evento_Folha] PRIMARY KEY CLUSTERED ([cd_evento_dirf] ASC, [cd_evento_folha] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DIRF_Evento_Folha_Evento_Folha] FOREIGN KEY ([cd_evento_folha]) REFERENCES [dbo].[Evento_Folha] ([cd_evento])
);

