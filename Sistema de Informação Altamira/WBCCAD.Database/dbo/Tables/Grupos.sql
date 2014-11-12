CREATE TABLE [dbo].[Grupos] (
    [idGrupo]     INT            IDENTITY (1, 1) NOT NULL,
    [idNivel]     INT            NOT NULL,
    [Grupo]       NVARCHAR (100) NOT NULL,
    [Observacoes] NVARCHAR (MAX) NULL,
    [Ativo]       BIT            NULL
);

