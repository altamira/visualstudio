﻿CREATE TABLE [dbo].[cam_frc] (
    [frc_descricao]      NVARCHAR (40)  NULL,
    [frc_codigo]         NVARCHAR (20)  NULL,
    [frc_desenho]        NVARCHAR (255) NULL,
    [frc_kva]            FLOAT (53)     NULL,
    [frc_hp]             FLOAT (53)     NULL,
    [frc_comprimento]    INT            NULL,
    [frc_kcal]           INT            NULL,
    [frc_regime]         NVARCHAR (20)  NULL,
    [frc_fabricante]     NVARCHAR (40)  NULL,
    [frc_temperatura]    INT            NULL,
    [frc_grupo_degelo]   NVARCHAR (50)  NULL,
    [RTF_PADRAO]         NVARCHAR (50)  NULL,
    [possui_resistencia] BIT            NOT NULL,
    [carga_gas]          FLOAT (53)     NULL,
    [carga_oleo]         FLOAT (53)     NULL,
    [frc_central]        BIT            NOT NULL,
    [multiplo_fixacao]   INT            NULL,
    [fase_resist]        NVARCHAR (2)   NULL,
    [fase_moto]          NVARCHAR (2)   NULL,
    [Alt_max_insercao]   INT            NULL,
    [Tipo_degelo]        NVARCHAR (20)  NULL,
    [dim_a]              NVARCHAR (5)   NULL,
    [dim_b]              NVARCHAR (5)   NULL,
    [dim_c]              NVARCHAR (5)   NULL,
    [dim_d]              NVARCHAR (5)   NULL,
    [dim_e]              NVARCHAR (5)   NULL,
    [frc_vazao]          FLOAT (53)     NULL,
    [frc_num_vent]       FLOAT (53)     NULL
);

