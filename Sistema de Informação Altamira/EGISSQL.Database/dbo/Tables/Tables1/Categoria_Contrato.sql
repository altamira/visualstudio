CREATE TABLE [dbo].[Categoria_Contrato] (
    [cd_categoria_contrato] INT          NOT NULL,
    [sg_categoria_contrato] CHAR (10)    NULL,
    [nm_categoria_contrato] VARCHAR (30) NULL,
    [ds_categoria_contrato] TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Categoria_Contrato] PRIMARY KEY CLUSTERED ([cd_categoria_contrato] ASC) WITH (FILLFACTOR = 90)
);

