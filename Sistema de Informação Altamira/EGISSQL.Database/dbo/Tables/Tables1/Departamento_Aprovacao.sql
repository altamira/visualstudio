CREATE TABLE [dbo].[Departamento_Aprovacao] (
    [cd_departamento]           INT          NOT NULL,
    [cd_departamento_aprovacao] INT          NOT NULL,
    [cd_tipo_aprovacao]         INT          NOT NULL,
    [nm_obs_depto_aprovacao]    VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_aprova_requisicao]      CHAR (1)     NULL,
    [cd_centro_custo]           INT          NULL,
    CONSTRAINT [PK_Departamento_Aprovacao] PRIMARY KEY CLUSTERED ([cd_departamento] ASC, [cd_departamento_aprovacao] ASC, [cd_tipo_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Aprovacao_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
);

