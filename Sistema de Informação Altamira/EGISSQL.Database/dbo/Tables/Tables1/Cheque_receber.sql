CREATE TABLE [dbo].[Cheque_receber] (
    [cd_cheque_receber]         INT          NOT NULL,
    [nm_cheque_receber]         VARCHAR (25) NULL,
    [dt_cheque_receber]         DATETIME     NULL,
    [dt_deposito_cheque_recebe] DATETIME     NULL,
    [vl_cheque_receber]         FLOAT (53)   NULL,
    [nm_obs_cheque_receber]     VARCHAR (40) NULL,
    [cd_banco]                  INT          NULL,
    [cd_cliente]                INT          NULL,
    [dt_baixa_cheque_receber]   DATETIME     NULL,
    [dt_devolucao_cheque_receb] DATETIME     NULL,
    [nm_motdev_cheque_receber]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_agencia_cheque_receber] VARCHAR (20) NULL,
    [dt_repasse_cheque]         DATETIME     NULL,
    [nm_conta_cheque]           VARCHAR (30) NULL,
    [nm_razao_social_cheque]    VARCHAR (60) NULL,
    [cd_fone_cheque]            VARCHAR (15) NULL,
    CONSTRAINT [PK_Cheque_receber] PRIMARY KEY CLUSTERED ([cd_cheque_receber] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cheque_receber_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco])
);

