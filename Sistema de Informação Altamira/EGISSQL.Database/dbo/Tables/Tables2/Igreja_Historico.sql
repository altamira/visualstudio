CREATE TABLE [dbo].[Igreja_Historico] (
    [cd_igreja_historico]     INT          NOT NULL,
    [cd_igreja]               INT          NOT NULL,
    [dt_igreja_historico]     DATETIME     NULL,
    [cd_pastor]               INT          NULL,
    [dt_inicio_igreja]        DATETIME     NULL,
    [dt_fim_igreja]           DATETIME     NULL,
    [cd_obreiro]              INT          NULL,
    [ds_igreja_historico]     TEXT         NULL,
    [nm_obs_igreja_historico] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Igreja_Historico] PRIMARY KEY CLUSTERED ([cd_igreja_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Igreja_Historico_Igreja] FOREIGN KEY ([cd_igreja]) REFERENCES [dbo].[Igreja] ([cd_igreja])
);

