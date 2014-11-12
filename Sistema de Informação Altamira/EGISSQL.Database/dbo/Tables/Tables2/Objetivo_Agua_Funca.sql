CREATE TABLE [dbo].[Objetivo_Agua_Funca] (
    [cd_objetivo]     INT           NOT NULL,
    [nm_objetivo]     VARCHAR (40)  NULL,
    [cd_departamento] INT           NULL,
    [cd_usuario]      INT           NULL,
    [dt_usuario]      DATETIME      NULL,
    [nm_documento]    VARCHAR (150) NULL,
    CONSTRAINT [PK_Objetivo_Agua_Funca] PRIMARY KEY CLUSTERED ([cd_objetivo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Objetivo_Agua_Funca_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

