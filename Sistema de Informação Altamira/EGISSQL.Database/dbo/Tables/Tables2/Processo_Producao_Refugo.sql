CREATE TABLE [dbo].[Processo_Producao_Refugo] (
    [cd_processo]        INT          NOT NULL,
    [qt_refugo_processo] FLOAT (53)   NULL,
    [cd_causa_refugo]    INT          NULL,
    [ds_refugo_processo] TEXT         NULL,
    [nm_obs_refugo]      VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Processo_Producao_Refugo] PRIMARY KEY CLUSTERED ([cd_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Refugo_Causa_Refugo] FOREIGN KEY ([cd_causa_refugo]) REFERENCES [dbo].[Causa_Refugo] ([cd_causa_refugo])
);

