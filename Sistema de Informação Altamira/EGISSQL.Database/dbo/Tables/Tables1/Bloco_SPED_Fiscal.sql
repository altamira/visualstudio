CREATE TABLE [dbo].[Bloco_SPED_Fiscal] (
    [cd_bloco]             INT          NOT NULL,
    [sg_bloco]             CHAR (10)    NULL,
    [nm_bloco]             VARCHAR (60) NULL,
    [cd_grupo_bloco]       INT          NOT NULL,
    [cd_registro_bloco]    VARCHAR (10) NULL,
    [cd_nivel]             INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_arquivo_magnetico] INT          NULL,
    CONSTRAINT [PK_Bloco_SPED_Fiscal] PRIMARY KEY CLUSTERED ([cd_bloco] ASC) WITH (FILLFACTOR = 90)
);

