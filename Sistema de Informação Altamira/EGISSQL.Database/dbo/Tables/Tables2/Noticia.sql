CREATE TABLE [dbo].[Noticia] (
    [cd_noticia]       INT          NOT NULL,
    [nm_noticia]       VARCHAR (40) NOT NULL,
    [sg_noticia]       CHAR (10)    NOT NULL,
    [ds_noticia]       TEXT         NOT NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [ic_ativa_noticia] CHAR (1)     NULL,
    [dt_noticia]       DATETIME     NULL,
    CONSTRAINT [PK_Noticia] PRIMARY KEY CLUSTERED ([cd_noticia] ASC) WITH (FILLFACTOR = 90)
);

