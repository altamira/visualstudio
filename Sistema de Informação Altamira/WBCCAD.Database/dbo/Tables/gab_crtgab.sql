﻿CREATE TABLE [dbo].[gab_crtgab] (
    [codigo]                   NVARCHAR (20) NULL,
    [linha]                    NVARCHAR (30) NULL,
    [tipo]                     NVARCHAR (30) NULL,
    [profundidade]             INT           NULL,
    [kcal]                     INT           NULL,
    [potencia]                 INT           NULL,
    [resfriamento]             NVARCHAR (20) NULL,
    [grp_cor]                  NVARCHAR (30) NULL,
    [inclinacao]               NVARCHAR (40) NULL,
    [inclusao_usuario]         NVARCHAR (30) NULL,
    [inclusao_data]            INT           NULL,
    [inclusao_horario]         INT           NULL,
    [alteracao_usuario]        NVARCHAR (30) NULL,
    [alteracao_data]           INT           NULL,
    [alteracao_horario]        INT           NULL,
    [prefixo_desenho]          NVARCHAR (20) NULL,
    [altura_util]              INT           NULL,
    [situacao]                 NVARCHAR (20) NULL,
    [esconder_orcamento]       BIT           NULL,
    [p_tensao]                 BIT           NULL,
    [p_frequencia]             BIT           NULL,
    [p_condensacao]            BIT           NULL,
    [p_par4]                   BIT           NOT NULL,
    [p_par5]                   BIT           NOT NULL,
    [altura]                   INT           NULL,
    [alt_min_incl]             INT           NULL,
    [mult_modulacao]           INT           NULL,
    [alt_max_incl]             INT           NULL,
    [vlr_estr_int]             INT           NULL,
    [grupo_degelo]             NVARCHAR (50) NULL,
    [numero_modulos_eqv_mec]   INT           NULL,
    [numero_modulos_eqv_eletr] INT           NULL,
    [temperatura_trabalho]     FLOAT (53)    NULL,
    [temperatura_trabalho2]    FLOAT (53)    NULL,
    [dia_liquidos]             NVARCHAR (10) NULL,
    [dia_succao]               NVARCHAR (10) NULL,
    [possui_espelho]           BIT           NULL,
    [prefixo_sgrupo]           NVARCHAR (5)  NULL,
    [travar_representante]     BIT           NULL,
    [t_chave]                  BIT           NULL,
    [t_cor]                    BIT           NULL,
    [fechamento_duplo]         BIT           NULL,
    [gab_int_temperatura]      NVARCHAR (20) NULL,
    [quant_fc]                 INT           NULL,
    [idGabCrtgab]              INT           IDENTITY (1, 1) NOT NULL
);

