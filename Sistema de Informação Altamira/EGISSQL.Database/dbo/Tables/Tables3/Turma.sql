CREATE TABLE [dbo].[Turma] (
    [cd_turma]       INT          NOT NULL,
    [nm_turma]       VARCHAR (40) NULL,
    [sg_turma]       INT          NULL,
    [nm_obs_turma]   VARCHAR (40) NULL,
    [ic_ativo_turma] CHAR (1)     NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Turma] PRIMARY KEY CLUSTERED ([cd_turma] ASC) WITH (FILLFACTOR = 90)
);

