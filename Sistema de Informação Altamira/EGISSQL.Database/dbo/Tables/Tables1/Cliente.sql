CREATE TABLE [dbo].[Cliente] (
    [cd_cliente]                 INT           NOT NULL,
    [nm_fantasia_cliente]        VARCHAR (15)  NOT NULL,
    [nm_razao_social_cliente]    VARCHAR (60)  NULL,
    [nm_razao_social_cliente_c]  VARCHAR (40)  NULL,
    [nm_dominio_cliente]         VARCHAR (100) NULL,
    [nm_email_cliente]           VARCHAR (100) NULL,
    [ic_destinacao_cliente]      CHAR (1)      NULL,
    [cd_suframa_cliente]         VARCHAR (50)  NULL,
    [cd_reparticao_origem]       VARCHAR (15)  NULL,
    [pc_desconto_cliente]        FLOAT (53)    NULL,
    [dt_cadastro_cliente]        DATETIME      NULL,
    [ds_cliente]                 TEXT          NULL,
    [cd_conceito_cliente]        INT           NULL,
    [cd_tipo_pessoa]             INT           NULL,
    [cd_fonte_informacao]        INT           NULL,
    [cd_ramo_atividade]          INT           NULL,
    [cd_status_cliente]          INT           NULL,
    [cd_transportadora]          INT           NULL,
    [cd_criterio_visita]         INT           NULL,
    [cd_tipo_comunicacao]        INT           NULL,
    [cd_tipo_mercado]            INT           NULL,
    [cd_idioma]                  INT           NULL,
    [cd_cliente_filial]          INT           NULL,
    [cd_identifica_cep]          INT           NULL,
    [cd_cnpj_cliente]            VARCHAR (18)  NULL,
    [cd_inscMunicipal]           VARCHAR (18)  NULL,
    [cd_inscestadual]            VARCHAR (18)  NULL,
    [cd_cep]                     CHAR (9)      NULL,
    [nm_endereco_cliente]        VARCHAR (60)  NULL,
    [cd_numero_endereco]         CHAR (10)     NULL,
    [nm_complemento_endereco]    VARCHAR (60)  NULL,
    [nm_bairro]                  VARCHAR (25)  NULL,
    [cd_cidade]                  INT           NULL,
    [cd_estado]                  INT           NULL,
    [cd_pais]                    INT           NULL,
    [cd_ddd]                     CHAR (4)      NULL,
    [cd_telefone]                VARCHAR (15)  NULL,
    [cd_fax]                     VARCHAR (15)  NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    [cd_cliente_sap]             INT           NULL,
    [ic_contrib_icms_cliente]    CHAR (1)      NULL,
    [cd_aplicacao_segmento]      INT           NULL,
    [cd_filial_empresa]          INT           NULL,
    [ic_liberado_pesq_credito]   CHAR (1)      NULL,
    [cd_tipo_tabela_preco]       INT           NULL,
    [cd_regiao]                  INT           NULL,
    [cd_centro_custo]            INT           NULL,
    [cd_cliente_grupo]           INT           NULL,
    [cd_destinacao_produto]      INT           NULL,
    [ic_exportador_cliente]      CHAR (1)      NULL,
    [nm_especificacao_ramo]      VARCHAR (30)  NULL,
    [ic_wapnet_cliente]          CHAR (1)      NULL,
    [cd_vendedor]                INT           NULL,
    [cd_vendedor_interno]        INT           NULL,
    [cd_condicao_pagamento]      INT           NULL,
    [cd_cliente_filial_sap]      INT           NULL,
    [cd_categoria_cliente]       INT           NULL,
    [ic_wapnet_wap]              CHAR (1)      NULL,
    [nm_divisao_area]            VARCHAR (40)  NULL,
    [ic_permite_agrupar_pedido]  CHAR (1)      NULL,
    [nm_ponto_ref_cliente]       VARCHAR (100) NULL,
    [pc_comissao_cliente]        FLOAT (53)    NULL,
    [ic_isento_insc_cliente]     CHAR (1)      NULL,
    [cd_conta]                   INT           NULL,
    [ds_cliente_endereco]        TEXT          NULL,
    [ic_mp66_cliente]            CHAR (1)      NULL,
    [nm_cidade_mercado_externo]  VARCHAR (60)  NULL,
    [sg_estado_mercado_externo]  CHAR (10)     NULL,
    [nm_pais_mercado_externo]    VARCHAR (60)  NULL,
    [qt_distancia_cliente]       FLOAT (53)    NULL,
    [ic_rateio_comissao_client]  CHAR (1)      NULL,
    [cd_pag_guia_cliente]        VARCHAR (10)  NULL,
    [ic_inscestadual_valida]     CHAR (1)      NULL,
    [ic_habilitado_suframa]      CHAR (1)      NULL,
    [ic_global_cliente]          CHAR (1)      NULL,
    [ic_foco_cliente]            CHAR (1)      NULL,
    [ic_oem_cliente]             CHAR (1)      NULL,
    [ic_distribuidor_cliente]    CHAR (1)      NULL,
    [cd_cliente_global]          INT           NULL,
    [dt_exportacao_registro]     DATETIME      NULL,
    [cd_porto]                   INT           NULL,
    [cd_abablz_cliente]          VARCHAR (30)  NULL,
    [cd_swift_cliente]           VARCHAR (30)  NULL,
    [cd_moeda]                   INT           NULL,
    [cd_barra_cliente]           VARCHAR (20)  NULL,
    [ic_fmea_cliente]            CHAR (1)      NULL,
    [cd_fornecedor_cliente]      VARCHAR (15)  NULL,
    [ic_plano_controle_cliente]  CHAR (1)      NULL,
    [ic_op_simples_cliente]      CHAR (1)      NULL,
    [cd_dispositivo_legal]       INT           NULL,
    [ic_promocao_cliente]        CHAR (1)      NULL,
    [ic_contrato_cliente]        CHAR (1)      NULL,
    [cd_idioma_produto_exp]      INT           NULL,
    [cd_loja]                    INT           NULL,
    [cd_tabela_preco]            INT           NULL,
    [pc_icms_reducao_cliente]    FLOAT (53)    NULL,
    [ic_epp_cliente]             CHAR (1)      NULL,
    [ic_me_cliente]              CHAR (1)      NULL,
    [cd_forma_pagamento]         INT           NULL,
    [ic_dif_aliq_icms]           CHAR (1)      NULL,
    [cd_tratamento_pessoa]       INT           NULL,
    [cd_tipo_pagamento]          INT           NULL,
    [cd_cliente_prospeccao]      INT           NULL,
    [cd_tipo_documento]          INT           NULL,
    [ic_sub_tributaria_cliente]  CHAR (1)      NULL,
    [ic_analise_cliente]         CHAR (1)      NULL,
    [cd_portador]                INT           NULL,
    [cd_ddd_celular_cliente]     VARCHAR (4)   NULL,
    [cd_celular_cliente]         VARCHAR (15)  NULL,
    [dt_aniversario_cliente]     DATETIME      NULL,
    [ic_inss_cliente]            CHAR (1)      NULL,
    [ic_polo_plastico_cliente]   CHAR (1)      NULL,
    [ic_dispositivo_polo]        CHAR (1)      NULL,
    [ic_valida_ie_cliente]       CHAR (1)      NULL,
    [cd_tipo_pagamento_frete]    INT           NULL,
    [ic_multi_form_cliente]      CHAR (1)      NULL,
    [ic_fat_minimo_cliente]      CHAR (1)      NULL,
    [ic_pis_cofins_cliente]      CHAR (1)      NULL,
    [pc_pis_cliente]             FLOAT (53)    NULL,
    [pc_cofins_cliente]          FLOAT (53)    NULL,
    [cd_tipo_local_entrega]      INT           NULL,
    [ic_cpv_cliente]             CHAR (1)      NULL,
    [cd_plano_financeiro]        INT           NULL,
    [ic_espelho_nota_cliente]    CHAR (1)      NULL,
    [ic_arquivo_nota_cliente]    CHAR (1)      NULL,
    [cd_interface]               VARCHAR (15)  NULL,
    [qt_latitude_cliente]        FLOAT (53)    NULL,
    [qt_longitude_cliente]       FLOAT (53)    NULL,
    [cd_unidade_medida]          INT           NULL,
    [ic_ipi_base_st_cliente]     CHAR (1)      NULL,
    [cd_insc_rural_cliente]      VARCHAR (30)  NULL,
    [ic_reter_piscofins_cliente] CHAR (1)      NULL,
    [cd_codificacao_cliente]     INT           NULL,
    [ic_retencao_cliente]        CHAR (1)      NULL,
    [cd_classificacao_cliente]   INT           NULL,
    CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Dispositivo_Legal] FOREIGN KEY ([cd_dispositivo_legal]) REFERENCES [dbo].[Dispositivo_Legal] ([cd_dispositivo_legal]),
    CONSTRAINT [FK_Cliente_Idioma] FOREIGN KEY ([cd_idioma_produto_exp]) REFERENCES [dbo].[Idioma] ([cd_idioma]),
    CONSTRAINT [FK_Cliente_Loja] FOREIGN KEY ([cd_loja]) REFERENCES [dbo].[Loja] ([cd_loja]),
    CONSTRAINT [FK_Cliente_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Cliente_Portador] FOREIGN KEY ([cd_portador]) REFERENCES [dbo].[Portador] ([cd_portador]),
    CONSTRAINT [FK_Cliente_Porto] FOREIGN KEY ([cd_porto]) REFERENCES [dbo].[Porto] ([cd_porto]),
    CONSTRAINT [FK_Cliente_Tabela_Preco] FOREIGN KEY ([cd_tabela_preco]) REFERENCES [dbo].[Tabela_Preco] ([cd_tabela_preco])
);


