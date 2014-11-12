CREATE TABLE [dbo].[Centro_Custo_Composicao] (
    [cd_centro_custo]      INT          NOT NULL,
    [cd_item_centro_custo] INT          NOT NULL,
    [cd_departamento]      INT          NULL,
    [pc_centro_custo]      FLOAT (53)   NULL,
    [cd_plano_financeiro]  INT          NULL,
    [cd_tipo_conta_pagar]  INT          NULL,
    [cd_lancamento_padrao] INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [nm_item_centro_custo] VARCHAR (40) NULL,
    CONSTRAINT [PK_Centro_Custo_Composicao] PRIMARY KEY CLUSTERED ([cd_centro_custo] ASC, [cd_item_centro_custo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Centro_Custo_Composicao_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

