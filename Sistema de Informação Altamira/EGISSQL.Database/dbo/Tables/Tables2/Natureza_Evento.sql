CREATE TABLE [dbo].[Natureza_Evento] (
    [cd_natureza_evento]      INT          NOT NULL,
    [nm_natureza_evento]      VARCHAR (30) NOT NULL,
    [sg_natureza_evento]      CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_hora_natureza_evento] CHAR (1)     NULL,
    CONSTRAINT [PK_Natureza_Evento] PRIMARY KEY CLUSTERED ([cd_natureza_evento] ASC) WITH (FILLFACTOR = 90)
);

