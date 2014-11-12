CREATE TABLE [dbo].[Vendedor_Adiantamento] (
    [cd_adiantamento]       INT          NOT NULL,
    [dt_adiantamento]       DATETIME     NULL,
    [vl_adiantamento]       FLOAT (53)   NULL,
    [vl_saldo_adintamento]  FLOAT (53)   NULL,
    [cd_vendedor]           INT          NOT NULL,
    [dt_baixa_adiantamento] DATETIME     NULL,
    [nm_obs_adiantamento]   VARCHAR (40) NULL,
    [ic_deposito]           CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Vendedor_Adiantamento] PRIMARY KEY CLUSTERED ([cd_adiantamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Adiantamento_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

