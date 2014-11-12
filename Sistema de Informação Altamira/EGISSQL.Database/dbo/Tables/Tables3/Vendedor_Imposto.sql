CREATE TABLE [dbo].[Vendedor_Imposto] (
    [cd_vendedor]       INT        NOT NULL,
    [cd_imposto]        INT        NOT NULL,
    [dt_inicio_imposto] DATETIME   NULL,
    [dt_final_imposto]  DATETIME   NULL,
    [pc_imposto]        FLOAT (53) NULL,
    [vl_teto_imposto]   FLOAT (53) NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    CONSTRAINT [PK_Vendedor_Imposto] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_imposto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Imposto_Imposto] FOREIGN KEY ([cd_imposto]) REFERENCES [dbo].[Imposto] ([cd_imposto])
);

