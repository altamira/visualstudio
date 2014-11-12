CREATE TABLE [dbo].[Movimento_Producao] (
    [dt_movimento_producao] DATETIME     NULL,
    [cd_operador]           INT          NULL,
    [cd_turno]              INT          NULL,
    [cd_corredor]           INT          NULL,
    [cd_produto]            INT          NULL,
    [qt_movimento_produto]  FLOAT (53)   NULL,
    [cd_fase_producao]      INT          NULL,
    [nm_obs_movimento]      VARCHAR (60) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_maquina]            INT          NULL,
    [cd_tipo_producao]      INT          NULL,
    CONSTRAINT [FK_Movimento_Producao_Tipo_Producao] FOREIGN KEY ([cd_tipo_producao]) REFERENCES [dbo].[Tipo_Producao] ([cd_tipo_producao])
);

