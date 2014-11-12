CREATE TABLE [dbo].[Treinamento_Espera] (
    [cd_treinamento_espera]     INT          NOT NULL,
    [cd_curso]                  INT          NULL,
    [dt_cadastro_espera]        DATETIME     NULL,
    [cd_funcionario]            INT          NULL,
    [nm_obs_treinamento_espera] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Treinamento_Espera] PRIMARY KEY CLUSTERED ([cd_treinamento_espera] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Treinamento_Espera_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

