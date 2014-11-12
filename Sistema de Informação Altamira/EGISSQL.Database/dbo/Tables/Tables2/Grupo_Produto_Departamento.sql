CREATE TABLE [dbo].[Grupo_Produto_Departamento] (
    [cd_grupo_produto]      INT      NOT NULL,
    [cd_departamento]       INT      NOT NULL,
    [ic_orcamento]          CHAR (1) NOT NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [ic_email_orcamentista] CHAR (1) NULL,
    CONSTRAINT [PK_GrupoProduto_Departamento] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_departamento] ASC) WITH (FILLFACTOR = 90)
);

