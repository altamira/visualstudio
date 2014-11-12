CREATE TABLE [dbo].[APC_Despesa_Composicao] (
    [cd_controle]        INT          NOT NULL,
    [cd_item_despesa]    INT          NOT NULL,
    [cd_conta]           INT          NULL,
    [cd_dimensao]        INT          NULL,
    [vl_saldo_anterior]  FLOAT (53)   NULL,
    [vl_debito]          FLOAT (53)   NULL,
    [vl_credito]         FLOAT (53)   NULL,
    [vl_saldo_atual]     FLOAT (53)   NULL,
    [vl_transacao]       FLOAT (53)   NULL,
    [nm_obs_despesa]     VARCHAR (60) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [ic_tipo_lancamento] CHAR (1)     NULL,
    [cd_centro_custo]    INT          NULL,
    CONSTRAINT [PK_APC_Despesa_Composicao] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_despesa] ASC),
    CONSTRAINT [FK_APC_Despesa_Composicao_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
);

