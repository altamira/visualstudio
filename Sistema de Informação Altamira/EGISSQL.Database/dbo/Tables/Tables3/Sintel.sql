CREATE TABLE [dbo].[Sintel] (
    [cd_sintel]           INT           NOT NULL,
    [nm_sintel]           VARCHAR (40)  NULL,
    [cd_departamento]     INT           NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    [nm_documento_sintel] VARCHAR (100) NULL,
    CONSTRAINT [PK_Sintel] PRIMARY KEY CLUSTERED ([cd_sintel] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sintel_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

