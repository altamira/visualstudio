CREATE TABLE [dbo].[Prestacao_Conta_Moeda] (
    [cd_prestacao_moeda]         INT          NOT NULL,
    [cd_prestacao]               INT          NOT NULL,
    [cd_moeda]                   INT          NOT NULL,
    [dt_prestacao_moeda]         DATETIME     NULL,
    [vl_prestacao_moeda]         FLOAT (53)   NULL,
    [vl_cotacao_prestacao_moeda] FLOAT (53)   NULL,
    [nm_obs_prestacao_moeda]     VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [ic_tipo_lancamento]         CHAR (1)     NULL,
    [vl_total_prestacao_moeda]   FLOAT (53)   NULL,
    [vl_moeda_convertida]        FLOAT (53)   NULL,
    [cd_solicitacao]             INT          NULL,
    [cd_controle]                INT          NULL,
    CONSTRAINT [PK_Prestacao_Conta_Moeda] PRIMARY KEY CLUSTERED ([cd_prestacao_moeda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Prestacao_Conta_Moeda_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

