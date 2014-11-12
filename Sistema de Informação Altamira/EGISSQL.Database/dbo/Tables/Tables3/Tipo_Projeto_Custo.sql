CREATE TABLE [dbo].[Tipo_Projeto_Custo] (
    [cd_tipo_projeto]           INT        NOT NULL,
    [vl_base_custo_projeto]     FLOAT (53) NULL,
    [dt_base_custo_projeto]     DATETIME   NULL,
    [vl_simulado_custo_projeto] FLOAT (53) NULL,
    [dt_simulado_custo_projeto] DATETIME   NULL,
    [vl_temp_custo_projeto]     FLOAT (53) NULL,
    [dt_temp_custo_projeto]     DATETIME   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Tipo_Projeto_Custo] PRIMARY KEY CLUSTERED ([cd_tipo_projeto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Projeto_Custo_Tipo_Projeto] FOREIGN KEY ([cd_tipo_projeto]) REFERENCES [dbo].[Tipo_Projeto] ([cd_tipo_projeto])
);

