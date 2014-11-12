CREATE TABLE [dbo].[Registro_Calibracao_Composicao] (
    [cd_registro_calibracao]       INT          NOT NULL,
    [cd_item_registro_calibracao]  INT          NULL,
    [nm_escala_registro]           VARCHAR (40) NULL,
    [nm_faixa_registro]            VARCHAR (40) NULL,
    [qt_criterio_registro]         FLOAT (53)   NULL,
    [qt_erro_sistematico_registro] FLOAT (53)   NULL,
    [qt_incerteza_registro]        FLOAT (53)   NULL,
    [ic_status_registro]           CHAR (1)     NULL,
    [nm_obs_registro]              VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Registro_Calibracao_Composicao] PRIMARY KEY CLUSTERED ([cd_registro_calibracao] ASC) WITH (FILLFACTOR = 90)
);

