CREATE TABLE [dbo].[departamento_liberacao_funcionario] (
    [cd_controle_liberacao] INT          NOT NULL,
    [cd_departamento]       INT          NOT NULL,
    [cd_tipo_aprovacao]     INT          NULL,
    [cd_funcionario]        INT          NULL,
    [nm_obs_liberacao]      VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_centro_custo]       INT          NULL,
    [cd_setor_funcionario]  INT          NULL,
    CONSTRAINT [PK_departamento_liberacao_funcionario] PRIMARY KEY CLUSTERED ([cd_controle_liberacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_departamento_liberacao_funcionario_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario]),
    CONSTRAINT [FK_Departamento_Liberacao_Funcionario_Setor_Funcionario] FOREIGN KEY ([cd_setor_funcionario]) REFERENCES [dbo].[Setor_Funcionario] ([cd_setor_funcionario])
);

