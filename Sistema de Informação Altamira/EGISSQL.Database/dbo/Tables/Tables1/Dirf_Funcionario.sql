CREATE TABLE [dbo].[Dirf_Funcionario] (
    [cd_dirf]                 INT          NOT NULL,
    [cd_funcionario]          INT          NOT NULL,
    [cd_dirf_mes]             INT          NOT NULL,
    [cd_evento_dirf]          INT          NOT NULL,
    [vl_evento_dirf]          FLOAT (53)   NULL,
    [nm_obs_dirf_funcionario] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Dirf_Funcionario] PRIMARY KEY CLUSTERED ([cd_dirf] ASC, [cd_funcionario] ASC, [cd_dirf_mes] ASC, [cd_evento_dirf] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Dirf_Funcionario_Evento_DIRF] FOREIGN KEY ([cd_evento_dirf]) REFERENCES [dbo].[Evento_DIRF] ([cd_evento_dirf])
);

