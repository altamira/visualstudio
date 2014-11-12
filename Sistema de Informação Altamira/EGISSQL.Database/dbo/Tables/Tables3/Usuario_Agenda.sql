CREATE TABLE [dbo].[Usuario_Agenda] (
    [cd_usuario]                INT          NOT NULL,
    [dt_agenda_usuario]         DATETIME     NOT NULL,
    [nm_assunto_agenda_usuario] VARCHAR (40) NULL,
    [ds_agenda_usuario]         TEXT         NULL,
    [dt_inicio_agenda_usuario]  DATETIME     NULL,
    [dt_final_agenda_usuario]   DATETIME     NULL,
    [ic_total_agenda_usuario]   CHAR (1)     NULL,
    [ic_ocorrencia_usuario]     CHAR (1)     NULL,
    [cd_ocorrencia]             INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [dt_aviso_agenda_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Usuario_Agenda] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [dt_agenda_usuario] ASC) WITH (FILLFACTOR = 90)
);

