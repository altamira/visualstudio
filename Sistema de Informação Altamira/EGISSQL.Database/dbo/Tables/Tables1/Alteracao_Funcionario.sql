CREATE TABLE [dbo].[Alteracao_Funcionario] (
    [cd_alteracao_funcionario] INT          NOT NULL,
    [nm_alteracao_funcionario] VARCHAR (50) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Alteracao_Funcionario] PRIMARY KEY CLUSTERED ([cd_alteracao_funcionario] ASC)
);

