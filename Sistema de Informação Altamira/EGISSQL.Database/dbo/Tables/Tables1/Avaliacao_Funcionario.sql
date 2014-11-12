CREATE TABLE [dbo].[Avaliacao_Funcionario] (
    [cd_avaliacao_funcionario]  INT          NOT NULL,
    [dt_ini_aval_funcionario]   DATETIME     NULL,
    [dt_fim_aval_funcionario]   DATETIME     NULL,
    [cd_funcionario]            INT          NULL,
    [cd_cargo_funcionario]      INT          NULL,
    [cd_departamento]           INT          NULL,
    [cd_tipo_avaliacao]         INT          NULL,
    [qt_ponto_aval_funcionario] FLOAT (53)   NULL,
    [nm_obs_aval_funcionario]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Avaliacao_Funcionario] PRIMARY KEY CLUSTERED ([cd_avaliacao_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Avaliacao_Funcionario_Tipo_Avaliacao_Funcionario] FOREIGN KEY ([cd_tipo_avaliacao]) REFERENCES [dbo].[Tipo_Avaliacao_Funcionario] ([cd_tipo_aval_funcionario])
);

