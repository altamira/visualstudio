CREATE TABLE [dbo].[APC_Faturamento_Composicao] (
    [cd_controle]         INT          NOT NULL,
    [cd_item_faturamento] INT          NOT NULL,
    [cd_conta]            INT          NULL,
    [cd_dimensao]         INT          NULL,
    [vl_saldo_anterior]   FLOAT (53)   NULL,
    [vl_debito]           FLOAT (53)   NULL,
    [vl_credito]          FLOAT (53)   NULL,
    [vl_saldo_atual]      FLOAT (53)   NULL,
    [vl_transacao]        FLOAT (53)   NULL,
    [nm_obs_faturamento]  VARCHAR (60) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ic_tipo_lancamento]  CHAR (1)     NULL,
    CONSTRAINT [PK_APC_Faturamento_Composicao] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_faturamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_APC_Faturamento_Composicao_Dimensao] FOREIGN KEY ([cd_dimensao]) REFERENCES [dbo].[Dimensao] ([cd_dimensao])
);

