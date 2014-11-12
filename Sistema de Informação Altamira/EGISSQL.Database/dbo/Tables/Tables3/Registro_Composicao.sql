CREATE TABLE [dbo].[Registro_Composicao] (
    [cd_documento_fiscal]       INT          NOT NULL,
    [cd_tipo_registro]          INT          NOT NULL,
    [cd_registro]               INT          NOT NULL,
    [nm_registro]               VARCHAR (50) NOT NULL,
    [nm_fantasia_registro]      VARCHAR (20) NOT NULL,
    [qt_posicao_inicial_regist] INT          NOT NULL,
    [qt_posicao_final_registro] INT          NOT NULL,
    [qt_tamanho_registro]       INT          NOT NULL,
    [nm_mascara_registro]       VARCHAR (20) NULL,
    [cd_formato_campo]          INT          NOT NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Registro_composicao] PRIMARY KEY NONCLUSTERED ([cd_documento_fiscal] ASC, [cd_tipo_registro] ASC, [cd_registro] ASC) WITH (FILLFACTOR = 90)
);

