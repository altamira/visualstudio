CREATE TABLE [dbo].[Relatorio_Atributo] (
    [cd_relatorio]        INT       NOT NULL,
    [cd_tabela]           INT       NOT NULL,
    [cd_atributo]         INT       NOT NULL,
    [cd_usuario_atualiza] INT       NULL,
    [dt_atualiza]         CHAR (10) NULL,
    [cd_usuario]          INT       NULL,
    [dt_usuario]          DATETIME  NULL,
    CONSTRAINT [PK_Relatorio_Atributo] PRIMARY KEY CLUSTERED ([cd_relatorio] ASC, [cd_tabela] ASC, [cd_atributo] ASC) WITH (FILLFACTOR = 90)
);

