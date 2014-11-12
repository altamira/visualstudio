CREATE TABLE [dbo].[Config_Prestacao_Controlada] (
    [cd_empresa]             INT      NOT NULL,
    [cd_funcionario]         INT      NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    [dt_inicio_adiantamento] DATETIME NULL,
    CONSTRAINT [PK_Config_Prestacao_Controlada] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Config_Prestacao_Controlada_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

