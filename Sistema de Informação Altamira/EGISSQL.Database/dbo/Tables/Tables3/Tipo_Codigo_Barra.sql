CREATE TABLE [dbo].[Tipo_Codigo_Barra] (
    [cd_tipo_codigo_barra]   INT          NOT NULL,
    [nm_tipo_codigo_barra]   VARCHAR (40) NULL,
    [sg_tipo_codigo_barra]   CHAR (10)    NULL,
    [ic_imprime_numero]      CHAR (1)     NULL,
    [qt_altura_codigo_barra] FLOAT (53)   NULL,
    [qt_num_min_caracter]    FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [qt_num_max_caracter]    FLOAT (53)   NULL,
    CONSTRAINT [PK_Tipo_Codigo_Barra] PRIMARY KEY CLUSTERED ([cd_tipo_codigo_barra] ASC) WITH (FILLFACTOR = 90)
);

