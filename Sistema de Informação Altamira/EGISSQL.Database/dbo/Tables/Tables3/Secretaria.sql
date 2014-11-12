CREATE TABLE [dbo].[Secretaria] (
    [cd_secretaria]          INT          NOT NULL,
    [nm_secretaria]          VARCHAR (40) NULL,
    [nm_fantasia_secretaria] VARCHAR (15) NULL,
    [cd_funcionario]         INT          NULL,
    [cd_departamento]        INT          NULL,
    [cd_centro_custo]        INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_usuario_sistema]     INT          NULL,
    CONSTRAINT [PK_Secretaria] PRIMARY KEY CLUSTERED ([cd_secretaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Secretaria_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Secretaria_Usuario] FOREIGN KEY ([cd_usuario_sistema]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

