CREATE TABLE [dbo].[Idioma_Sistema] (
    [cd_idioma]        INT          NOT NULL,
    [nm_idioma]        VARCHAR (40) NULL,
    [sg_idioma]        CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [ic_padrao_idioma] CHAR (1)     NULL,
    CONSTRAINT [PK_Idioma_Sistema] PRIMARY KEY CLUSTERED ([cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

