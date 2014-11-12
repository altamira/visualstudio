CREATE TABLE [dbo].[Custo_Servico_Terceiro] (
    [dt_base_custo_servico] DATETIME NOT NULL,
    [cd_servico_terceiro]   INT      NOT NULL,
    [vl_custo_servico]      MONEY    NOT NULL,
    [cd_usuario]            INT      NOT NULL,
    [dt_usuario]            DATETIME NOT NULL,
    CONSTRAINT [PK_Custo_Servico_Terceiro] PRIMARY KEY CLUSTERED ([dt_base_custo_servico] ASC, [cd_servico_terceiro] ASC) WITH (FILLFACTOR = 90)
);

