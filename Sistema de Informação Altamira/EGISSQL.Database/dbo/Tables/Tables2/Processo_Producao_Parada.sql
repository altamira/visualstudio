CREATE TABLE [dbo].[Processo_Producao_Parada] (
    [cd_processo]            INT         NOT NULL,
    [cd_item_processo]       INT         NOT NULL,
    [cd_processo_parada]     INT         NOT NULL,
    [cd_grupo_maquina]       INT         NULL,
    [cd_maquina]             INT         NULL,
    [cd_operador]            INT         NULL,
    [dt_processo_parada]     DATETIME    NULL,
    [hr_inicial_parada]      VARCHAR (8) NULL,
    [hr_final_parada]        VARCHAR (8) NULL,
    [cd_tipo_maquina_parada] INT         NULL,
    [cd_usuario]             INT         NULL,
    [dt_usuario]             DATETIME    NULL,
    [qt_processo_parada]     FLOAT (53)  NULL,
    CONSTRAINT [PK_Processo_Producao_Parada] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_processo] ASC, [cd_processo_parada] ASC) WITH (FILLFACTOR = 90)
);

