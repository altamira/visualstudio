CREATE TABLE [dbo].[Idioma] (
    [cd_idioma]                INT          NOT NULL,
    [nm_idioma]                VARCHAR (30) NOT NULL,
    [sg_idioma]                CHAR (5)     NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ic_pad_importacao_idioma] CHAR (1)     NULL,
    [ic_egis_idioma]           CHAR (1)     NULL,
    CONSTRAINT [PK_Idioma] PRIMARY KEY CLUSTERED ([cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

