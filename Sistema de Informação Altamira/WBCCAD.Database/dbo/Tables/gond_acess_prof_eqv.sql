CREATE TABLE [dbo].[gond_acess_prof_eqv] (
    [descricao]          NVARCHAR (50) NULL,
    [ang]                NVARCHAR (50) NULL,
    [tipo_frente]        NVARCHAR (30) NULL,
    [id_corte_frontal]   INT           NULL,
    [profundidade]       INT           NULL,
    [equivalencia]       INT           NULL,
    [idGondAcessProfEqv] INT           IDENTITY (1, 1) NOT NULL
);

