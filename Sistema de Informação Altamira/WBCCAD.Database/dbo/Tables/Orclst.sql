CREATE TABLE [dbo].[Orclst] (
    [orclst_numero]              NVARCHAR (40)  NOT NULL,
    [orclst_status]              INT            CONSTRAINT [DF_Orclst_orclst_status] DEFAULT ((0)) NOT NULL,
    [orclst_cadastro]            DATETIME       NULL,
    [orclst_emissao]             DATETIME       NULL,
    [orclst_contato]             NVARCHAR (MAX) NULL,
    [orclst_loja]                NVARCHAR (50)  NULL,
    [orclst_municipio]           NVARCHAR (23)  NULL,
    [orclst_uf]                  NVARCHAR (2)   NULL,
    [orclst_area]                INT            NULL,
    [orclst_planta]              NVARCHAR (1)   NULL,
    [orclst_corte]               NVARCHAR (1)   NULL,
    [orclst_orcamento]           NVARCHAR (1)   NULL,
    [orclst_nr_orc_vnd]          NVARCHAR (10)  NULL,
    [orclst_lista]               NVARCHAR (20)  NULL,
    [orclst_revisao]             NVARCHAR (1)   NULL,
    [orclst_total]               FLOAT (53)     NULL,
    [orclst_nova_reforma]        NVARCHAR (1)   NULL,
    [orclst_versao_dat]          NVARCHAR (10)  NULL,
    [orclst_cli_codigo]          INT            NULL,
    [orclst_cli_nome]            NVARCHAR (50)  NULL,
    [orclst_cli_cgc_cpf]         NVARCHAR (18)  NULL,
    [orclst_cli_end_especie]     NVARCHAR (4)   NULL,
    [orclst_cli_end_endereco]    NVARCHAR (50)  NULL,
    [orclst_cli_end_numero]      NVARCHAR (6)   NULL,
    [orclst_cli_end_bairro]      NVARCHAR (30)  NULL,
    [orclst_cli_end_cep]         NVARCHAR (9)   NULL,
    [orclst_cli_end_complemento] NVARCHAR (30)  NULL,
    [orclst_cli_bmp]             NVARCHAR (255) NULL,
    [orclst_data_status]         DATETIME       NULL,
    [orclst_revisao_orc]         NVARCHAR (1)   NULL,
    [orclst_temperatura]         INT            NULL,
    [orclst_motivo]              NVARCHAR (40)  NULL,
    [orclst_caminho_dwg]         NVARCHAR (255) NULL,
    [orclst_pedido]              NVARCHAR (15)  NULL,
    [orclst_pedido_data]         DATETIME       NULL,
    [orclst_pedido_usuario]      NVARCHAR (255) NULL,
    [orclst_dataImportacao]      DATETIME       NULL,
    [orclst_email]               BIT            NULL,
    [orclst_data_email]          DATETIME       NULL,
    [orclst_opcao_comissao]      NVARCHAR (50)  NULL,
    [OrcLst_EmUsoPor]            NVARCHAR (50)  NULL,
    [OrcLst_Computador]          NVARCHAR (50)  NULL,
    [BANDEIRA]                   NVARCHAR (50)  NULL,
    [ORCLSTDATAULTATUALIZACAO]   DATETIME       NULL,
    [ORCLSTDATAFATURAMENTO]      DATETIME       NULL,
    [COMISSAO_FATOR]             MONEY          NULL,
    [ORCLST_REFERENCIA]          NVARCHAR (40)  NULL,
    [ORCLST_TOTAL1]              MONEY          NULL,
    [ORCLST_TOTAL2]              MONEY          NULL,
    [ORCLSTDATAENTREGA]          DATETIME       NULL,
    [ORCLST_IMPORTACAO_LISTA]    DATETIME       NULL,
    [ORCLST_GERENTE]             NVARCHAR (50)  NULL,
    [ORCLST_VENDEDOR]            NVARCHAR (50)  NULL,
    [ORCLST_PROJETISTA]          NVARCHAR (50)  NULL,
    [ORCLST_ORCAMENTISTA]        NVARCHAR (50)  NULL,
    [idOrcLst]                   INT            IDENTITY (1, 1) NOT NULL,
    [ORCLST_AGENTE]              NVARCHAR (60)  NULL,
    [ORCLST_TOTAL_LISTA]         MONEY          CONSTRAINT [DF__Orclst__ORCLST_T__0FB750B3] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_Orclst] PRIMARY KEY CLUSTERED ([orclst_numero] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Orclst]
    ON [dbo].[Orclst]([orclst_numero] ASC, [idOrcLst] ASC);


GO
GRANT SELECT
    ON OBJECT::[dbo].[Orclst] TO [interclick]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[Orclst] TO [altanet]
    AS [dbo];

