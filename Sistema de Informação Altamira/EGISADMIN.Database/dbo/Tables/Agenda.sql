CREATE TABLE [dbo].[Agenda] (
    [dt_agenda]           DATETIME NOT NULL,
    [ic_dia_util]         CHAR (1) NOT NULL,
    [ic_fabrica]          CHAR (1) NOT NULL,
    [ic_plantao_vendas]   CHAR (1) NOT NULL,
    [cd_usuario_atualiza] INT      NULL,
    [dt_atualiza]         DATETIME NULL,
    CONSTRAINT [PK__Agenda__276EDEB3] PRIMARY KEY CLUSTERED ([dt_agenda] ASC) WITH (FILLFACTOR = 90)
);

