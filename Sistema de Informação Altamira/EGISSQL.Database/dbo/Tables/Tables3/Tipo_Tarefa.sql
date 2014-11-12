CREATE TABLE [dbo].[Tipo_Tarefa] (
    [cd_tipo_tarefa] INT          NOT NULL,
    [nm_tipo_tarefa] VARCHAR (30) NOT NULL,
    [sg_tipo_tarefa] CHAR (10)    NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Tarefa] PRIMARY KEY CLUSTERED ([cd_tipo_tarefa] ASC) WITH (FILLFACTOR = 90)
);

