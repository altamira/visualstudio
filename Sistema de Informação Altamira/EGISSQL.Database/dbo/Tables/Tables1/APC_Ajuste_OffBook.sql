CREATE TABLE [dbo].[APC_Ajuste_OffBook] (
    [cd_controle]        INT          NOT NULL,
    [cd_item_ajuste]     INT          NOT NULL,
    [cd_conta]           INT          NULL,
    [cd_dimensao]        INT          NULL,
    [vl_saldo_anterior]  FLOAT (53)   NULL,
    [vl_debito]          FLOAT (53)   NULL,
    [vl_credito]         FLOAT (53)   NULL,
    [vl_saldo_atual]     FLOAT (53)   NULL,
    [vl_transacao]       FLOAT (53)   NULL,
    [nm_obs_ajuste]      VARCHAR (60) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [ic_tipo_lancamento] CHAR (1)     NULL,
    [cd_centro_custo]    INT          NULL,
    [vl_ajuste]          FLOAT (53)   NULL,
    [cd_tipo_ajuste]     INT          NULL,
    CONSTRAINT [PK_APC_Ajuste_OffBook] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_ajuste] ASC)
);

