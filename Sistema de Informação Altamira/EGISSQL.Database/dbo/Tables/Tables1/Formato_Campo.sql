CREATE TABLE [dbo].[Formato_Campo] (
    [cd_documento_magnetico]     INT          NOT NULL,
    [cd_tipo_registro]           INT          NOT NULL,
    [cd_formato_campo]           INT          NOT NULL,
    [nm_campo_formato_campo]     VARCHAR (30) NULL,
    [nm_formato_campo]           VARCHAR (60) NULL,
    [ic_tipo_formato_campo]      CHAR (1)     NULL,
    [nm_mascara_formato_campo]   VARCHAR (30) NULL,
    [nm_mascara_nula_formato]    VARCHAR (30) NULL,
    [nm_conteudo_formato_campo]  VARCHAR (40) NULL,
    [qt_tamanho_formato_campo]   INT          NULL,
    [qt_decimal_formato_campo]   INT          NULL,
    [qt_inicial_formato_campo]   INT          NULL,
    [qt_final_formato_campo]     INT          NULL,
    [cd_usuario]                 INT          NOT NULL,
    [dt_usuario]                 DATETIME     NOT NULL,
    [sg_formato_campo]           CHAR (5)     NULL,
    [qt_p_inicio_formato_campo]  INT          NULL,
    [qt_p_final_formato_campo]   INT          NULL,
    [qt_p_inicial_formato_campo] INT          NULL,
    CONSTRAINT [PK_Formato_campo] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC, [cd_tipo_registro] ASC, [cd_formato_campo] ASC) WITH (FILLFACTOR = 90)
);

