CREATE TABLE [dbo].[Departamento] (
    [cd_departamento] INT          NOT NULL,
    [nm_departamento] VARCHAR (40) NOT NULL,
    [sg_departamento] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Departamento] PRIMARY KEY CLUSTERED ([cd_departamento] ASC) WITH (FILLFACTOR = 90)
);

