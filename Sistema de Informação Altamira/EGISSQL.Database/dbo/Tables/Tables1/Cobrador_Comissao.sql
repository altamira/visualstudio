CREATE TABLE [dbo].[Cobrador_Comissao] (
    [cd_cobrador]               INT        NOT NULL,
    [cd_regiao_cobrador]        INT        NULL,
    [cd_tipo_comissao]          INT        NULL,
    [dt_base_pagto_comissao]    DATETIME   NULL,
    [dt_base_final_comissao]    DATETIME   NULL,
    [ic_calcula_data_final]     CHAR (1)   NULL,
    [vl_piso_comissao_cobrador] FLOAT (53) NULL,
    [pc_comissao_cobrador]      FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [vl_tet_comisssao_cobrador] FLOAT (53) NULL,
    CONSTRAINT [PK_Cobrador_Comissao] PRIMARY KEY CLUSTERED ([cd_cobrador] ASC) WITH (FILLFACTOR = 90)
);

