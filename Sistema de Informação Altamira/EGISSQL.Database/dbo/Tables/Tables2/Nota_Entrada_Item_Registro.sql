CREATE TABLE [dbo].[Nota_Entrada_Item_Registro] (
    [cd_sequencial]             INT          NOT NULL,
    [cd_item_registro_nota]     INT          NOT NULL,
    [cd_fornecedor]             INT          NULL,
    [cd_nota_entrada]           INT          NULL,
    [cd_operacao_fiscal]        INT          NULL,
    [cd_serie_nota_fiscal]      INT          NULL,
    [cd_item_rem]               INT          NULL,
    [cd_rem]                    INT          NULL,
    [cd_item_nota_entrada]      INT          NULL,
    [cd_nota_saida]             INT          NULL,
    [cd_item_nota_saida]        INT          NULL,
    [vl_cont_reg_nota_entrada]  FLOAT (53)   NULL,
    [pc_icms_reg_nota_entrada]  FLOAT (53)   NULL,
    [qt_item_reg_nota_entrada]  FLOAT (53)   NULL,
    [vl_bicms_reg_nota_entrada] FLOAT (53)   NULL,
    [dt_nota_entrada]           DATETIME     NULL,
    [cd_classificacao_fiscal]   INT          NULL,
    [vl_icms_reg_nota_entrada]  FLOAT (53)   NULL,
    [cd_unidade_medida]         INT          NULL,
    [vl_icmsisen_reg_nota_entr] FLOAT (53)   NULL,
    [vl_icmsoutr_reg_nota_entr] FLOAT (53)   NULL,
    [vl_icmsobs_reg_nota_entr]  FLOAT (53)   NULL,
    [pc_ipi_reg_nota_entrada]   FLOAT (53)   NULL,
    [vl_bipi_reg_nota_entrada]  FLOAT (53)   NULL,
    [vl_ipi_reg_nota_entrada]   FLOAT (53)   NULL,
    [vl_ipiisen_reg_nota_entr]  FLOAT (53)   NULL,
    [vl_ipioutr_reg_nota_entr]  FLOAT (53)   NULL,
    [vl_ipiobs_reg_nota_entr]   FLOAT (53)   NULL,
    [nm_obsicms_reg_nota_entr]  VARCHAR (50) NULL,
    [nm_obsipi_reg_nota_entr]   VARCHAR (50) NULL,
    [cd_carta_liv_reg_nota_ent] INT          NULL,
    [cd_tributacao]             INT          NULL,
    [cd_natdipi_reg_nota_entra] CHAR (3)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_resumo_entrada]         CHAR (1)     NULL,
    [ic_servico_item_nota]      CHAR (1)     NULL,
    [cd_mascara_operacao]       CHAR (6)     NULL,
    [cd_mascara_conta]          VARCHAR (20) NULL,
    [sg_estado]                 CHAR (2)     NULL,
    [cd_cnpj]                   VARCHAR (18) NULL,
    [nm_razao_social]           VARCHAR (45) NULL,
    [cd_destinatario]           INT          NULL,
    [sg_serie_nota_fiscal]      CHAR (10)    NULL,
    [nm_serie_nota_entrada]     CHAR (5)     NULL,
    [dt_receb_nota_entrada]     DATETIME     NULL,
    [cd_inscestadual]           VARCHAR (18) NULL,
    [cd_num_formulario]         INT          NULL,
    [ic_contribicms_op_fiscal]  CHAR (1)     NULL,
    [cd_tipo_destinatario]      INT          NULL,
    [cd_destinacao_producao]    INT          NULL,
    [cd_mascara_classificacao]  VARCHAR (10) NULL,
    [ic_manutencao_fiscal]      CHAR (1)     NULL,
    [pc_reducao_nota_entrada]   FLOAT (53)   NULL,
    CONSTRAINT [PK_Nota_Entrada_Item_Registro] PRIMARY KEY CLUSTERED ([cd_sequencial] ASC, [cd_item_registro_nota] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Nota_Entrada_Item_Registro1]
    ON [dbo].[Nota_Entrada_Item_Registro]([cd_fornecedor] ASC, [cd_nota_entrada] ASC, [cd_operacao_fiscal] ASC, [cd_serie_nota_fiscal] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Nota_Entrada_Item_Registro2]
    ON [dbo].[Nota_Entrada_Item_Registro]([cd_nota_saida] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Nota_Entrada_Item_Registro3]
    ON [dbo].[Nota_Entrada_Item_Registro]([dt_nota_entrada] ASC) WITH (FILLFACTOR = 90);

