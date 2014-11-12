﻿CREATE TABLE [dbo].[cam_prt] (
    [prt_descricao]       NVARCHAR (40)  NULL,
    [prt_codigo_esquerdo] NVARCHAR (20)  NULL,
    [prt_codigo_direito]  NVARCHAR (20)  NULL,
    [prt_desenho]         NVARCHAR (255) NULL,
    [prt_comprimento_pad] INT            NULL,
    [prt_comprimento_min] INT            NULL,
    [prt_comprimento_max] INT            NULL,
    [prt_altura_pad]      INT            NULL,
    [prt_altura_min]      INT            NULL,
    [prt_altura_max]      INT            NULL,
    [mult_modulo]         FLOAT (53)     NULL,
    [prt_fabricante]      NVARCHAR (50)  NULL,
    [TEXTO_PLANTA]        NVARCHAR (50)  NULL,
    [ALTURA_SOLO]         INT            NULL,
    [SUFIXO_DESENHO]      NVARCHAR (20)  NULL,
    [potencia_degelo]     FLOAT (53)     NULL,
    [kcal_porta]          FLOAT (53)     NULL,
    [TIPO_CAD]            NVARCHAR (10)  NULL,
    [compl_desenho]       NVARCHAR (10)  NULL,
    [tipo_porta]          NVARCHAR (10)  NULL,
    [altura_minima_solo]  INT            NULL,
    [inativo]             BIT            NOT NULL
);

