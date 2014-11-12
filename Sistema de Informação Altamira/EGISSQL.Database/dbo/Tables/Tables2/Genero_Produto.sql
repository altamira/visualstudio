CREATE TABLE [dbo].[Genero_Produto] (
    [cd_genero_produto] INT          NOT NULL,
    [nm_genero_produto] VARCHAR (40) NULL,
    [sg_genero_produto] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_tipo_objeto]    INT          NULL,
    CONSTRAINT [PK_Genero_Produto] PRIMARY KEY CLUSTERED ([cd_genero_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Genero_Produto_Tipo_Objeto] FOREIGN KEY ([cd_tipo_objeto]) REFERENCES [dbo].[Tipo_objeto] ([cd_tipo_objeto])
);

