CREATE TABLE [dbo].[Status_Tarefa] (
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL,
    [cd_status_tarefa] INT          NOT NULL,
    [nm_status_tarefa] VARCHAR (30) NOT NULL,
    [sg_status_tarefa] CHAR (10)    NOT NULL,
    CONSTRAINT [PK_Status_Tarefa] PRIMARY KEY CLUSTERED ([cd_status_tarefa] ASC) WITH (FILLFACTOR = 90)
);

