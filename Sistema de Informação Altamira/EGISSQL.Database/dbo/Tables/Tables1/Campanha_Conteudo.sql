CREATE TABLE [dbo].[Campanha_Conteudo] (
    [cd_campanha]               INT           NOT NULL,
    [cd_campanha_conteudo]      INT           NOT NULL,
    [nm_arquivo_texto_campanha] VARCHAR (100) NOT NULL,
    [nm_arquivo_imegem_campanh] VARCHAR (100) NOT NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_usuario]                INT           NULL,
    [nm_arquivo_imagem_campanh] VARCHAR (100) NULL
);

