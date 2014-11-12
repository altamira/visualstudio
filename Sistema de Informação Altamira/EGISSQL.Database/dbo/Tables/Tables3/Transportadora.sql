CREATE TABLE [dbo].[Transportadora] (
    [cd_transportadora]           INT           NOT NULL,
    [nm_transportadora]           VARCHAR (40)  NULL,
    [nm_fantasia]                 VARCHAR (30)  NULL,
    [nm_dominio]                  VARCHAR (100) NULL,
    [ic_frete_cobranca]           CHAR (1)      NULL,
    [ic_sedex]                    CHAR (1)      NULL,
    [ic_minuta]                   CHAR (1)      NULL,
    [ic_altera_pedido]            CHAR (1)      NULL,
    [ic_coleta]                   CHAR (1)      NULL,
    [ic_frete]                    CHAR (1)      NULL,
    [cd_tipo_pessoa]              INT           NULL,
    [cd_tipo_transporte]          INT           NULL,
    [ic_cobra_coleta]             CHAR (1)      NULL,
    [dt_cadastro]                 DATETIME      NULL,
    [nm_area_atuacao]             VARCHAR (60)  NULL,
    [cd_tipo_pagamento_frete]     INT           NULL,
    [cd_tipo_frete]               INT           NULL,
    [cd_usuario]                  INT           NULL,
    [dt_usuario]                  DATETIME      NULL,
    [nm_email_transportadora]     VARCHAR (100) NULL,
    [cd_identifica_cep]           INT           NULL,
    [cd_cnpj_transportadora]      VARCHAR (18)  NULL,
    [cd_cep]                      CHAR (9)      NULL,
    [cd_numero_endereco]          CHAR (10)     NULL,
    [nm_endereco]                 VARCHAR (50)  NULL,
    [nm_bairro]                   VARCHAR (30)  NULL,
    [cd_fax]                      CHAR (15)     NULL,
    [cd_telefone]                 CHAR (15)     NULL,
    [cd_ddd]                      CHAR (4)      NULL,
    [cd_pais]                     INT           NULL,
    [cd_estado]                   INT           NULL,
    [cd_cidade]                   INT           NULL,
    [cd_insc_municipal]           VARCHAR (22)  NULL,
    [nm_endereco_complemento]     VARCHAR (50)  NULL,
    [cd_insc_estadual]            VARCHAR (22)  NULL,
    [ic_wapnet_transportadora]    CHAR (1)      NULL,
    [ic_comex_transportadora]     CHAR (1)      NULL,
    [qt_peso_max_transp]          FLOAT (53)    NULL,
    [qt_peso_min_transp]          FLOAT (53)    NULL,
    [ic_padrao_importacao]        CHAR (1)      NULL,
    [ic_padrao_exportacao]        CHAR (1)      NULL,
    [ic_ativo_transportadora]     CHAR (1)      NULL,
    [cd_tipo_mercado]             INT           NULL,
    [ds_end_transportadora]       TEXT          NULL,
    [vl_km_rodado]                FLOAT (53)    NULL,
    [cd_empresa_diversa]          INT           NULL,
    [cd_tipo_conta_pagar]         INT           NULL,
    [ic_analise_transportadora]   CHAR (1)      NULL,
    [cd_registro_transportadora]  VARCHAR (20)  NULL,
    [cd_placa_transportadora]     VARCHAR (8)   NULL,
    [ic_destinatario]             CHAR (1)      NULL,
    [cd_interface]                VARCHAR (15)  NULL,
    [ic_icms_transportadora]      CHAR (1)      NULL,
    [ic_ie_isento_transportadora] CHAR (1)      NULL,
    CONSTRAINT [PK_Transportadora] PRIMARY KEY CLUSTERED ([cd_transportadora] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_cd_transportadora]
    ON [dbo].[Transportadora]([cd_transportadora] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_nm_fantasia]
    ON [dbo].[Transportadora]([nm_fantasia] ASC) WITH (FILLFACTOR = 90);


GO
create trigger dbo.pr_tg_deleta_codigo_transportadora
on dbo.Transportadora
for insert
as
declare @cd_apresentado int 
        select @cd_apresentado = cd_transportadora 
        from transportadora
        exec egisAdmin.dbo.sp_liberacodigo
             'EGISSQL.DBO.transportadora', 
             @cd_apresentado,
             'D'
