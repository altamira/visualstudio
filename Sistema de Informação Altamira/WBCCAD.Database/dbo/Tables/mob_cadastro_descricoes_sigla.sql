CREATE TABLE [dbo].[mob_cadastro_descricoes_sigla] (
    [descricao]                    NVARCHAR (50) NULL,
    [sigla]                        NVARCHAR (10) NULL,
    [par_p_compr]                  FLOAT (53)    NULL,
    [par_p_prof]                   FLOAT (53)    NULL,
    [par_p_alt]                    FLOAT (53)    NULL,
    [idMobCadastroDescricoesSigla] INT           IDENTITY (1, 1) NOT NULL
);

