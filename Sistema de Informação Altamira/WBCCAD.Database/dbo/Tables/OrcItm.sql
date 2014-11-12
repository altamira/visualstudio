CREATE TABLE [dbo].[OrcItm] (
    [numeroOrcamento]        NCHAR (9)      NULL,
    [orcitm_altura]          MONEY          NULL,
    [orcitm_comprimento]     MONEY          NULL,
    [OrcItm_Desc_Destacado]  BIT            NULL,
    [OrcItm_Desconto_Grupo]  MONEY          NULL,
    [OrcItm_Diferenca]       MONEY          NULL,
    [orcitm_dtc]             NVARCHAR (250) NULL,
    [OrcItm_Encargos]        MONEY          NULL,
    [OrcItm_Frete]           MONEY          NULL,
    [orcitm_grupo]           INT            NULL,
    [OrcItm_IPI]             MONEY          NULL,
    [orcitm_largura]         MONEY          NULL,
    [OrcItm_Preco_Lista]     MONEY          NULL,
    [OrcItm_Preco_Lista_Sem] MONEY          NULL,
    [orcitm_qtde]            FLOAT (53)     NULL,
    [ORCITM_REFERENCIA]      NVARCHAR (8)   NULL,
    [orcitm_subgrupo]        NVARCHAR (2)   NULL,
    [orcitm_suprimir_itens]  BIT            NULL,
    [ORCITM_TOTAL]           INT            NULL,
    [OrcItm_ValGrupoComDesc] MONEY          NULL,
    [orcitm_valor_total]     MONEY          NULL,
    [proposta_descricao]     NVARCHAR (50)  NULL,
    [proposta_grupo]         INT            NULL,
    [proposta_imagem]        NVARCHAR (255) NULL,
    [proposta_ordem]         INT            NULL,
    [proposta_texto_base]    NVARCHAR (150) NULL,
    [proposta_texto_item]    NVARCHAR (150) NULL,
    [idOrcItm]               INT            IDENTITY (1, 1) NOT NULL,
    [orcitm_item]            VARCHAR (20)   NULL,
    CONSTRAINT [PK_OrcItm] PRIMARY KEY CLUSTERED ([idOrcItm] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_OrcItm]
    ON [dbo].[OrcItm]([numeroOrcamento] ASC, [idOrcItm] ASC);

