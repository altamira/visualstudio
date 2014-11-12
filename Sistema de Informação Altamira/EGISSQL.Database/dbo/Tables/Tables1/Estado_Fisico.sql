CREATE TABLE [dbo].[Estado_Fisico] (
    [cd_estado_fisico] INT          NOT NULL,
    [nm_estado_fisico] VARCHAR (40) NULL,
    [sg_estado_fisico] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Estado_Fisico] PRIMARY KEY CLUSTERED ([cd_estado_fisico] ASC) WITH (FILLFACTOR = 90)
);

