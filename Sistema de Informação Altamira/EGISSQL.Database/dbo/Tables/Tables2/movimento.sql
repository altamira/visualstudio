CREATE TABLE [dbo].[movimento] (
    [cd_movimento]              INT          NOT NULL,
    [cd_plano_financeiro]       INT          NOT NULL,
    [cd_tipo_lancamento_fluxo]  INT          NULL,
    [dt_movto_plano_financeiro] DATETIME     NULL,
    [vl_plano_financeiro]       FLOAT (53)   NULL,
    [nm_historico_movimento]    VARCHAR (20) NULL,
    [cd_historico_financeiro]   INT          NULL,
    [cd_tipo_operacao]          INT          NULL,
    [cd_moeda]                  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_lancamento_automatico]  CHAR (1)     NULL
);

