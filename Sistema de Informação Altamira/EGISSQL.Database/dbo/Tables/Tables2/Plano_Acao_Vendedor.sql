CREATE TABLE [dbo].[Plano_Acao_Vendedor] (
    [cd_vendedor]             INT        NOT NULL,
    [cd_plano_acao_vendedor]  INT        NOT NULL,
    [dt_plano_acao_vendedor]  DATETIME   NULL,
    [pc_1ano_partic_vendedor] FLOAT (53) NULL,
    [pc_2ano_partic_vendedor] FLOAT (53) NULL,
    [pc_3ano_partic_vendedor] FLOAT (53) NULL,
    [vl_1ano_partic_vendedor] FLOAT (53) NULL,
    [vl_2ano_partic_vendedor] FLOAT (53) NULL,
    [vl_3ano_partic_vendedor] FLOAT (53) NULL,
    [ds_plano_acao_vendedor]  TEXT       NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    [cd_cliente]              INT        NULL,
    [vl_ano_plano_acao_vend]  FLOAT (53) NULL,
    [cd_criterio_visita]      INT        NULL,
    [ic_ativo_plano_acao]     CHAR (1)   NULL,
    CONSTRAINT [PK_Plano_Acao_Vendedor] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_plano_acao_vendedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Plano_Acao_Vendedor_Criterio_Visita] FOREIGN KEY ([cd_criterio_visita]) REFERENCES [dbo].[Criterio_Visita] ([cd_criterio_visita])
);

