CREATE TABLE [dbo].[Programacao] (
    [cd_programacao]            INT         NOT NULL,
    [cd_maquina]                INT         NULL,
    [dt_programacao]            DATETIME    NULL,
    [qt_hora_operacao_maquina]  FLOAT (53)  NULL,
    [qt_hora_prog_maquina]      FLOAT (53)  NULL,
    [qt_hora_reservada_maquina] FLOAT (53)  NULL,
    [qt_hora_simulada_maquina]  FLOAT (53)  NULL,
    [qt_processo_prog_maquina]  FLOAT (53)  NULL,
    [qt_hora_prog_simulacao]    FLOAT (53)  NULL,
    [qt_hora_disp_simulacao]    FLOAT (53)  NULL,
    [cd_ult_item_simulacao]     INT         NULL,
    [ic_fim_producao]           CHAR (1)    NULL,
    [ds_programacao]            TEXT        NULL,
    [cd_usuario]                INT         NULL,
    [dt_usuario]                DATETIME    NULL,
    [qt_hora_prod_maquina]      FLOAT (53)  NULL,
    [hr_inicio_programacao]     VARCHAR (8) NULL,
    [hr_final_programacao]      VARCHAR (8) NULL,
    CONSTRAINT [PK_Programacao] PRIMARY KEY CLUSTERED ([cd_programacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

