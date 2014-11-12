CREATE TABLE [dbo].[APC_Delimitacao_Composicao] (
    [cd_controle]          INT          NOT NULL,
    [cd_ano]               INT          NOT NULL,
    [cd_mes]               INT          NOT NULL,
    [vl_venda]             FLOAT (53)   NULL,
    [vl_custo]             FLOAT (53)   NULL,
    [vl_margem_bruta]      FLOAT (53)   NULL,
    [vl_custo_futuro]      FLOAT (53)   NULL,
    [vl_wip]               FLOAT (53)   NULL,
    [nm_coordenador]       VARCHAR (40) NULL,
    [nm_obs_composicao]    VARCHAR (60) NULL,
    [nm_status_composicao] VARCHAR (20) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_APC_Delimitacao_Composicao] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_ano] ASC, [cd_mes] ASC),
    CONSTRAINT [FK_APC_Delimitacao_Composicao_Mes] FOREIGN KEY ([cd_mes]) REFERENCES [dbo].[Mes] ([cd_mes])
);

