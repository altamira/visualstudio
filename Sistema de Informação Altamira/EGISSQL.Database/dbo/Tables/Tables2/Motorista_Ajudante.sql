CREATE TABLE [dbo].[Motorista_Ajudante] (
    [cd_motorista_ajudante] INT      NOT NULL,
    [cd_motorista]          INT      NOT NULL,
    [cd_ajudante]           INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Motorista_Ajudante] PRIMARY KEY CLUSTERED ([cd_motorista_ajudante] ASC) WITH (FILLFACTOR = 90)
);

