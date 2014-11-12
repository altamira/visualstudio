CREATE TABLE [dbo].[Indicador_Contabilidade_Resultado] (
    [cd_indicador]           INT          NOT NULL,
    [dt_inicial_resultado]   DATETIME     NOT NULL,
    [dt_final_resultado]     DATETIME     NOT NULL,
    [vl_resultado_indicador] FLOAT (53)   NULL,
    [nm_obs_resultado]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Indicador_Contabilidade_Resultado] PRIMARY KEY CLUSTERED ([cd_indicador] ASC, [dt_inicial_resultado] ASC, [dt_final_resultado] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Indicador_Contabilidade_Resultado_Indicador_Contabilidade] FOREIGN KEY ([cd_indicador]) REFERENCES [dbo].[Indicador_Contabilidade] ([cd_indicador])
);

