CREATE TABLE [dbo].[Exercicio_Fisico] (
    [cd_exercicio]       INT          NOT NULL,
    [nm_exercicio]       VARCHAR (40) NULL,
    [cd_grupo_exercicio] INT          NULL,
    [nm_obs_exercicio]   VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Exercicio_Fisico] PRIMARY KEY CLUSTERED ([cd_exercicio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Exercicio_Fisico_Grupo_Exercicio] FOREIGN KEY ([cd_grupo_exercicio]) REFERENCES [dbo].[Grupo_Exercicio] ([cd_grupo_exercicio])
);

