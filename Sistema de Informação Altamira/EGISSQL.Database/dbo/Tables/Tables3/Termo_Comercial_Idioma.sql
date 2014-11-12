CREATE TABLE [dbo].[Termo_Comercial_Idioma] (
    [cd_termo_comercial]        INT          NOT NULL,
    [cd_idioma]                 INT          NOT NULL,
    [nm_termo_comercial_idioma] VARCHAR (50) NOT NULL,
    [sg_termo_comercial_idioma] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ds_termo_comercial_idioma] TEXT         NULL,
    CONSTRAINT [PK_Termo_Comercial_Idioma] PRIMARY KEY CLUSTERED ([cd_termo_comercial] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

