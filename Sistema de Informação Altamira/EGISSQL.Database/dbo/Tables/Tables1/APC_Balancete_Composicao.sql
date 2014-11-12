CREATE TABLE [dbo].[APC_Balancete_Composicao] (
    [cd_controle]         INT          NOT NULL,
    [cd_item_balancete]   INT          NOT NULL,
    [cd_conta]            INT          NULL,
    [vl_saldo_abertura]   FLOAT (53)   NULL,
    [vl_periodo_anterior] FLOAT (53)   NULL,
    [vl_periodo_atual]    FLOAT (53)   NULL,
    [vl_saldo_final]      FLOAT (53)   NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [nm_obs_balancete]    VARCHAR (60) NULL,
    CONSTRAINT [PK_APC_Balancete_Composicao] PRIMARY KEY CLUSTERED ([cd_controle] ASC, [cd_item_balancete] ASC)
);

