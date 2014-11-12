CREATE TABLE [dbo].[Roteiro_Indicador] (
    [cd_roteiro]              INT      NOT NULL,
    [cd_roteiro_apresentacao] INT      NULL,
    [cd_indicador]            INT      NULL,
    [cd_ordem_apresentacao]   INT      NOT NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    CONSTRAINT [PK_Roteiro_Indicador] PRIMARY KEY CLUSTERED ([cd_roteiro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Roteiro_Indicador_Indicador] FOREIGN KEY ([cd_indicador]) REFERENCES [dbo].[Indicador] ([cd_indicador])
);

