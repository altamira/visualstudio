CREATE TABLE [dbo].[Dirf] (
    [cd_dirf]             INT          NOT NULL,
    [nm_dirf]             VARCHAR (40) NULL,
    [dt_dirf]             DATETIME     NULL,
    [qt_ano]              INT          NULL,
    [cd_retencao_irrf]    INT          NULL,
    [dt_geracao_dirf]     DATETIME     NULL,
    [dt_retificacao_irrf] DATETIME     NULL,
    [nm_obs_dirf]         VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Dirf] PRIMARY KEY CLUSTERED ([cd_dirf] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Dirf_Retencao_IRRF] FOREIGN KEY ([cd_retencao_irrf]) REFERENCES [dbo].[Retencao_IRRF] ([cd_retencao_irrf])
);

