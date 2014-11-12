CREATE TABLE [dbo].[Categoria_Contrato_Mes] (
    [cd_categoria_contrato] INT      NOT NULL,
    [cd_mes]                INT      NOT NULL,
    [ic_contrato_mes]       CHAR (1) NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Categoria_Contrato_Mes] PRIMARY KEY CLUSTERED ([cd_categoria_contrato] ASC, [cd_mes] ASC) WITH (FILLFACTOR = 90)
);

