CREATE TABLE [dbo].[Categoria_Ferramenta] (
    [cd_categoria_ferramenta] INT          NOT NULL,
    [nm_categoria_ferramenta] VARCHAR (50) NOT NULL,
    [sg_categoria_ferramenta] VARCHAR (10) NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NULL
);

