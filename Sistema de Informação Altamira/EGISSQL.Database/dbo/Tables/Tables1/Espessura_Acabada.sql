CREATE TABLE [dbo].[Espessura_Acabada] (
    [cd_espessura]              INT          NOT NULL,
    [cd_tipo_produto_espessura] INT          NOT NULL,
    [cd_largura_comprimento]    INT          NULL,
    [cd_tipo_calculo]           INT          NOT NULL,
    [qt_espessura_acabada]      FLOAT (53)   NULL,
    [qt_sobremetal_esp_acabada] FLOAT (53)   NULL,
    [nm_obs_espessura_acabada]  VARCHAR (30) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_espessura_sem_tol]      INT          NULL,
    [qt_sobremetal_sem_tol]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Espessura_Acabada] PRIMARY KEY CLUSTERED ([cd_espessura] ASC, [cd_tipo_produto_espessura] ASC, [cd_tipo_calculo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Espessura_Acabada_Espessura] FOREIGN KEY ([cd_espessura_sem_tol]) REFERENCES [dbo].[Espessura] ([cd_espessura]),
    CONSTRAINT [FK_Espessura_Acabada_Tipo_Calculo_Orcamento] FOREIGN KEY ([cd_tipo_calculo]) REFERENCES [dbo].[Tipo_Calculo_Orcamento] ([cd_tipo_calculo_orcamento])
);

