CREATE TABLE [dbo].[Politica_Finalidade_Pagamento] (
    [cd_politica_finalidade]     INT          NOT NULL,
    [cd_politica_viagem]         INT          NULL,
    [cd_departamento]            INT          NULL,
    [cd_centro_custo]            INT          NULL,
    [cd_funcionario]             INT          NULL,
    [ic_permite_finalidade]      CHAR (1)     NULL,
    [nm_obs_politica_finalidade] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Politica_Finalidade_Pagamento] PRIMARY KEY CLUSTERED ([cd_politica_finalidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Politica_Finalidade_Pagamento_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

