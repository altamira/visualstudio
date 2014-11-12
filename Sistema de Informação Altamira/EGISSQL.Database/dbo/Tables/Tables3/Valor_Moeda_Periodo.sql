CREATE TABLE [dbo].[Valor_Moeda_Periodo] (
    [cd_controle]          INT          NOT NULL,
    [cd_moeda]             INT          NOT NULL,
    [dt_inicial_periodo]   DATETIME     NULL,
    [dt_final_periodo]     DATETIME     NULL,
    [vl_moeda_periodo]     FLOAT (53)   NULL,
    [nm_obs_moeda_periodo] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_ativo_periodo]     CHAR (1)     NULL,
    CONSTRAINT [PK_Valor_Moeda_Periodo] PRIMARY KEY CLUSTERED ([cd_controle] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Valor_Moeda_Periodo_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

