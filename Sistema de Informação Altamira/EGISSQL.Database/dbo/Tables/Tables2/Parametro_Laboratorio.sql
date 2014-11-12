CREATE TABLE [dbo].[Parametro_Laboratorio] (
    [cd_empresa]                INT      NOT NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [ds_cabecalho_nao_conforme] TEXT     NULL,
    [ds_rodape_nao_conform]     TEXT     NULL,
    [qt_casas_decimais_formula] INT      NULL,
    CONSTRAINT [PK_Parametro_Laboratorio] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);

