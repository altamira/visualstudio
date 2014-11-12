CREATE TABLE [dbo].[Categoria_Hotel] (
    [cd_categoria_hotel] INT          NOT NULL,
    [nm_categoria_hotel] VARCHAR (30) NULL,
    [sg_categoria_hotel] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Categoria_Hotel] PRIMARY KEY CLUSTERED ([cd_categoria_hotel] ASC) WITH (FILLFACTOR = 90)
);

