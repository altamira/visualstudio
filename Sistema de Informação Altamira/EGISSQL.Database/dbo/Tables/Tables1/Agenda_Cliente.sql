CREATE TABLE [dbo].[Agenda_Cliente] (
    [cd_agenda]         INT        NOT NULL,
    [cd_cliente]        INT        NULL,
    [dt_agenda_cliente] DATETIME   NULL,
    [qt_hora_cliente]   FLOAT (53) NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    CONSTRAINT [PK_Agenda_Cliente] PRIMARY KEY CLUSTERED ([cd_agenda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agenda_Cliente_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

