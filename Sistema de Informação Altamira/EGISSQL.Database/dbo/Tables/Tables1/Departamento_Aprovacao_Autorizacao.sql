CREATE TABLE [dbo].[Departamento_Aprovacao_Autorizacao] (
    [cd_controle_aprovacao]     INT          NOT NULL,
    [cd_funcionario]            INT          NULL,
    [cd_funcionario_autorizado] INT          NULL,
    [dt_inicio_aprovacao]       DATETIME     NULL,
    [dt_fim_aprovacao]          DATETIME     NULL,
    [cd_tipo_ausencia]          INT          NULL,
    [cd_tipo_aprovacao]         INT          NULL,
    [nm_obs_aprovacao]          VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Departamento_Aprovacao_Autorizacao] PRIMARY KEY CLUSTERED ([cd_controle_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Aprovacao_Autorizacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

