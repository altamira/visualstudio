CREATE TABLE [dbo].[Categoria_Trabalhador] (
    [cd_categoria_trabalhador] INT          NOT NULL,
    [nm_categoria_trabalhador] VARCHAR (60) NULL,
    [ds_categoria_trabalhador] TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_sefip_categoria]       CHAR (4)     NULL,
    CONSTRAINT [PK_Categoria_Trabalhador] PRIMARY KEY CLUSTERED ([cd_categoria_trabalhador] ASC) WITH (FILLFACTOR = 90)
);

