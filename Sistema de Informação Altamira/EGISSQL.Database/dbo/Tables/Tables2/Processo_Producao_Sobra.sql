CREATE TABLE [dbo].[Processo_Producao_Sobra] (
    [cd_processo]        INT          NOT NULL,
    [qt_sobra_processo]  FLOAT (53)   NULL,
    [cd_causa_sobra]     INT          NULL,
    [ds_refugo_processo] TEXT         NULL,
    [nm_obs_sobra]       VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Processo_Producao_Sobra] PRIMARY KEY CLUSTERED ([cd_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Sobra_Causa_Refugo] FOREIGN KEY ([cd_causa_sobra]) REFERENCES [dbo].[Causa_Refugo] ([cd_causa_refugo])
);

