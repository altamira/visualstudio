CREATE TABLE [dbo].[Grafico_Serie] (
    [cd_grafico_serie]         INT          NOT NULL,
    [nm_grafico_serie]         VARCHAR (40) NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [ic_legenda_grafico_serie] CHAR (1)     NULL,
    [ds_titulo_grafico_serie]  TEXT         NULL,
    [cd_menu]                  INT          NULL,
    [cd_modulo]                INT          NULL,
    [cd_tipo_funcao_grafico]   INT          NULL,
    [cd_funcao_grafico]        INT          NULL,
    [cd_estilo_grafico]        INT          NULL,
    [cd_tipo_grafico]          INT          NULL,
    CONSTRAINT [PK_Grafico_Serie] PRIMARY KEY CLUSTERED ([cd_grafico_serie] ASC) WITH (FILLFACTOR = 90)
);

