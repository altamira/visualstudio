CREATE TABLE [dbo].[Parametro_Giro_Estoque] (
    [cd_empresa]                INT          NOT NULL,
    [cd_parametro_giro_estoque] INT          NOT NULL,
    [qt_ordem_giro_estoque]     INT          NULL,
    [qt_dia_inicial_estoque]    INT          NULL,
    [qt_dia_final_estoque]      INT          NULL,
    [nm_parametro_giro_estoque] VARCHAR (30) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Parametro_Giro_Estoque] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_parametro_giro_estoque] ASC) WITH (FILLFACTOR = 90)
);

