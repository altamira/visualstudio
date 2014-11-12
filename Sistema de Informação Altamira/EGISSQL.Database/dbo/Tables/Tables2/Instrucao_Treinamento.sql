CREATE TABLE [dbo].[Instrucao_Treinamento] (
    [cd_instrucao]        INT          NOT NULL,
    [cd_item_treinamento] INT          NOT NULL,
    [cd_departamento]     INT          NULL,
    [cd_cargo_empresa]    INT          NULL,
    [nm_obs_treinamento]  VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Instrucao_Treinamento] PRIMARY KEY CLUSTERED ([cd_instrucao] ASC, [cd_item_treinamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Instrucao_Treinamento_Cargo_Empresa] FOREIGN KEY ([cd_cargo_empresa]) REFERENCES [dbo].[Cargo_Empresa] ([cd_cargo_empresa])
);

