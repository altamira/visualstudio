CREATE TABLE [dbo].[Centro_Custo_Aprovacao_Funcionario] (
    [cd_centro_custo]        INT          NOT NULL,
    [cd_tipo_aprovacao]      INT          NOT NULL,
    [nm_obs_depto_aprovacao] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_aprova_requisicao]   CHAR (1)     NULL,
    [cd_funcionario]         INT          NOT NULL,
    CONSTRAINT [PK_Centro_Custo_Aprovacao_Funcionario] PRIMARY KEY CLUSTERED ([cd_centro_custo] ASC, [cd_tipo_aprovacao] ASC, [cd_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Custo_Aprovacao_Funcionario_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

