CREATE TABLE [dbo].[Tipo_Transporte_Idioma] (
    [cd_tipo_transporte]        INT          NOT NULL,
    [cd_idioma]                 INT          NOT NULL,
    [nm_tipo_transporte_idioma] VARCHAR (30) NOT NULL,
    [sg_tipo_transporte_idioma] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Transporte_Idioma] PRIMARY KEY CLUSTERED ([cd_tipo_transporte] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

