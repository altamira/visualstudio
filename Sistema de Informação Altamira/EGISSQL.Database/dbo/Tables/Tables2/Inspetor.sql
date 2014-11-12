CREATE TABLE [dbo].[Inspetor] (
    [cd_inspetor]         INT          NOT NULL,
    [nm_inspetor]         VARCHAR (40) NULL,
    [cd_departamento]     INT          NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [cd_usuario_cadastro] INT          NULL,
    CONSTRAINT [PK_Inspetor] PRIMARY KEY CLUSTERED ([cd_inspetor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Inspetor_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Inspetor_Usuario] FOREIGN KEY ([cd_usuario_cadastro]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

