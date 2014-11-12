CREATE TABLE [dbo].[Etiqueta_Zebra] (
    [cd_etiqueta]              INT          NOT NULL,
    [nm_etiqueta]              VARCHAR (30) NOT NULL,
    [qt_altura]                INT          NULL,
    [qt_comprimento]           INT          NULL,
    [qt_gap_vertical]          INT          NULL,
    [ic_velocidade_impressao]  CHAR (1)     NULL,
    [qt_temperatura_cabeca]    INT          NULL,
    [ic_orientacao]            CHAR (1)     NULL,
    [qt_deslocamento_x]        INT          NULL,
    [qt_deslocamento_y]        INT          NULL,
    [qt_etiqueta_linha]        INT          NULL,
    [qt_desloc_entre_etiqueta] INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Etiqueta_Zebra] PRIMARY KEY CLUSTERED ([cd_etiqueta] ASC) WITH (FILLFACTOR = 90)
);

