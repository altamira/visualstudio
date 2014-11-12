﻿CREATE TABLE [dbo].[PRE_Produtos] (
    [prpr_Codigo]         NVARCHAR (11) NOT NULL,
    [prpr_Descricao]      NVARCHAR (50) NOT NULL,
    [prpr_Unidade]        SMALLINT      NULL,
    [prpr_Peso]           FLOAT (53)    NOT NULL,
    [prpr_Largura]        FLOAT (53)    NULL,
    [prpr_Comprimento]    FLOAT (53)    NULL,
    [prpr_LargAcabada]    FLOAT (53)    NULL,
    [prpr_CompAcabado]    FLOAT (53)    NULL,
    [prpr_SaldoEstoque]   NVARCHAR (6)  NULL,
    [prpr_ValorUnitario]  MONEY         NULL,
    [prpr_FatorVenda]     FLOAT (53)    NULL,
    [prpr_TipoChapa]      FLOAT (53)    NULL,
    [prpr_Mapa]           NVARCHAR (6)  NULL,
    [prpr_EstoqueMinimo]  INT           NULL,
    [prpr_EstoqueMaximo]  INT           NULL,
    [prpr_ModResistencia] INT           NULL,
    [prpr_MomInercia]     INT           NULL,
    [prpr_CompVariavel]   TINYINT       NULL,
    [prpr_Guilhotina]     TINYINT       NULL,
    [prpr_Dobradeira]     TINYINT       NULL,
    [prpr_Prensas]        TINYINT       NULL,
    [prpr_Perfiladeira]   TINYINT       NULL,
    [prpr_Blanks]         TINYINT       NULL,
    [prpr_Estamparia]     TINYINT       NULL,
    [prpr_SoldaPonto]     TINYINT       NULL,
    [prpr_SoldaEletrica]  TINYINT       NULL,
    [prpr_Pintura]        TINYINT       NULL,
    [prpr_Almoxarifado]   TINYINT       NULL,
    [prpr_Entrega]        TINYINT       NULL,
    [prpr_Marcenaria]     TINYINT       NULL,
    [prpr_Terceirizado]   TINYINT       NULL,
    [prpr_CodBobina]      FLOAT (53)    NULL,
    [prpr_MatEstoque]     TINYINT       NULL,
    [prpr_TpFerramenta01] NVARCHAR (7)  NULL,
    [prpr_TpFerramenta02] NVARCHAR (7)  NULL,
    [prpr_TpFerramenta03] NVARCHAR (7)  NULL,
    [prpr_TpFerramenta04] NVARCHAR (7)  NULL,
    [prpr_Area]           INT           NULL,
    [prpr_CodTerceiros]   INT           NULL,
    [prpr_Lock]           VARBINARY (8) NULL
);

