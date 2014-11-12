CREATE TABLE [dbo].[Funcionario_Seguro] (
    [cd_funcionario]         INT          NOT NULL,
    [cd_seguradora]          INT          NULL,
    [cd_apolice_funcionario] VARCHAR (20) NULL,
    [dt_inicial_apolice]     DATETIME     NULL,
    [dt_final_apolice]       DATETIME     NULL,
    [nm_obs_apolice]         VARCHAR (60) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [dt_apolice]             DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Seguro] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Seguro_Seguradora] FOREIGN KEY ([cd_seguradora]) REFERENCES [dbo].[Seguradora] ([cd_seguradora])
);

