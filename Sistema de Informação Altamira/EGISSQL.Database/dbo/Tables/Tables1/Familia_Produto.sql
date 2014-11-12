CREATE TABLE [dbo].[Familia_Produto] (
    [cd_familia_produto] INT          NOT NULL,
    [nm_familia_produto] VARCHAR (50) NULL,
    [sg_familia_produto] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Familia_Produto] PRIMARY KEY CLUSTERED ([cd_familia_produto] ASC)
);

