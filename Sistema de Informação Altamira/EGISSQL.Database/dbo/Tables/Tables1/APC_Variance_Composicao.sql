CREATE TABLE [dbo].[APC_Variance_Composicao] (
    [cd_controle]           INT          NOT NULL,
    [cd_item_variance]      INT          NOT NULL,
    [cd_unidade_negocio]    INT          NULL,
    [cd_divisao_unidade]    INT          NULL,
    [cd_dimensao]           INT          NULL,
    [vl_variance]           FLOAT (53)   NULL,
    [nm_obs_variance]       VARCHAR (60) NULL,
    [cd_centro_custo]       INT          NULL,
    [cd_conta_income]       INT          NULL,
    [cd_conta_income_sport] INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_APC_Variance_Composicao] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_variance] ASC)
);

