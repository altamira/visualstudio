CREATE TABLE [dbo].[Carga_Maquina] (
    [cd_maquina]                INT          NOT NULL,
    [cd_ordem_carga_maquina]    INT          NULL,
    [qt_carga_maquina]          FLOAT (53)   NULL,
    [qt_turno_carga_maquina]    INT          NULL,
    [ic_carga_maquina]          CHAR (1)     NULL,
    [dt_disp_carga_maquina]     DATETIME     NULL,
    [qt_dia_prog_carga_maquina] INT          NULL,
    [qt_prog_carga_maquina]     FLOAT (53)   NULL,
    [qt_operacao_carga_maquina] FLOAT (53)   NULL,
    [qt_disp_carga_maquina]     FLOAT (53)   NULL,
    [dt_atraso_carga_maquina]   DATETIME     NULL,
    [qt_atraso_carga_maquina]   FLOAT (53)   NULL,
    [ic_util_carga_maquina]     CHAR (1)     NULL,
    [nm_obs_carga_maquina]      VARCHAR (40) NULL,
    [dt_prog_carga_maquina]     DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_dia_atraso_carga_maq]   INT          NULL,
    CONSTRAINT [PK_Carga_Maquina] PRIMARY KEY CLUSTERED ([cd_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Carga_Maquina_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

