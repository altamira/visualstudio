CREATE TABLE [dbo].[Talao_Cheque] (
    [cd_talao_cheque]        INT          NOT NULL,
    [cd_conta_banco]         INT          NOT NULL,
    [qt_folha_inicial_talao] INT          NULL,
    [qt_folha_final_talao]   INT          NULL,
    [qt_folha_talao]         INT          NULL,
    [ds_talao]               TEXT         NULL,
    [nm_obs_talao]           VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Talao_Cheque] PRIMARY KEY CLUSTERED ([cd_talao_cheque] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Talao_Cheque_Conta_Agencia_Banco] FOREIGN KEY ([cd_conta_banco]) REFERENCES [dbo].[Conta_Agencia_Banco] ([cd_conta_banco])
);

