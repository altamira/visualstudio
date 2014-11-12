CREATE TABLE [dbo].[Cheque_Pagar] (
    [cd_cheque_pagar]           INT          NOT NULL,
    [cd_banco]                  INT          NOT NULL,
    [cd_agencia_banco]          INT          NOT NULL,
    [cd_conta_banco]            INT          NOT NULL,
    [dt_emissao_cheque_pagar]   DATETIME     NULL,
    [vl_cheque_pagar]           FLOAT (53)   NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_baixado_cheque_pagar]   CHAR (1)     NULL,
    [cd_lancamento]             INT          NULL,
    [nm_favorecido]             VARCHAR (50) NULL,
    [dt_liquidacao_cheque]      DATETIME     NULL,
    [dt_impressao_cheque_pagar] DATETIME     NULL,
    [cd_ap]                     INT          NULL,
    CONSTRAINT [PK_Cheque_Pagar] PRIMARY KEY CLUSTERED ([cd_cheque_pagar] ASC, [cd_banco] ASC, [cd_agencia_banco] ASC, [cd_conta_banco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cheque_Pagar_Banco] FOREIGN KEY ([cd_banco]) REFERENCES [dbo].[Banco] ([cd_banco])
);

