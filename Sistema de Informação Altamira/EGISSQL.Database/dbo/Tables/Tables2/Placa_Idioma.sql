CREATE TABLE [dbo].[Placa_Idioma] (
    [cd_placa]        INT          NOT NULL,
    [cd_idioma]       INT          NOT NULL,
    [nm_placa_idioma] VARCHAR (40) NOT NULL,
    [sg_placa_idioma] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Placa_Idioma] PRIMARY KEY CLUSTERED ([cd_placa] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);

