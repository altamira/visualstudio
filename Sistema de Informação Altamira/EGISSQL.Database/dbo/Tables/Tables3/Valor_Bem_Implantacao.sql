CREATE TABLE [dbo].[Valor_Bem_Implantacao] (
    [cd_bem]                   INT          NOT NULL,
    [dt_implantacao_valor_bem] DATETIME     NULL,
    [vl_residual_bem]          FLOAT (53)   NULL,
    [vl_original_bem]          FLOAT (53)   NULL,
    [vl_depreciacao_bem]       FLOAT (53)   NULL,
    [vl_dep_acumulada_bem]     FLOAT (53)   NULL,
    [nm_obs_bem_implantacao]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [vl_baixa_bem]             FLOAT (53)   NULL,
    CONSTRAINT [PK_Valor_Bem_Implantacao] PRIMARY KEY CLUSTERED ([cd_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Valor_Bem_Implantacao_Bem] FOREIGN KEY ([cd_bem]) REFERENCES [dbo].[Bem] ([cd_bem])
);

