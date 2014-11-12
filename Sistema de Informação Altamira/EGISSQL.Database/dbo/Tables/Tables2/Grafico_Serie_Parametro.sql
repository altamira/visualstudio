CREATE TABLE [dbo].[Grafico_Serie_Parametro] (
    [cd_grafico_serie]         INT          NOT NULL,
    [cd_item_grafico_serie]    INT          NOT NULL,
    [nm_dataset_grafico_serie] VARCHAR (40) NULL,
    [nm_label_grafico_serie]   VARCHAR (40) NULL,
    [nm_valx_grafico_serie]    VARCHAR (40) NULL,
    [nm_valy_grafico_serie]    VARCHAR (40) NULL,
    [cd_grafico_serie_origem]  INT          NULL,
    [ds_titulo_grafico_serie]  TEXT         NULL,
    [ic_legenda_grafico_serie] CHAR (1)     NULL,
    [ic_eixo_grafico_serie]    CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Grafico_Serie_Parametro] PRIMARY KEY CLUSTERED ([cd_grafico_serie] ASC, [cd_item_grafico_serie] ASC) WITH (FILLFACTOR = 90)
);

