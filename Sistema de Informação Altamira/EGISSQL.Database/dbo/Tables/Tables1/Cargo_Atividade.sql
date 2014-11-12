CREATE TABLE [dbo].[Cargo_Atividade] (
    [cd_cargo_funcionario] INT          NOT NULL,
    [cd_cargo_atividade]   INT          NOT NULL,
    [nm_cargo_atividade]   VARCHAR (60) NULL,
    [ds_cargo_atividade]   TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Atividade] PRIMARY KEY CLUSTERED ([cd_cargo_funcionario] ASC, [cd_cargo_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cargo_Atividade_Cargo_Funcionario] FOREIGN KEY ([cd_cargo_funcionario]) REFERENCES [dbo].[Cargo_Funcionario] ([cd_cargo_funcionario])
);

