CREATE TABLE [dbo].[Custo_Mao_Obra_Historico] (
    [cd_mao_obra]       INT        NOT NULL,
    [dt_custo_mao_obra] DATETIME   NOT NULL,
    [vl_custo_mao_obra] FLOAT (53) NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    CONSTRAINT [PK_Custo_Mao_Obra_Historico] PRIMARY KEY CLUSTERED ([cd_mao_obra] ASC, [dt_custo_mao_obra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Custo_Mao_Obra_Historico_Mao_Obra] FOREIGN KEY ([cd_mao_obra]) REFERENCES [dbo].[Mao_Obra] ([cd_mao_obra])
);

