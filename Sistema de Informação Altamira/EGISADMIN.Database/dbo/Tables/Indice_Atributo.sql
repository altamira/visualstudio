CREATE TABLE [dbo].[Indice_Atributo] (
    [cd_tabela]    INT      NOT NULL,
    [cd_indice]    INT      NOT NULL,
    [cd_atributo]  INT      NOT NULL,
    [cd_sequencia] INT      NOT NULL,
    [cd_usuario]   INT      NULL,
    [dt_usuario]   DATETIME NULL,
    [ic_alteracao] CHAR (1) NULL,
    CONSTRAINT [PK_Indice_Atributo] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_indice] ASC, [cd_atributo] ASC) WITH (FILLFACTOR = 90)
);

