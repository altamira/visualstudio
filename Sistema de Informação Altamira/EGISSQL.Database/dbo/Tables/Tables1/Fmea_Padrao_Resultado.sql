CREATE TABLE [dbo].[Fmea_Padrao_Resultado] (
    [cd_fmea_padrao]            INT          NULL,
    [cd_item_fmea_padrao]       INT          NULL,
    [cd_composicao_proc_padrao] INT          NULL,
    [cd_criterio_severidade]    INT          NULL,
    [cd_controle_deteccao]      INT          NULL,
    [cd_ocorrencia_falha]       INT          NULL,
    [qt_npr_resultado_fmea]     INT          NULL,
    [nm_obs_resultado_fmea]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuário]                DATETIME     NULL,
    [ds_acao_tomada_fmea]       TEXT         NULL
);

