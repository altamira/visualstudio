CREATE TABLE [dbo].[prdorc] (
    [indice]                 INT            IDENTITY (1, 1) NOT NULL,
    [Produto]                NVARCHAR (20)  NULL,
    [Descricao]              NVARCHAR (70)  NULL,
    [Unidade]                NVARCHAR (2)   NULL,
    [Peso]                   FLOAT (53)     NULL,
    [Familia]                NVARCHAR (30)  NULL,
    [Cor_padrao]             NVARCHAR (50)  NULL,
    [Situacao]               NVARCHAR (20)  NULL,
    [Altura]                 FLOAT (53)     NULL,
    [Comprimento]            INT            NULL,
    [Largura]                INT            NULL,
    [PrdOrcImagem]           NVARCHAR (255) NULL,
    [Preco]                  FLOAT (53)     NULL,
    [PRDORCVARIAVEIS]        NVARCHAR (255) NULL,
    [IMPORTARESTRUTURA]      INT            NULL,
    [ORIGEM]                 NVARCHAR (1)   NULL,
    [TRAVAR_REPRESENTANTE]   BIT            CONSTRAINT [DF_prdorc_TRAVAR_REPRESENTANTE] DEFAULT ((0)) NULL,
    [PRDORCCHK]              INT            NULL,
    [ITEMFATURADO]           BIT            CONSTRAINT [DF_prdorc_ITEMFATURADO] DEFAULT ((0)) NULL,
    [ATUALIZADOEM]           DATETIME       NULL,
    [IMPORTADOEM]            DATETIME       NULL,
    [PRDORC_FORNECEDOR]      NVARCHAR (20)  NULL,
    [PRDORC_GRUPOCORESADC]   NVARCHAR (255) NULL,
    [PRDORC_GRUPOCOR]        NVARCHAR (50)  NULL,
    [PRDORC_PRC_FORMULA]     INT            NULL,
    [PRDORC_PRC_COMPRIMENTO] INT            NULL,
    [PRDORC_PRC_ALTURA]      INT            NULL,
    [PRDORC_PRC_LARGURA]     INT            NULL,
    [PRDDSCORC]              NVARCHAR (100) NULL,
    [PRDCRTADC]              NVARCHAR (5)   NULL,
    [PRDORC_PRIORIDADE]      INT            NULL,
    [PRDORC_PESO_FIX]        FLOAT (53)     NULL,
    [PRDORC_PESO_CMP]        FLOAT (53)     NULL,
    [PRDORC_PESO_ALT]        FLOAT (53)     NULL,
    [PRDORC_PESO_PRF]        FLOAT (53)     NULL,
    [PRDORC_EXP_FLAG_CMP]    BIT            CONSTRAINT [DF_prdorc_PRDORC_EXP_FLAG_CMP] DEFAULT ((0)) NULL,
    [PRDORC_EXP_FLAG_ALT]    BIT            CONSTRAINT [DF_prdorc_PRDORC_EXP_FLAG_ALT] DEFAULT ((0)) NULL,
    [PRDORC_EXP_FLAG_LRG]    BIT            CONSTRAINT [DF_prdorc_PRDORC_EXP_FLAG_LRG] DEFAULT ((0)) NULL,
    [prdorc_semcentavos]     BIT            CONSTRAINT [DF_prdorc_prdorc_semcentavos] DEFAULT ((0)) NULL,
    [codigoIntegracao]       NVARCHAR (255) NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_prdorc]
    ON [dbo].[prdorc]([Produto] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_prdorc_1]
    ON [dbo].[prdorc]([PRDORC_PRIORIDADE] ASC, [Produto] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[prdorc] TO [interclick]
    AS [dbo];

