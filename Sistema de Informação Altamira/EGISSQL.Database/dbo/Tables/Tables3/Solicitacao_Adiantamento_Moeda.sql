CREATE TABLE [dbo].[Solicitacao_Adiantamento_Moeda] (
    [cd_solicitacao]            INT          NOT NULL,
    [cd_item_solicitacao]       INT          NOT NULL,
    [cd_moeda]                  INT          NOT NULL,
    [vl_adiantamento_moeda]     FLOAT (53)   NULL,
    [nm_obs_adiantamento_moeda] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Solicitacao_Adiantamento_Moeda] PRIMARY KEY CLUSTERED ([cd_solicitacao] ASC, [cd_item_solicitacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Solicitacao_Adiantamento_Moeda_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

