CREATE TABLE [dbo].[Departamento_Atividade] (
    [cd_departamento]        INT          NOT NULL,
    [cd_atividade]           INT          NOT NULL,
    [nm_obs_depto_atividade] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Departamento_Atividade] PRIMARY KEY CLUSTERED ([cd_departamento] ASC, [cd_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Atividade_Atividade] FOREIGN KEY ([cd_atividade]) REFERENCES [dbo].[Atividade] ([cd_atividade])
);

