CREATE TABLE [dbo].[Tipo_Codificacao] (
    [cd_tipo_codificacao]        INT          NOT NULL,
    [nm_tipo_codificacao]        VARCHAR (40) NOT NULL,
    [sg_tipo_codificacao]        CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [qt_digito_tipo_codificacao] FLOAT (53)   NULL,
    CONSTRAINT [PK_Tipo_Codificacao] PRIMARY KEY CLUSTERED ([cd_tipo_codificacao] ASC) WITH (FILLFACTOR = 90)
);

