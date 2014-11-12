CREATE TABLE [dbo].[Etiqueta_Campo] (
    [cd_etiqueta_layout]        INT           NOT NULL,
    [cd_etiqueta_campo]         INT           NOT NULL,
    [ic_condensado_campo]       CHAR (1)      NULL,
    [ic_negrito_campo]          CHAR (1)      NULL,
    [cd_posicao_inicial_linha]  INT           NULL,
    [cd_posicao_inicial_coluna] INT           NULL,
    [qt_max_coluna_campo]       FLOAT (53)    NULL,
    [ic_alinhamento_campo]      CHAR (1)      NULL,
    [nm_atributo_origem_dado]   VARCHAR (100) NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ic_exibe_label]            CHAR (1)      NULL,
    [nm_exibe_label]            VARCHAR (50)  NULL,
    CONSTRAINT [PK_Etiqueta_Campo] PRIMARY KEY CLUSTERED ([cd_etiqueta_layout] ASC, [cd_etiqueta_campo] ASC) WITH (FILLFACTOR = 90)
);

