CREATE TABLE [dbo].[Dipi_Apuracao] (
    [cd_ano]               INT        NOT NULL,
    [cd_mes]               INT        NOT NULL,
    [cd_descendio_dipi]    INT        NOT NULL,
    [vl_deb_ipi_dipi]      FLOAT (53) NULL,
    [vl_deb_obs_ipi_dipi]  FLOAT (53) NULL,
    [vl_cred_ipi_dipi]     FLOAT (53) NULL,
    [dt_inicial_dipi]      DATETIME   NULL,
    [dt_final_dipi]        DATETIME   NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    [vl_cred_obs_ipi_dipi] FLOAT (53) NULL,
    CONSTRAINT [PK_Dipi_Apuracao] PRIMARY KEY CLUSTERED ([cd_ano] ASC, [cd_mes] ASC, [cd_descendio_dipi] ASC) WITH (FILLFACTOR = 90)
);

