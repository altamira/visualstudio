CREATE TABLE [dbo].[Parametro_Servico_Geral] (
    [cd_empresa]     INT NOT NULL,
    [cd_funcionario] INT NULL,
    CONSTRAINT [PK_Parametro_Servico_Geral] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Servico_Geral_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

