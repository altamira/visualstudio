CREATE TABLE [dbo].[Agenda_Departamento] (
    [cd_departamento] INT      NOT NULL,
    [dt_agenda]       DATETIME NOT NULL,
    [cd_usuario]      INT      NOT NULL,
    [dt_usuario]      DATETIME NOT NULL,
    CONSTRAINT [PK_Agenda_departamento] PRIMARY KEY CLUSTERED ([cd_departamento] ASC, [dt_agenda] ASC) WITH (FILLFACTOR = 90)
);

