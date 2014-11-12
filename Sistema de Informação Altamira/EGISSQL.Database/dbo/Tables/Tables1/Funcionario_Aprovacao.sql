CREATE TABLE [dbo].[Funcionario_Aprovacao] (
    [cd_funcionario]               INT          NOT NULL,
    [cd_funcionario_aprovacao]     INT          NOT NULL,
    [cd_tipo_aprovacao]            INT          NOT NULL,
    [nm_obs_funcionario_aprovacao] VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Aprovacao] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_funcionario_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Aprovacao_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

