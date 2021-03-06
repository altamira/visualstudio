﻿CREATE TABLE [dbo].[Maquina] (
    [cd_maquina]                INT          NOT NULL,
    [nm_maquina]                VARCHAR (40) NULL,
    [nm_fantasia_maquina]       VARCHAR (15) NULL,
    [ic_controle_fluxo]         CHAR (1)     NULL,
    [ic_prog_cnc]               CHAR (1)     NULL,
    [qt_par_gamarotacao]        FLOAT (53)   NULL,
    [ic_posicao_fixa_magazine]  CHAR (1)     NULL,
    [ic_par_refrigeracao]       CHAR (1)     NULL,
    [nm_diretorio_servidor_prg] VARCHAR (50) NULL,
    [cd_tipo_maquina]           INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_magazine_especial]      CHAR (1)     NULL,
    [nm_modelo]                 VARCHAR (20) NULL,
    [ic_processo_fabricacao]    CHAR (1)     NULL,
    [nm_fabricante]             VARCHAR (40) NULL,
    [aa_ano_fabricacao]         INT          NULL,
    [qt_potencia_maquina]       FLOAT (53)   NULL,
    [qt_total_horas]            FLOAT (53)   NULL,
    [ic_mapa_producao]          CHAR (1)     NULL,
    [qt_ordem_mapa]             INT          NULL,
    [qt_peso_maximo]            FLOAT (53)   NULL,
    [qt_largura_mesa]           FLOAT (53)   NULL,
    [qt_comprimento_mesa]       FLOAT (53)   NULL,
    [qt_espessura_mesa]         FLOAT (53)   NULL,
    [qt_largura_maxima_mesa]    FLOAT (53)   NULL,
    [qt_comprimento_maximo]     FLOAT (53)   NULL,
    [qt_horas_disp1]            FLOAT (53)   NULL,
    [qt_horas_disp2]            FLOAT (53)   NULL,
    [qt_horas_disp3]            FLOAT (53)   NULL,
    [qt_horas_disp4]            FLOAT (53)   NULL,
    [qt_horas_disp5]            FLOAT (53)   NULL,
    [qt_horas_disp6]            FLOAT (53)   NULL,
    [qt_horas_disp7]            FLOAT (53)   NULL,
    [cd_centro_custo]           INT          NULL,
    [cd_maquina_auxiliar]       INT          NULL,
    [ic_operacoes]              CHAR (1)     NULL,
    [ic_analise_mapa]           CHAR (1)     NULL,
    [ic_listagem_empresarial]   CHAR (1)     NULL,
    [nm_foto_maquina]           VARCHAR (50) NULL,
    [nm_icone_maquina]          VARCHAR (50) NULL,
    [cd_local_maquina]          INT          NULL,
    [ic_aplicacao]              CHAR (1)     NULL,
    [cd_comando]                INT          NULL,
    [qt_hora_real_maquina]      FLOAT (53)   NULL,
    [sg_maquina]                CHAR (15)    NULL,
    [cd_dnc_maquina]            INT          NULL,
    [cd_grupo_maquina]          INT          NULL,
    [cd_tipo_iso_maquina]       INT          NULL,
    [cd_barra_maquina]          VARCHAR (20) NULL,
    [ic_processo_maquina]       CHAR (1)     NULL,
    [cd_utilizacao_maquina]     INT          NULL,
    [ic_manutencao_maquina]     CHAR (1)     NULL,
    [cd_maquina_gps]            INT          NULL,
    [vl_custo_maquina]          FLOAT (53)   NULL,
    [qt_esp_placa]              FLOAT (53)   NULL,
    [vl_maquina]                FLOAT (53)   NULL,
    [qt_cap_produtiva_maquina]  FLOAT (53)   NULL,
    [qt_setup_maquina]          FLOAT (53)   NULL,
    [qt_agulhagem_maquina]      FLOAT (53)   NULL,
    [cd_status_maquina]         INT          NULL,
    CONSTRAINT [PK__Maquina__1F98B2C1] PRIMARY KEY CLUSTERED ([cd_maquina] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [XIF11Maquina]
    ON [dbo].[Maquina]([cd_usuario] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF27Maquina]
    ON [dbo].[Maquina]([cd_tipo_maquina] ASC) WITH (FILLFACTOR = 90);

