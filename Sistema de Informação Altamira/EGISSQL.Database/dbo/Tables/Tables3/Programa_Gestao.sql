CREATE TABLE [dbo].[Programa_Gestao] (
    [cd_programa]     INT          NOT NULL,
    [dt_programa]     DATETIME     NULL,
    [nm_programa]     VARCHAR (40) NULL,
    [cd_objetivo]     INT          NULL,
    [cd_meta]         INT          NULL,
    [cd_indicador]    INT          NULL,
    [nm_obs_programa] VARCHAR (40) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Programa_Gestao] PRIMARY KEY CLUSTERED ([cd_programa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programa_Gestao_Indicador] FOREIGN KEY ([cd_indicador]) REFERENCES [dbo].[Indicador] ([cd_indicador])
);

