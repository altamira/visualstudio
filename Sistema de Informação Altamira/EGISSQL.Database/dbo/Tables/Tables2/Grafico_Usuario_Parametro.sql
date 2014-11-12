CREATE TABLE [dbo].[Grafico_Usuario_Parametro] (
    [cd_usuario_parametro]      INT          NOT NULL,
    [cd_grafico_usuario]        INT          NOT NULL,
    [cd_item_grafico_usuario]   INT          NOT NULL,
    [nm_dataset_graf_usuario]   VARCHAR (40) NULL,
    [nm_label_grafico_usuario]  VARCHAR (40) NULL,
    [nm_valx_grafico_usuario]   VARCHAR (40) NULL,
    [nm_valory_grafico_usuario] VARCHAR (40) NULL,
    [cd_grafico_usuario_origem] INT          NULL,
    [ds_titulo_grafico_usuario] TEXT         NULL,
    [ic_legenda_graf_usuario]   CHAR (1)     NULL,
    [ic_eixo_grafico_usuario]   CHAR (1)     NULL,
    [nm_eixo_grafico_usuario]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Grafico_Usuario_Parametro] PRIMARY KEY CLUSTERED ([cd_usuario_parametro] ASC, [cd_item_grafico_usuario] ASC) WITH (FILLFACTOR = 90)
);

