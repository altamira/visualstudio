CREATE TABLE [dbo].[Processo_Padrao_Fase] (
    [cd_processo_padrao]      INT          NULL,
    [cd_fase_producao]        INT          NULL,
    [nm_obs_fase_producao]    VARCHAR (50) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_item_processo_padrao] INT          NULL,
    CONSTRAINT [FK_Processo_Padrao_Fase_Fase_Producao] FOREIGN KEY ([cd_fase_producao]) REFERENCES [dbo].[Fase_Producao] ([cd_fase_producao])
);

