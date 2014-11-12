CREATE TABLE [dbo].[Missao_Historico] (
    [cd_missao_historico]         INT          NOT NULL,
    [dt_missao_historico]         DATETIME     NULL,
    [cd_missao]                   INT          NULL,
    [cd_igreja]                   INT          NULL,
    [cd_obreiro]                  INT          NULL,
    [cd_pastor]                   INT          NULL,
    [dt_retorno_missao_historico] DATETIME     NULL,
    [ds_missao_historico]         TEXT         NULL,
    [nm_obs_missao_historico]     VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_tipo_historico_missao]    INT          NULL,
    CONSTRAINT [PK_Missao_Historico] PRIMARY KEY CLUSTERED ([cd_missao_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Missao_Historico_Tipo_Historico_Missao] FOREIGN KEY ([cd_tipo_historico_missao]) REFERENCES [dbo].[Tipo_Historico_Missao] ([cd_tipo_historico_missao])
);

