CREATE TABLE [dbo].[Iso_Tarefa] (
    [cd_iso_tarefa] INT          NOT NULL,
    [nm_iso_tarefa] VARCHAR (30) NOT NULL,
    [sg_iso_tarefa] CHAR (10)    NOT NULL,
    [ds_iso_tarefa] TEXT         NOT NULL,
    [cd_usuario]    INT          NOT NULL,
    [dt_usuario]    DATETIME     NOT NULL,
    CONSTRAINT [PK_Iso_Tarefa] PRIMARY KEY CLUSTERED ([cd_iso_tarefa] ASC) WITH (FILLFACTOR = 90)
);

