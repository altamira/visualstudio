CREATE TABLE [dbo].[Candidato_Departamento] (
    [cd_candidato]    INT      NOT NULL,
    [cd_departamento] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Candidato_Departamento] PRIMARY KEY CLUSTERED ([cd_candidato] ASC, [cd_departamento] ASC) WITH (FILLFACTOR = 90)
);

