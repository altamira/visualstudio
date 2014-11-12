CREATE TABLE [dbo].[Cargo_Curso] (
    [cd_cargo_funcionario]      INT          NOT NULL,
    [cd_curso]                  INT          NOT NULL,
    [qt_prioridade_cargo_curso] INT          NULL,
    [nm_obs_cargo_curso]        VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Curso] PRIMARY KEY CLUSTERED ([cd_cargo_funcionario] ASC, [cd_curso] ASC) WITH (FILLFACTOR = 90)
);

