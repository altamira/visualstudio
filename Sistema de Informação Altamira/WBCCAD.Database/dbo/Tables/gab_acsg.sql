﻿CREATE TABLE [dbo].[gab_acsg] (
    [acessorio]                   NVARCHAR (40) NULL,
    [flag_obrigatorio]            INT           NULL,
    [inmgab_codigo]               NVARCHAR (30) NULL,
    [grp_cor]                     NVARCHAR (20) NULL,
    [pad_qtde_minima]             FLOAT (53)    NULL,
    [pad_qtde_maxima]             FLOAT (53)    NULL,
    [pad_opcional]                INT           NULL,
    [pad_dependencia]             INT           NULL,
    [pad_qtde_default]            FLOAT (53)    NULL,
    [pad_altura_util]             INT           NULL,
    [pad_potencia]                INT           NULL,
    [pad_visivel]                 BIT           NULL,
    [pad_prioridade]              INT           NULL,
    [pad_esconder_orcamento]      BIT           NULL,
    [p_tensao]                    BIT           NULL,
    [p_frequencia]                BIT           NULL,
    [p_condensacao]               BIT           NULL,
    [p_par4]                      BIT           NULL,
    [p_par5]                      BIT           NULL,
    [desenho]                     NVARCHAR (50) NULL,
    [codigo]                      NVARCHAR (50) NULL,
    [potencia]                    FLOAT (53)    NULL,
    [qpn_valor_min]               INT           NULL,
    [qpn_valor_max]               INT           NULL,
    [qpn_valor_default]           INT           NULL,
    [t_chave]                     BIT           NULL,
    [t_cor]                       BIT           NULL,
    [SIGLACHB]                    NVARCHAR (50) NULL,
    [t_corte]                     BIT           NULL,
    [p_gas]                       BIT           NULL,
    [nao_mostrar_p_configurar]    BIT           NULL,
    [possui_dep_arraste]          BIT           NULL,
    [def_qtde_p_arraste_de_outro] BIT           NULL,
    [mensagem_ao_inserir]         NVARCHAR (50) NULL,
    [idGabAcsg]                   INT           IDENTITY (1, 1) NOT NULL
);

