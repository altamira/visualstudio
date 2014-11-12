CREATE TABLE [dbo].[Contrato_Forn_It_Mes_Liberacao] (
    [cd_lib_item_contrato_forn] INT        NULL,
    [cd_contrato_fornecimento]  INT        NULL,
    [cd_item_contrato]          INT        NULL,
    [cd_mes]                    INT        NULL,
    [cd_ano]                    INT        NULL,
    [qt_lib_item_contrato_forn] FLOAT (53) NULL,
    [dt_lib_item_contrato_forn] DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL
);

