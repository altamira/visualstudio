CREATE TABLE [dbo].[Tipo_Curso_Extracao] (
    [cd_tipo_curso_extracao] INT          NOT NULL,
    [nm_tipo_curso_extracao] VARCHAR (30) NOT NULL,
    [sg_tipo_curso_extracao] CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Curso_Extracao] PRIMARY KEY CLUSTERED ([cd_tipo_curso_extracao] ASC) WITH (FILLFACTOR = 90)
);

