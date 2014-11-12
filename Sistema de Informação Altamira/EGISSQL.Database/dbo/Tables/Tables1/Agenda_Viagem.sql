CREATE TABLE [dbo].[Agenda_Viagem] (
    [dt_agenda]             DATETIME NOT NULL,
    [cd_item_agenda_viagem] INT      NOT NULL,
    [cd_projeto_viagem]     INT      NULL,
    [cd_assunto_viagem]     INT      NULL,
    [cd_funcionario]        INT      NULL,
    [ic_agenda_viagem]      CHAR (1) NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Agenda_Viagem] PRIMARY KEY CLUSTERED ([dt_agenda] ASC, [cd_item_agenda_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agenda_Viagem_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

