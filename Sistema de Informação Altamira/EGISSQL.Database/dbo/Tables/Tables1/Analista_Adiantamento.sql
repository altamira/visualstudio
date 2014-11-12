CREATE TABLE [dbo].[Analista_Adiantamento] (
    [cd_adiantamento]       INT          NOT NULL,
    [dt_adiantamento]       DATETIME     NULL,
    [cd_analista]           INT          NOT NULL,
    [cd_centro_custo]       INT          NULL,
    [cd_cliente]            INT          NULL,
    [vl_adiantamento]       FLOAT (53)   NULL,
    [vl_saldo_adiantamento] FLOAT (53)   NULL,
    [dt_baixa_adiantamento] DATETIME     NULL,
    [nm_obs_adiantamento]   VARCHAR (40) NULL,
    [ic_deposito]           CHAR (1)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Analista_Adiantamento] PRIMARY KEY CLUSTERED ([cd_adiantamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Analista_Adiantamento_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

