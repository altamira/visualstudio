CREATE TABLE [dbo].[Remessa_Arquivo_Magnetico] (
    [cd_arquivo_magnetico] INT          NOT NULL,
    [qt_remessa_arquivo]   INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [nm_obs_remessa_banco] VARCHAR (40) NULL,
    [dt_remessa_arquivo]   DATETIME     NULL,
    CONSTRAINT [PK_Remessa_Arquivo_Magnetico] PRIMARY KEY CLUSTERED ([cd_arquivo_magnetico] ASC) WITH (FILLFACTOR = 90)
);

