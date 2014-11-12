CREATE TABLE [dbo].[Agenda_Feriado] (
    [dt_agenda]             DATETIME     NOT NULL,
    [cd_feriado]            INT          NOT NULL,
    [nm_observacao_feriado] VARCHAR (30) NULL,
    [cd_usuario_atualiza]   INT          NULL,
    [dt_atualiza]           DATETIME     NULL
);

