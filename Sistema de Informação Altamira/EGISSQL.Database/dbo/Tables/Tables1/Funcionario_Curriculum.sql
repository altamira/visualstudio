CREATE TABLE [dbo].[Funcionario_Curriculum] (
    [cd_funcionario]            INT           NOT NULL,
    [ds_funcionario_curriculum] TEXT          NULL,
    [nm_arquivo_cv_funcionario] VARCHAR (150) NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Funcionario_Curriculum] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Curriculum_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

