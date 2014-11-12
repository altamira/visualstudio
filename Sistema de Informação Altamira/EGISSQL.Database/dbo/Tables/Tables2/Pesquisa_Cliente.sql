CREATE TABLE [dbo].[Pesquisa_Cliente] (
    [cd_pesquisa_cliente]      INT      NOT NULL,
    [dt_pesquisa_cliente]      DATETIME NOT NULL,
    [cd_pesquisa]              INT      NOT NULL,
    [cd_cliente]               INT      NOT NULL,
    [cd_contato]               INT      NOT NULL,
    [cd_tipo_filtro_pesquisa]  INT      NOT NULL,
    [ic_pesquisa_cliente]      CHAR (1) NOT NULL,
    [ic_resposta_pesq_cliente] CHAR (1) NOT NULL,
    [cd_usuario]               INT      NOT NULL,
    [dt_usuario]               DATETIME NOT NULL
);

