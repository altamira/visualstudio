CREATE TABLE [dbo].[Processo_Producao_Texto] (
    [cd_processo_producao]      INT      NOT NULL,
    [cd_item_processo_producao] INT      NOT NULL,
    [cd_tipo_texto_processo]    INT      NOT NULL,
    [ds_processo_prod_texto]    TEXT     NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Processo_Producao_Texto] PRIMARY KEY CLUSTERED ([cd_processo_producao] ASC, [cd_item_processo_producao] ASC, [cd_tipo_texto_processo] ASC) WITH (FILLFACTOR = 90)
);

