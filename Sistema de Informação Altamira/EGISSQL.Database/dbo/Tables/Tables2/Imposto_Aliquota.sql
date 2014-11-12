CREATE TABLE [dbo].[Imposto_Aliquota] (
    [cd_imposto]              INT          NOT NULL,
    [dt_imposto_aliquota]     DATETIME     NOT NULL,
    [pc_imposto]              FLOAT (53)   NULL,
    [ic_validade_imposto]     CHAR (1)     NULL,
    [nm_obs_imposto_aliquota] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [vl_teto_imposto]         FLOAT (53)   NULL,
    [cd_darf_codigo]          INT          NULL,
    [ic_vencimento_imposto]   CHAR (1)     NULL,
    CONSTRAINT [PK_Imposto_Aliquota] PRIMARY KEY CLUSTERED ([cd_imposto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Imposto_Aliquota_Darf_Codigo] FOREIGN KEY ([cd_darf_codigo]) REFERENCES [dbo].[Darf_Codigo] ([cd_darf_codigo])
);

