CREATE TABLE [dbo].[Fornecedor_Assunto] (
    [cd_fornecedor_assunto] INT          NOT NULL,
    [nm_fornecedor_assunto] VARCHAR (30) NOT NULL,
    [sg_fornecedor_assunto] CHAR (10)    NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL
);