GO
CREATE NONCLUSTERED INDEX [ix_nm_fantasia_cliente]
    ON [dbo].[Cliente]([nm_fantasia_cliente] ASC) WITH (FILLFACTOR = 90);


GO

Create trigger tIU_Cliente_PessoaFisica
on Cliente
after update, insert
---------------------------------------------------
--GBS - Global Business Solution	             2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Fabio Cesar
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização do campo "ic_contrib_icms_cliente" e "ic_isento_insc_cliente" na tabela de Cliente
--          quando o tipo de cliente é pessoa física
--Data: 31.03.2006
---------------------------------------------------
as
begin

  --Atualiza o cliente como não contribuite para os clientes pessoa física
  update Cliente    
  set
    ic_contrib_icms_cliente = 'N',
    ic_isento_insc_cliente = 'S'
  from
    Inserted, Cliente
  where
    Inserted.cd_cliente = Cliente.cd_cliente
    and ( IsNull(Cliente.ic_contrib_icms_cliente,'S') <> 'N' 
          or IsNull(Cliente.ic_isento_insc_cliente,'N') <> 'S' )
    and IsNull(Cliente.cd_tipo_pessoa,1) = 2 --Define sempre pessoa física como sendo "ISENTO" e "NÃO CONTRIBUINTE"    
end

-- GO

-- Select 
--   nm_fantasia_cliente,
--   cd_cnpj_cliente,
--   IsNull(Cliente.ic_contrib_icms_cliente,'S') ic_contrib_icms_cliente,
--   IsNull(Cliente.ic_isento_insc_cliente,'N') as ic_isento_insc_cliente  
-- from 
--   Cliente
-- where
--     ( IsNull(Cliente.ic_contrib_icms_cliente,'S') <> 'N' 
--           or IsNull(Cliente.ic_isento_insc_cliente,'N') <> 'S' )
--     and IsNull(Cliente.cd_tipo_pessoa,1) = 2
--     and cd_status_cliente in (1,3)
-- 
-- 
-- begin tran
-- update cliente
-- set
--   ic_contrib_icms_cliente = 'N',
--   ic_isento_insc_cliente = 'S' 
-- where
--     ( IsNull(Cliente.ic_contrib_icms_cliente,'S') <> 'N' 
--           or IsNull(Cliente.ic_isento_insc_cliente,'N') <> 'S' )
--     and IsNull(Cliente.cd_tipo_pessoa,1) = 2
--     and cd_status_cliente in (1,3)
-- 
-- commit tran
-- rollback tran
