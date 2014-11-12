CREATE TABLE [dbo].[Bucha_Injecao_Qualidade] (
    [cd_tipo_bucha_injecao] INT      NOT NULL,
    [cd_material_plastico]  INT      NOT NULL,
    [cd_qualidade_injecao]  INT      NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Bucha_Injecao_Qualidade] PRIMARY KEY NONCLUSTERED ([cd_tipo_bucha_injecao] ASC, [cd_material_plastico] ASC, [cd_qualidade_injecao] ASC) WITH (FILLFACTOR = 90)
);

