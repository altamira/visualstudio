CREATE TABLE [dbo].[Valor_Bem_Fechamento] (
    [cd_bem_fechamento]          INT          NOT NULL,
    [cd_bem]                     INT          NOT NULL,
    [dt_bem_fechamento]          DATETIME     NOT NULL,
    [vl_original_bem]            FLOAT (53)   NULL,
    [vl_residual_bem]            FLOAT (53)   NULL,
    [vl_depreciacao_bem]         FLOAT (53)   NULL,
    [vl_dep_acumulada_bem]       FLOAT (53)   NULL,
    [nm_obs_bem_fechamento]      VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [vl_baixa_bem]               FLOAT (53)   NULL,
    [cd_bem_fechamento_auxiliar] INT          NULL,
    CONSTRAINT [PK_Valor_Bem_Fechamento] PRIMARY KEY CLUSTERED ([cd_bem_fechamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Valor_Bem_Fechamento_Bem] FOREIGN KEY ([cd_bem]) REFERENCES [dbo].[Bem] ([cd_bem])
);

