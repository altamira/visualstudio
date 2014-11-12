CREATE TABLE [dbo].[Etiqueta_Zebra_Campo] (
    [cd_etiqueta]             INT           NOT NULL,
    [cd_etiqueta_campo]       INT           NOT NULL,
    [nm_etiqueta_campo]       VARCHAR (30)  NOT NULL,
    [ic_tipo_campo]           CHAR (1)      NOT NULL,
    [qt_posicao_horizontal]   INT           NOT NULL,
    [qt_posicao_vertical]     INT           NOT NULL,
    [ic_rotacao]              CHAR (1)      NULL,
    [ic_tipo_fonte]           CHAR (1)      NULL,
    [qt_largura_fonte]        INT           NULL,
    [qt_altura_fonte]         INT           NULL,
    [ic_forma_impressao]      CHAR (1)      NULL,
    [ic_tipo_codigo_barra]    CHAR (3)      NULL,
    [qt_largura_barra_fina]   INT           NULL,
    [qt_largura_barra_grossa] INT           NULL,
    [qt_altura_barra]         INT           NULL,
    [ic_texto_barra]          CHAR (1)      NULL,
    [nm_conteudo_campo]       VARCHAR (100) NULL,
    [ic_dado_campo]           CHAR (2)      NULL,
    CONSTRAINT [PK_Etiqueta_Zebra_Campo] PRIMARY KEY CLUSTERED ([cd_etiqueta] ASC, [cd_etiqueta_campo] ASC) WITH (FILLFACTOR = 90)
);

