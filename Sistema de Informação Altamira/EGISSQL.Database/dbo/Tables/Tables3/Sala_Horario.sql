CREATE TABLE [dbo].[Sala_Horario] (
    [cd_controle]         INT          NOT NULL,
    [cd_tipo_sala]        INT          NOT NULL,
    [cd_tipo_horario]     INT          NOT NULL,
    [cd_semana]           INT          NOT NULL,
    [cd_modalidade]       INT          NOT NULL,
    [cd_professor]        INT          NOT NULL,
    [nm_obs_sala_horario] VARCHAR (15) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Sala_Horario] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_tipo_sala] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sala_Horario_Professor] FOREIGN KEY ([cd_professor]) REFERENCES [dbo].[Professor] ([cd_professor])
);

