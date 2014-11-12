CREATE TABLE [dbo].[mob_grupos_restricoes] (
    [grupoSelecionado]       NVARCHAR (50) NULL,
    [gruporestringir]        NVARCHAR (50) NULL,
    [Incluirgruporestringir] BIT           NULL,
    [existegruposelecionado] BIT           NULL,
    [idMobGrupoRestricoes]   INT           IDENTITY (1, 1) NOT NULL
);

