CREATE TABLE [dbo].[Marca_Produto] (
    [cd_marca_produto] INT          NOT NULL,
    [nm_marca_produto] VARCHAR (40) NULL,
    [sg_marca_produto] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Marca_Produto] PRIMARY KEY CLUSTERED ([cd_marca_produto] ASC) WITH (FILLFACTOR = 90)
);

