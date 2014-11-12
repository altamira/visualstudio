CREATE TABLE [dbo].[APC_CEV_Composicao] (
    [cd_controle]         INT          NOT NULL,
    [cd_item_cev]         INT          NOT NULL,
    [cd_unidade_negocio]  INT          NULL,
    [cd_divisao_unidade]  INT          NULL,
    [cd_dimensao]         INT          NULL,
    [cd_conta]            INT          NULL,
    [vl_custo_composicao] FLOAT (53)   NULL,
    [nm_obs_cev]          VARCHAR (60) NULL,
    [cd_centro_custo]     INT          NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_APC_CEV_Composicao] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_cev] ASC),
    CONSTRAINT [FK_APC_CEV_Composicao_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
);

