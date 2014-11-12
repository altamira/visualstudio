CREATE TABLE [dbo].[Parametro_Manutencao] (
    [cd_empresa]                INT      NOT NULL,
    [ic_manutencao_scr_empresa] CHAR (1) NULL,
    [ic_manutencao_spe_empresa] CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Parametro_Manutencao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

