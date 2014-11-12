CREATE TABLE [dbo].[Estrutura_Venda] (
    [cd_grupo_estrutura_venda]  INT          NOT NULL,
    [cd_estrutura_venda]        INT          NOT NULL,
    [nm_estrutura_venda]        VARCHAR (40) NULL,
    [sg_estrutura_venda]        CHAR (10)    NULL,
    [cd_mascara_estrutura_vend] VARCHAR (20) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_recebe_comissao_estrut] CHAR (1)     NULL,
    [ic_recebe_comissao]        CHAR (1)     NULL,
    [ic_repassa_comissao]       CHAR (1)     NULL,
    CONSTRAINT [PK_Estrutura_Venda] PRIMARY KEY CLUSTERED ([cd_estrutura_venda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Estrutura_Venda_Grupo_Estrutura_Venda] FOREIGN KEY ([cd_grupo_estrutura_venda]) REFERENCES [dbo].[Grupo_Estrutura_Venda] ([cd_grupo_estrutura_venda])
);

