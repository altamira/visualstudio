CREATE TABLE [dbo].[Limite_Viagem] (
    [cd_limite_viagem]      INT          NOT NULL,
    [cd_centro_custo]       INT          NULL,
    [cd_departamento]       INT          NULL,
    [cd_funcionario]        INT          NULL,
    [cd_projeto_viagem]     INT          NULL,
    [vl_limite_viagem]      FLOAT (53)   NULL,
    [nm_obs_limite_viagem]  VARCHAR (40) NULL,
    [cd_tipo_limite_viagem] INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Limite_Viagem] PRIMARY KEY CLUSTERED ([cd_limite_viagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Limite_Viagem_Projeto_Viagem] FOREIGN KEY ([cd_projeto_viagem]) REFERENCES [dbo].[Projeto_Viagem] ([cd_projeto_viagem])
);

