CREATE TABLE [dbo].[Agenda_Operador] (
    [dt_agenda]                     DATETIME     NOT NULL,
    [cd_operador]                   INT          NOT NULL,
    [cd_usuario]                    INT          NOT NULL,
    [dt_usuario]                    DATETIME     NOT NULL,
    [nm_observacao_agenda_oper]     VARCHAR (40) NULL,
    [qt_hora_agenda_operador]       FLOAT (53)   NULL,
    [nm_observacao_agenda_operador] VARCHAR (40) NULL,
    CONSTRAINT [PK_Agenda_operador] PRIMARY KEY CLUSTERED ([dt_agenda] ASC, [cd_operador] ASC) WITH (FILLFACTOR = 90)
);

