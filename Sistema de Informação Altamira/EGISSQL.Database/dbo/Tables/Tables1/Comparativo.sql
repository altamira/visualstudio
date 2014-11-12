CREATE TABLE [dbo].[Comparativo] (
    [cd_comparativo]         INT          NOT NULL,
    [nm_comparativo]         VARCHAR (40) NULL,
    [vl_total]               FLOAT (53)   NULL,
    [vl_comparativo]         FLOAT (53)   NULL,
    [vl_diferenca]           FLOAT (53)   NULL,
    [pc_evolucao_total]      FLOAT (53)   NULL,
    [qt_total]               FLOAT (53)   NULL,
    [qt_comparativo]         FLOAT (53)   NULL,
    [qt_diferenca]           FLOAT (53)   NULL,
    [pc_evolucao_quantidade] FLOAT (53)   NULL,
    [cd_posicao_atual]       INT          NULL,
    [cd_posicao_anterior]    INT          NULL,
    [nm_obs_comparativo]     VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [dt_final]               DATETIME     NULL,
    [dt_inicial]             DATETIME     NULL,
    [dt_comparativo]         DATETIME     NULL,
    [cd_localizacao]         INT          NULL,
    CONSTRAINT [PK_Comparativo] PRIMARY KEY CLUSTERED ([cd_comparativo] ASC) WITH (FILLFACTOR = 90)
);

