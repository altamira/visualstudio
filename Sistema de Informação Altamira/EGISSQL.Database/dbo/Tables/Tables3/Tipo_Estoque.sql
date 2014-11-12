CREATE TABLE [dbo].[Tipo_Estoque] (
    [cd_tipo_estoque] INT          NOT NULL,
    [nm_tipo_estoque] VARCHAR (30) NOT NULL,
    [sg_tipo_estoque] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Estoque] PRIMARY KEY CLUSTERED ([cd_tipo_estoque] ASC) WITH (FILLFACTOR = 90)
);

