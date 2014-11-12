CREATE TABLE [dbo].[Apontamento_Funcionario] (
    [cd_apontamento]        INT          NOT NULL,
    [dt_apontamento]        DATETIME     NULL,
    [cd_tipo_apontamento]   INT          NULL,
    [cd_funcionario]        INT          NULL,
    [hr_inicio_apontamento] VARCHAR (8)  NULL,
    [hr_final_apontamento]  VARCHAR (8)  NULL,
    [qt_hora_apontamento]   FLOAT (53)   NULL,
    [nm_obs_apontamento]    VARCHAR (40) NULL,
    [cd_lancamento_folha]   INT          NULL,
    CONSTRAINT [PK_Apontamento_Funcionario] PRIMARY KEY CLUSTERED ([cd_apontamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Apontamento_Funcionario_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

