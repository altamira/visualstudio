﻿CREATE TABLE [dbo].[Tipo_Campo_Arquivo_Magnetico] (
    [cd_tipo_campo]            INT          NOT NULL,
    [nm_tipo]                  VARCHAR (40) NULL,
    [sg_tipo_campo]            CHAR (15)    NULL,
    [ic_data_sistema]          CHAR (1)     NULL,
    [ic_data_inicial]          CHAR (1)     NULL,
    [ic_data_final]            CHAR (1)     NULL,
    [ic_contador_documento]    CHAR (1)     NULL,
    [ic_somatoria]             CHAR (1)     NULL,
    [ic_contador_detalhe]      CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_repetir_caracter]      CHAR (1)     NULL,
    [nm_formato_mascara]       VARCHAR (15) NULL,
    [ic_limpa_literal]         CHAR (1)     NULL,
    [ic_preenche_zero]         CHAR (1)     NULL,
    [ic_alinhamento]           CHAR (1)     NULL,
    [ic_mostra_virgula]        CHAR (1)     NULL,
    [ic_tipo_campo]            CHAR (1)     NULL,
    [ic_contador_sessao]       CHAR (1)     NULL,
    [ic_sequencia_grupo]       CHAR (1)     NULL,
    [ic_contador_regs_lote]    CHAR (1)     NULL,
    [ic_sequencia_arquivo_mag] CHAR (1)     NULL,
    [ic_sequencia_sessao]      CHAR (1)     NULL
);

