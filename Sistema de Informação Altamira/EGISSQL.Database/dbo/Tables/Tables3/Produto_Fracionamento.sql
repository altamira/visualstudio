CREATE TABLE [dbo].[Produto_Fracionamento] (
    [cd_produto_fracionamento] INT        NOT NULL,
    [cd_produto]               INT        NULL,
    [cd_tipo_embalagem]        INT        NULL,
    [cd_produto_fracionado]    INT        NOT NULL,
    [cd_unidade_medida]        INT        NULL,
    [qt_produto_fracionado]    FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_peso_conversao]        FLOAT (53) NULL,
    [ic_ativo_fracionado]      CHAR (1)   NULL,
    [ic_sobra_produto]         CHAR (1)   NULL,
    CONSTRAINT [PK_Produto_Fracionamento] PRIMARY KEY CLUSTERED ([cd_produto_fracionamento] ASC, [cd_produto_fracionado] ASC) WITH (FILLFACTOR = 90)
);

