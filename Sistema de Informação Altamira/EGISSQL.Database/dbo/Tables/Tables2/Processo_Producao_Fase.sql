CREATE TABLE [dbo].[Processo_Producao_Fase] (
    [cd_processo]          INT          NOT NULL,
    [cd_fase_producao]     INT          NOT NULL,
    [nm_obs_fase_producao] VARCHAR (50) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Processo_Producao_Fase] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_fase_producao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Fase_Fase_Producao] FOREIGN KEY ([cd_fase_producao]) REFERENCES [dbo].[Fase_Producao] ([cd_fase_producao])
);

