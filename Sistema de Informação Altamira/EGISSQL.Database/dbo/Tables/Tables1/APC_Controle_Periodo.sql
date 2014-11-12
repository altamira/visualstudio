CREATE TABLE [dbo].[APC_Controle_Periodo] (
    [cd_controle]        INT          NOT NULL,
    [dt_inicio_periodo]  DATETIME     NULL,
    [dt_fim_periodo]     DATETIME     NULL,
    [ic_aberto_periodo]  CHAR (1)     NULL,
    [ic_fechado_periodo] CHAR (1)     NULL,
    [ic_report_periodo]  CHAR (1)     NULL,
    [nm_obs_periodo]     VARCHAR (60) NULL,
    [ds_periodo]         TEXT         NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [cd_ano]             INT          NULL,
    [cd_mes]             INT          NULL,
    [nm_titulo_periodo]  VARCHAR (40) NULL,
    CONSTRAINT [PK_APC_Controle_Periodo] PRIMARY KEY CLUSTERED ([cd_controle] ASC),
    CONSTRAINT [FK_APC_Controle_Periodo_Ano] FOREIGN KEY ([cd_ano]) REFERENCES [dbo].[Ano] ([cd_ano]),
    CONSTRAINT [FK_APC_Controle_Periodo_Mes] FOREIGN KEY ([cd_mes]) REFERENCES [dbo].[Mes] ([cd_mes])
);

