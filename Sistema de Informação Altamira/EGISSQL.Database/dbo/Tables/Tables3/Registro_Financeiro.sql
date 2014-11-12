CREATE TABLE [dbo].[Registro_Financeiro] (
    [cd_registro_financeiro]     INT          NOT NULL,
    [dt_registro_financeiro]     DATETIME     NULL,
    [dt_base_registro]           DATETIME     NULL,
    [aa_registro]                INT          NULL,
    [mm_registro]                INT          NULL,
    [cd_igreja]                  INT          NULL,
    [vl_entrada_registro]        FLOAT (53)   NULL,
    [vl_saida_registro]          FLOAT (53)   NULL,
    [vl_saldo_registro]          FLOAT (53)   NULL,
    [vl_transferencia_registro]  FLOAT (53)   NULL,
    [dt_transerencia_registro]   DATETIME     NULL,
    [nm_obs_registro_financeiro] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Registro_Financeiro] PRIMARY KEY CLUSTERED ([cd_registro_financeiro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Financeiro_Igreja] FOREIGN KEY ([cd_igreja]) REFERENCES [dbo].[Igreja] ([cd_igreja])
);

