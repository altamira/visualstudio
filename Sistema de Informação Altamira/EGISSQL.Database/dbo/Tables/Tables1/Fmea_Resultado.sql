CREATE TABLE [dbo].[Fmea_Resultado] (
    [cd_fmea_padrao]            INT          NULL,
    [cd_item_fmea_padrao]       INT          NULL,
    [cd_composicao_proc_padrao] INT          NULL,
    [ds_acao_tomada_fmea]       TEXT         NULL,
    [cd_criterio_severidade]    INT          NULL,
    [cd_ocorrencia_falha]       INT          NULL,
    [cd_controle_deteccao]      INT          NULL,
    [qt_npr_resultado_fmea]     INT          NULL,
    [nm_obs_resultado_fmea]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL
);

