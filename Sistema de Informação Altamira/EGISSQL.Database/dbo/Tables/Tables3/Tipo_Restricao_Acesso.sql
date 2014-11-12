CREATE TABLE [dbo].[Tipo_Restricao_Acesso] (
    [cd_tipo_restricao] INT          NOT NULL,
    [nm_restricao]      VARCHAR (40) NULL,
    [hr_inicio_acesso]  VARCHAR (8)  NULL,
    [hr_fim_acesso]     VARCHAR (8)  NULL,
    [qt_hora_acesso]    FLOAT (53)   NULL,
    [qt_minuto_acesso]  FLOAT (53)   NULL,
    [nm_obs_acesso]     VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Restricao_Acesso] PRIMARY KEY CLUSTERED ([cd_tipo_restricao] ASC)
);

