CREATE TABLE [dbo].[Cargo_Funcionario] (
    [cd_cargo_funcionario]     INT          NOT NULL,
    [nm_cargo_funcionario]     VARCHAR (30) NOT NULL,
    [sg_cargo_funcionario]     CHAR (10)    NOT NULL,
    [cd_cbo_cargo_funcionario] VARCHAR (15) NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ds_cargo_funcionario]     TEXT         NULL,
    [ic_periculosidade_cargo]  CHAR (1)     NULL,
    [ic_insalubridade_cargo]   CHAR (1)     NULL,
    [ic_adic_noturno_cargo]    CHAR (1)     NULL,
    [cd_departamento]          INT          NULL,
    [cd_centro_custo]          INT          NULL,
    [cd_cbo_anterior]          VARCHAR (15) NULL,
    CONSTRAINT [PK_Cargo_Funcionario] PRIMARY KEY CLUSTERED ([cd_cargo_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cargo_Funcionario_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Cargo_Funcionario_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

