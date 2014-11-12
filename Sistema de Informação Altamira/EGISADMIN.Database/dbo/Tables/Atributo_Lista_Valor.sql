CREATE TABLE [dbo].[Atributo_Lista_Valor] (
    [cd_tabela]           INT          NOT NULL,
    [cd_atributo]         INT          NOT NULL,
    [cd_lista_valor]      VARCHAR (20) NOT NULL,
    [nm_lista_valor]      VARCHAR (20) NOT NULL,
    [cd_usuario_atualiza] INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ic_alteracao]        CHAR (1)     NULL,
    CONSTRAINT [PK_Atributo_Lista_Valor] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_atributo] ASC, [cd_lista_valor] ASC) WITH (FILLFACTOR = 90)
);

