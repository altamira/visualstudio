CREATE TABLE [dbo].[Area_Acesso_Agenda] (
    [cd_area_acesso]            INT          NOT NULL,
    [cd_semana]                 INT          NOT NULL,
    [ic_area_acesso]            CHAR (1)     NULL,
    [nm_obs_area_acesso_agenda] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Area_Acesso_Agenda] PRIMARY KEY CLUSTERED ([cd_area_acesso] ASC, [cd_semana] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Area_Acesso_Agenda_Semana] FOREIGN KEY ([cd_semana]) REFERENCES [dbo].[Semana] ([cd_semana])
);

