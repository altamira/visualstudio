CREATE TABLE [dbo].[Tipo_Produto_Espessura] (
    [cd_tipo_produto_espessura] INT          NOT NULL,
    [nm_tipo_produto_espessura] VARCHAR (30) NULL,
    [sg_tipo_produto_espessura] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_tipo_placa]             INT          NULL,
    CONSTRAINT [PK_Tipo_Produto_Espessura] PRIMARY KEY CLUSTERED ([cd_tipo_produto_espessura] ASC) WITH (FILLFACTOR = 90)
);

