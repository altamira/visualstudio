CREATE TABLE [dbo].[SPED_Bloco_Contabil] (
    [cd_bloco]               INT          NOT NULL,
    [sg_bloco]               CHAR (10)    NULL,
    [nm_bloco]               VARCHAR (60) NULL,
    [cd_grupo_bloco]         INT          NOT NULL,
    [cd_registro_bloco]      VARCHAR (10) NULL,
    [cd_nivel]               INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_arquivo_magnetico]   INT          NULL,
    [qt_linha_registro]      INT          NULL,
    [ic_soma_bloco]          CHAR (1)     NULL,
    [cd_indicador_movimento] INT          NULL,
    [ic_total_bloco]         CHAR (1)     NULL,
    CONSTRAINT [PK_SPED_Bloco_Contabil] PRIMARY KEY CLUSTERED ([cd_bloco] ASC),
    CONSTRAINT [FK_SPED_Bloco_Contabil_SPED_Fiscal_Indicador_Movimento] FOREIGN KEY ([cd_indicador_movimento]) REFERENCES [dbo].[SPED_Fiscal_Indicador_Movimento] ([cd_indicador_movimento])
);

