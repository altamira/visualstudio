CREATE TABLE [dbo].[Documento_Arquivo_Magnetico_Posicao] (
    [cd_documento_magnetico]         INT          NOT NULL,
    [qt_posicao_documento]           INT          NULL,
    [qt_posicao_instrucao]           INT          NULL,
    [qt_posicao_documento_instrucao] INT          NULL,
    [qt_posicao_sequencial]          INT          NULL,
    [qt_posicao_bancario]            INT          NULL,
    [qt_posicao_valor_documento]     INT          NULL,
    [qt_posicao_juros]               INT          NULL,
    [nm_obs_posicao]                 VARCHAR (50) NULL,
    [cd_usuario]                     INT          NULL,
    [dt_usuario]                     DATETIME     NULL,
    CONSTRAINT [PK_Documento_Arquivo_Magnetico_Posicao] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC)
);

