CREATE TABLE [dbo].[Funcionario_Estrangeiro] (
    [cd_funcionario]              INT          NOT NULL,
    [dt_chegada_funcionario]      DATETIME     NULL,
    [is_esposa_funcionario]       CHAR (1)     NULL,
    [ic_naturalizado_funcionario] CHAR (1)     NULL,
    [cd_carteira_mod19]           VARCHAR (25) NULL,
    [cd_rg_funcionario]           VARCHAR (18) NULL,
    [ic_filho_brasileiro]         CHAR (1)     NULL,
    [qt_filho_brasileiro]         INT          NULL,
    [cd_pais]                     INT          NULL,
    [nm_obs_funcionario]          VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Estrangeiro] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Estrangeiro_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

