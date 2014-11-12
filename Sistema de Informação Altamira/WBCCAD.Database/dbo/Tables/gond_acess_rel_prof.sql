﻿CREATE TABLE [dbo].[gond_acess_rel_prof] (
    [descricao]          NVARCHAR (50) NULL,
    [ang]                NVARCHAR (50) NULL,
    [tipo_frente]        NVARCHAR (30) NULL,
    [id_corte_frontal]   INT           NULL,
    [conceito]           NVARCHAR (50) NULL,
    [ch_busca]           NVARCHAR (20) NULL,
    [valor]              INT           NULL,
    [desenho_2d]         NVARCHAR (18) NULL,
    [prefixo_2d]         NVARCHAR (12) NULL,
    [med_alt_2d]         INT           NULL,
    [med_larg_2d]        INT           NULL,
    [var_larg_2d]        NVARCHAR (20) NULL,
    [var_alt_2d]         NVARCHAR (20) NULL,
    [afs_fundo_2d]       INT           NULL,
    [afs_inicio_2d]      INT           NULL,
    [desenho_3d]         NVARCHAR (5)  NULL,
    [prefixo_3d]         NVARCHAR (12) NULL,
    [med_alt_3d]         INT           NULL,
    [med_larg_3d]        INT           NULL,
    [med_compr_3d]       INT           NULL,
    [afs_fundo_3d]       INT           NULL,
    [afs_inicio_3d]      INT           NULL,
    [ativo]              BIT           NULL,
    [Var_alt_3d]         NVARCHAR (20) NULL,
    [Var_larg_3d]        NVARCHAR (20) NULL,
    [Var_compr_3d]       NVARCHAR (20) NULL,
    [idGondAcessRelProf] INT           IDENTITY (1, 1) NOT NULL
);

