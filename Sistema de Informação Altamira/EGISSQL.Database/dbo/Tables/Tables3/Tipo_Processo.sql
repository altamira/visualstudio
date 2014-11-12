CREATE TABLE [dbo].[Tipo_Processo] (
    [cd_tipo_processo]            INT          NOT NULL,
    [nm_tipo_processo]            VARCHAR (40) NULL,
    [sg_tipo_processo]            CHAR (10)    NULL,
    [ic_pad_tipo_processo]        CHAR (1)     NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [nm_obs_tipo_processo]        VARCHAR (40) NULL,
    [cd_unidade_medida]           INT          NULL,
    [qt_fator_processo]           FLOAT (53)   NULL,
    [ic_sinal_conversao_processo] CHAR (1)     NULL,
    [ic_estoque_processo]         CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Processo] PRIMARY KEY CLUSTERED ([cd_tipo_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Processo_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

