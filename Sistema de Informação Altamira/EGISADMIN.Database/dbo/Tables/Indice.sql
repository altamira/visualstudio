CREATE TABLE [dbo].[Indice] (
    [cd_tabela]           INT           NOT NULL,
    [cd_indice]           INT           NOT NULL,
    [nm_indice]           VARCHAR (40)  NULL,
    [ic_clustered]        CHAR (1)      NULL,
    [pc_fill_factor]      FLOAT (53)    NULL,
    [ic_unico]            CHAR (1)      NULL,
    [ic_temporario]       CHAR (1)      NULL,
    [nm_descricao]        VARCHAR (150) NULL,
    [cd_usuario_atualiza] INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    [ic_alteracao]        CHAR (1)      NULL,
    CONSTRAINT [PK_Indice] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_indice] ASC) WITH (FILLFACTOR = 90)
);

