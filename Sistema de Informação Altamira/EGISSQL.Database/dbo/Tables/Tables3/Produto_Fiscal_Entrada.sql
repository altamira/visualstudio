﻿CREATE TABLE [dbo].[Produto_Fiscal_Entrada] (
    [cd_produto]                INT        NOT NULL,
    [cd_classificacao_fiscal]   INT        NULL,
    [cd_procedencia_produto]    INT        NULL,
    [cd_tipo_produto]           INT        NULL,
    [cd_tributacao]             INT        NULL,
    [pc_aliquota_icms_produto]  FLOAT (53) NULL,
    [pc_aliquota_iss_produto]   FLOAT (53) NULL,
    [ic_substrib_produto]       CHAR (1)   NULL,
    [cd_destinacao_produto]     INT        NULL,
    [cd_dispositivo_legal_ipi]  INT        NULL,
    [cd_dispositivo_legal_icms] INT        NULL,
    [qt_aliquota_icms_produto]  FLOAT (53) NULL,
    [pc_interna_icms_produto]   FLOAT (53) NULL,
    [ic_isento_icms_produto]    CHAR (1)   NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [vl_ipi_produto_fiscal]     FLOAT (53) NULL,
    [cd_modalidade_icms]        INT        NULL,
    [cd_modalidade_icms_st]     INT        NULL,
    [cd_tipo_item]              INT        NULL,
    CONSTRAINT [PK_Produto_Fiscal_Entrada] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Fiscal_Entrada_Classificacao_Fiscal] FOREIGN KEY ([cd_classificacao_fiscal]) REFERENCES [dbo].[Classificacao_Fiscal] ([cd_classificacao_fiscal])
);

