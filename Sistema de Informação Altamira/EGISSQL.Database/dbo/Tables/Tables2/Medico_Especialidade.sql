CREATE TABLE [dbo].[Medico_Especialidade] (
    [cd_medico]               INT          NOT NULL,
    [cd_especialidade_medica] INT          NOT NULL,
    [nm_obs_especialidade]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Medico_Especialidade] PRIMARY KEY CLUSTERED ([cd_medico] ASC, [cd_especialidade_medica] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Medico_Especialidade_Especialidade_Medica] FOREIGN KEY ([cd_especialidade_medica]) REFERENCES [dbo].[Especialidade_Medica] ([cd_especialidade_medica])
);

