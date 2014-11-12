CREATE TABLE [dbo].[Academia_Horario] (
    [cd_controle]             INT          NOT NULL,
    [cd_tipo_horario]         INT          NOT NULL,
    [cd_dia_semana]           INT          NOT NULL,
    [cd_modalidade]           INT          NOT NULL,
    [nm_obs_academia_horario] VARCHAR (15) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Academia_Horario] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Academia_Horario_Modalidade] FOREIGN KEY ([cd_modalidade]) REFERENCES [dbo].[Modalidade] ([cd_modalidade])
);

