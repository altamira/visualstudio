CREATE TABLE [dbo].[Carga_Operador] (
    [cd_operador]                  INT          NOT NULL,
    [cd_ordem_carga_operador]      INT          NULL,
    [qt_carga_operador]            FLOAT (53)   NULL,
    [qt_turno_carga_operador]      FLOAT (53)   NULL,
    [ic_carga_operador]            CHAR (1)     NULL,
    [dt_disp_carga_operador]       DATETIME     NULL,
    [qt_dia_prog_carga_operador]   INT          NULL,
    [qt_prog_carga_operador]       FLOAT (53)   NULL,
    [qt_operacao_carga_operador]   FLOAT (53)   NULL,
    [qt_disp_carga_operador]       FLOAT (53)   NULL,
    [dt_atraso_carga_operador]     DATETIME     NULL,
    [qt_atraso_carga_operador]     FLOAT (53)   NULL,
    [ic_util_carga_operador]       CHAR (1)     NULL,
    [nm_obs_carga_operador]        VARCHAR (40) NULL,
    [dt_prog_carga_operador]       DATETIME     NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [qt_dia_atraso_carga_operador] FLOAT (53)   NULL,
    CONSTRAINT [PK_Carga_Operador] PRIMARY KEY CLUSTERED ([cd_operador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Carga_Operador_Operador] FOREIGN KEY ([cd_operador]) REFERENCES [dbo].[Operador] ([cd_operador])
);

