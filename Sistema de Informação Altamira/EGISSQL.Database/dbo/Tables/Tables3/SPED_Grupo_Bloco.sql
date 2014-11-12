CREATE TABLE [dbo].[SPED_Grupo_Bloco] (
    [cd_grupo_bloco]         INT          NOT NULL,
    [nm_grupo_bloco]         VARCHAR (60) NULL,
    [sg_grupo_bloco]         CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_indicador_movimento] INT          NULL,
    [qt_linha_bloco]         INT          NULL,
    CONSTRAINT [PK_SPED_Grupo_Bloco] PRIMARY KEY CLUSTERED ([cd_grupo_bloco] ASC),
    CONSTRAINT [FK_SPED_Grupo_Bloco_SPED_Fiscal_Indicador_Movimento] FOREIGN KEY ([cd_indicador_movimento]) REFERENCES [dbo].[SPED_Fiscal_Indicador_Movimento] ([cd_indicador_movimento])
);

