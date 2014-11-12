CREATE TABLE [dbo].[Conta_Carteira_Cobranca] (
    [cd_conta_banco]           INT      NOT NULL,
    [cd_carteira_cobranca]     INT      NOT NULL,
    [nm_obs_carteira_cobranca] TEXT     NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Conta_Carteira_Cobranca] PRIMARY KEY CLUSTERED ([cd_conta_banco] ASC, [cd_carteira_cobranca] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Conta_Carteira_Cobranca_Carteira_Cobranca] FOREIGN KEY ([cd_carteira_cobranca]) REFERENCES [dbo].[Carteira_Cobranca] ([cd_carteira_cobranca])
);

