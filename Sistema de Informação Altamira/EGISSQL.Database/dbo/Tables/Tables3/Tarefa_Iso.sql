CREATE TABLE [dbo].[Tarefa_Iso] (
    [cd_tarefa_iso] INT          NOT NULL,
    [nm_tarefa_iso] VARCHAR (30) NOT NULL,
    [sg_tarefa_iso] CHAR (10)    NOT NULL,
    [cd_usuario]    INT          NOT NULL,
    [dt_usuario]    DATETIME     NOT NULL,
    CONSTRAINT [PK_Tarefa_Iso] PRIMARY KEY CLUSTERED ([cd_tarefa_iso] ASC) WITH (FILLFACTOR = 90)
);

