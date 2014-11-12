CREATE TABLE [dbo].[Norma_ISO] (
    [cd_norma_iso]   INT          NOT NULL,
    [nm_norma_iso]   VARCHAR (60) NULL,
    [ds_norma_iso]   TEXT         NULL,
    [cd_mascara_iso] VARCHAR (20) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Norma_ISO] PRIMARY KEY CLUSTERED ([cd_norma_iso] ASC) WITH (FILLFACTOR = 90)
);

