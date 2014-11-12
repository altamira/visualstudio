CREATE TABLE [dbo].[Local_Tarefa] (
    [cd_local_tarefa] INT          NOT NULL,
    [nm_local_tarefa] VARCHAR (40) NULL,
    [sg_local_tarefa] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Local_Tarefa] PRIMARY KEY CLUSTERED ([cd_local_tarefa] ASC) WITH (FILLFACTOR = 90)
);

