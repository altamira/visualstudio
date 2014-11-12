CREATE TABLE [dbo].[Tipo_Combustivel_Historico] (
    [cd_tipo_combustivel]      INT          NOT NULL,
    [dt_tipo_combustivel]      DATETIME     NOT NULL,
    [vl_tipo_combustivel_hist] FLOAT (53)   NULL,
    [nm_obs_tipo_combustivel]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Combustivel_Historico] PRIMARY KEY CLUSTERED ([cd_tipo_combustivel] ASC, [dt_tipo_combustivel] ASC) WITH (FILLFACTOR = 90)
);

