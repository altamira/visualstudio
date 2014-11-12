CREATE TABLE [dbo].[Vendedor_Valor_Comissao] (
    [cd_vendedor]      INT          NOT NULL,
    [dt_inicio]        DATETIME     NOT NULL,
    [dt_final]         DATETIME     NOT NULL,
    [vl_piso_vendedor] FLOAT (53)   NULL,
    [vl_teto_vendedor] FLOAT (53)   NULL,
    [nm_obs_vendedor]  VARCHAR (40) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Vendedor_Valor_Comissao] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [dt_inicio] ASC, [dt_final] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Vendedor_Valor_Comissao_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

