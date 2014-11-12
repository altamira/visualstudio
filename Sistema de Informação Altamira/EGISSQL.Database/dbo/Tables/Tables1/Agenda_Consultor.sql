CREATE TABLE [dbo].[Agenda_Consultor] (
    [cd_agenda]           INT        NOT NULL,
    [cd_consultor]        INT        NULL,
    [dt_agenda_consultor] DATETIME   NULL,
    [qt_hora_consultor]   FLOAT (53) NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [PK_Agenda_Consultor] PRIMARY KEY CLUSTERED ([cd_agenda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agenda_Consultor_Consultor_Implantacao] FOREIGN KEY ([cd_consultor]) REFERENCES [dbo].[Consultor_Implantacao] ([cd_consultor])
);

