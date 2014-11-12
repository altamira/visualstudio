CREATE TABLE [dbo].[Orcst] (
    [st_codigo]     INT           NULL,
    [st_descricao]  NVARCHAR (30) NULL,
    [st_flag_ativo] BIT           CONSTRAINT [DF_Orcst_st_flag_ativo] DEFAULT ((0)) NULL,
    [idOrcst]       INT           IDENTITY (1, 1) NOT NULL,
    CONSTRAINT [PK_Orcst] PRIMARY KEY CLUSTERED ([idOrcst] ASC)
);


GO
GRANT SELECT
    ON OBJECT::[dbo].[Orcst] TO [altanet]
    AS [dbo];

