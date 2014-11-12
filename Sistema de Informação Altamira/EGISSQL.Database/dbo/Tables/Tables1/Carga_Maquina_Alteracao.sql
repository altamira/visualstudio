CREATE TABLE [dbo].[Carga_Maquina_Alteracao] (
    [cd_maquina]              INT          NOT NULL,
    [dt_inicio_alt_carga_maq] DATETIME     NULL,
    [dt_final_alt_carga_maq]  DATETIME     NULL,
    [qt_hora_alt_carga_maq]   FLOAT (53)   NULL,
    [cd_status_maquina]       INT          NULL,
    [nm_obs_alt_carga_maq]    VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_item_alt_carga_maq]   INT          NOT NULL,
    CONSTRAINT [PK_Carga_Maquina_Alteracao] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_item_alt_carga_maq] ASC) WITH (FILLFACTOR = 90)
);

