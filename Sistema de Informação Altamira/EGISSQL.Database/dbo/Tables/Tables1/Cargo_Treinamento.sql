CREATE TABLE [dbo].[Cargo_Treinamento] (
    [cd_cargo_funcionario] INT          NOT NULL,
    [cd_cargo_treinamento] INT          NOT NULL,
    [nm_cargo_treinamento] VARCHAR (60) NULL,
    [ds_cargo_treinamento] TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Treinamento] PRIMARY KEY CLUSTERED ([cd_cargo_funcionario] ASC, [cd_cargo_treinamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cargo_Treinamento_Cargo_Funcionario] FOREIGN KEY ([cd_cargo_funcionario]) REFERENCES [dbo].[Cargo_Funcionario] ([cd_cargo_funcionario])
);

