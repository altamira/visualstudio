CREATE TABLE [dbo].[Departamento_Aprovacao_Funcionario] (
    [cd_controle_aprovacao]   INT          NOT NULL,
    [cd_departamento]         INT          NOT NULL,
    [cd_tipo_aprovacao]       INT          NOT NULL,
    [cd_funcionario]          INT          NOT NULL,
    [cd_centro_custo]         INT          NOT NULL,
    [cd_usuario]              INT          NULL,
    [ic_aprova_requisicao]    CHAR (1)     NULL,
    [dt_usuario]              DATETIME     NULL,
    [nm_obs_depto_aprovacao]  VARCHAR (40) NULL,
    [cd_tipo_viagem]          INT          NULL,
    [ic_liberacao_aprovacao]  CHAR (1)     NULL,
    [ic_aprovacao_individual] CHAR (1)     NULL,
    [cd_setor_funcionario]    INT          NULL,
    [ic_informativo_viagem]   CHAR (1)     NULL,
    [ic_viagem_internacional] CHAR (1)     NULL,
    CONSTRAINT [PK_Departamento_Aprovacao_Funcionario] PRIMARY KEY CLUSTERED ([cd_controle_aprovacao] ASC, [cd_departamento] ASC, [cd_tipo_aprovacao] ASC, [cd_funcionario] ASC, [cd_centro_custo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Aprovacao_Funcionario_Setor_Funcionario] FOREIGN KEY ([cd_setor_funcionario]) REFERENCES [dbo].[Setor_Funcionario] ([cd_setor_funcionario]),
    CONSTRAINT [FK_Departamento_Aprovacao_Funcionario_Tipo_Viagem] FOREIGN KEY ([cd_tipo_viagem]) REFERENCES [dbo].[Tipo_Viagem] ([cd_tipo_viagem])
);

