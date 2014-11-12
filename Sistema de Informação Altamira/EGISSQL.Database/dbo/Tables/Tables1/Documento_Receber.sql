CREATE TABLE [dbo].[Documento_Receber] (
    [cd_documento_receber]      INT          NOT NULL,
    [cd_identificacao]          VARCHAR (25) NOT NULL,
    [dt_emissao_documento]      DATETIME     NOT NULL,
    [dt_vencimento_documento]   DATETIME     NOT NULL,
    [dt_vencimento_original]    DATETIME     NULL,
    [vl_documento_receber]      FLOAT (53)   NOT NULL,
    [vl_saldo_documento]        FLOAT (53)   NOT NULL,
    [dt_cancelamento_documento] DATETIME     NULL,
    [nm_cancelamento_documento] VARCHAR (60) NULL,
    [cd_modulo]                 INT          NULL,
    [cd_banco_documento]        INT          NULL,
    [ds_documento_receber]      TEXT         NULL,
    [ic_emissao_documento]      CHAR (1)     NULL,
    [dt_envio_banco_documento]  DATETIME     NULL,
    [dt_contabil_documento]     DATETIME     NULL,
    [cd_portador]               INT          NOT NULL,
    [cd_tipo_cobranca]          INT          NOT NULL,
    [cd_cliente]                INT          NOT NULL,
    [cd_tipo_documento]         INT          NOT NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_vendedor]               INT          NULL,
    [cd_pedido_venda]           INT          NULL,
    [cd_nota_saida]             INT          NULL,
    [ic_tipo_abatimento]        CHAR (1)     NULL,
    [cd_tipo_liquidacao]        INT          NULL,
    [dt_pagto_document_receber] DATETIME     NULL,
    [vl_pagto_document_receber] FLOAT (53)   NULL,
    [cd_banco_documento_recebe] VARCHAR (50) NULL,
    [ic_envio_documento]        CHAR (1)     NULL,
    [dt_fluxo_documento_recebe] DATETIME     NULL,
    [ic_tipo_lancamento]        CHAR (1)     NULL,
    [cd_banco_doc_receber]      VARCHAR (30) NULL,
    [dt_fluxo_doc_receber]      DATETIME     NULL,
    [cd_plano_financeiro]       INT          NULL,
    [dt_fluxo_docto_receber]    DATETIME     NULL,
    [ic_fluxo_caixa]            CHAR (1)     NULL,
    [nm_sacado_doc_receber]     VARCHAR (40) NULL,
    [vl_limite_credito_cliente] FLOAT (53)   NULL,
    [ic_cobranca_eletronica]    CHAR (1)     NULL,
    [ic_informacao_credito]     CHAR (1)     NULL,
    [cd_tipo_destinatario]      INT          NULL,
    [dt_retorno_banco_doc]      DATETIME     NULL,
    [cd_arquivo_magnetico]      INT          NULL,
    [vl_abatimento_documento]   FLOAT (53)   NULL,
    [vl_reembolso_documento]    FLOAT (53)   NULL,
    [dt_devolucao_documento]    DATETIME     NULL,
    [nm_devolucao_documento]    VARCHAR (40) NULL,
    [dt_impressao_documento]    DATETIME     NULL,
    [ic_credito_icms_documento] CHAR (1)     NULL,
    [ic_anuencia_documento]     CHAR (1)     NULL,
    [cd_rebibo]                 INT          NULL,
    [cd_moeda]                  INT          NULL,
    [cd_embarque_chave]         INT          NULL,
    [dt_selecao_documento]      DATETIME     NULL,
    [cd_loja]                   INT          NULL,
    [cd_centro_custo]           INT          NULL,
    [cd_contrato]               INT          NULL,
    [cd_lote_receber]           INT          NULL,
    [cd_nota_promissoria]       INT          NULL,
    [cd_parcela_nota_saida]     INT          NULL,
    [cd_ordem_servico]          INT          NULL,
    [cd_cheque_terceiro]        INT          NULL,
    [cd_conta_banco_remessa]    INT          NULL,
    [cd_nosso_numero_documento] VARCHAR (50) NULL,
    [cd_digito_bancario]        CHAR (1)     NULL,
    [cd_movimento_caixa]        INT          NULL,
    [cd_tipo_fluxo_caixa]       INT          NULL,
    [ic_lote_documento]         CHAR (1)     NULL,
    [cd_serie_nota_fiscal]      INT          NULL,
    CONSTRAINT [PK_Documento_Receber] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_identificacao_document]
    ON [dbo].[Documento_Receber]([cd_identificacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Plano_Financeiro_Documento_Receber]
    ON [dbo].[Documento_Receber]([cd_plano_financeiro] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_documento_receber_info]
    ON [dbo].[Documento_Receber]([cd_cliente] ASC, [vl_saldo_documento] ASC, [dt_cancelamento_documento] ASC, [dt_devolucao_documento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_documento_receber_Identificacao]
    ON [dbo].[Documento_Receber]([cd_identificacao] ASC);


GO
CREATE NONCLUSTERED INDEX [ix_cd_identificacao]
    ON [dbo].[Documento_Receber]([cd_identificacao] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_dt_vencimento_documento]
    ON [dbo].[Documento_Receber]([dt_vencimento_documento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_cd_nota_saida]
    ON [dbo].[Documento_Receber]([cd_nota_saida] ASC) WITH (FILLFACTOR = 90);


GO

create trigger tD_documento_receber_informacao_comercial
on Documento_Receber 
for delete 
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização da tabela Cliente_Informacao_Credito após
--          modificações em documento_receber
--Data: 20/03/2002
--Atualizado: 02/04/2002 - Migração p/ EGISSQL - Elias
--            12/06/2002 - Mudança do nome p/ poadrao GBS - ELIAS
---------------------------------------------------
as
begin
  
  declare @ic_parametro            int
  declare @cd_cliente              int
  declare @vl_documento_receber    float
  declare @dt_emissao_documento    datetime
  declare @dt_vencimento_documento datetime
  declare @cd_usuario              int
  
  -- parametro de atualização de um único cliente
  set @ic_parametro = 2

  -- carrega as variáveis p/ execução da stored procedure de atualização
  if exists(select cd_cliente from deleted)
    begin

      select
        @cd_cliente              = cd_cliente,
        @vl_documento_receber    = vl_documento_receber,
        @dt_emissao_documento    = dt_emissao_documento,
        @dt_vencimento_documento = dt_vencimento_documento,
        @cd_usuario              = cd_usuario
      from
        deleted

      exec pr_atualiza_informacao_comercial @ic_parametro,
                                            @cd_cliente,
                                            @vl_documento_receber,
                                            @dt_emissao_documento,
                                            @dt_vencimento_documento,
                                            0,
                                            0,
                                            @cd_usuario
    end

end


GO


create  trigger tI_documento_receber_informacao_comercial
on Documento_Receber
after insert
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização da tabela Cliente_Informacao_Credito após
--          inclusão em documento_receber
--Data: 20/03/2002
--Atualizado: 02/04/2002 - Migração p/ EGISSQL
--            12/05/2002 - Mudança de nome p/padrão GBS
---------------------------------------------------
as
begin
  
  declare @ic_parametro            int
  declare @cd_cliente              int
  declare @vl_documento_receber    float
  declare @dt_emissao_documento    datetime
  declare @dt_vencimento_documento datetime
  declare @cd_usuario              int
  
  -- parametro de atualização de um único cliente na inclusão de documento
  set @ic_parametro = 1

  -- carrega as variáveis p/ execução da stored procedure de atualização
  select
    @cd_cliente              = cd_cliente,
    @vl_documento_receber    = vl_documento_receber,
    @dt_emissao_documento    = dt_emissao_documento,
    @dt_vencimento_documento = dt_vencimento_documento,
    @cd_usuario              = cd_usuario
  from
    inserted

  If Exists ( select 'x' from inserted)
    exec pr_atualiza_informacao_comercial @ic_parametro,
                                          @cd_cliente,
                                          @vl_documento_receber,
                                          @dt_emissao_documento,
                                          @dt_vencimento_documento,
                                          0,
                                          0,
                                          @cd_usuario

end



GO

create trigger tU_documento_receber_informacao_comercial
on Documento_Receber
after update
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização da tabela Cliente_Informacao_Credito após
--          modificações em documento_receber
--Data: 20/03/2002
--Atualizado: 02/04/2002 - Migração p/ EGISSQL - Elias
--            12/06/2002 - Mudança de nome p/ padão GBS  
--            27/09/2002 - Não executa caso Inserted for vazia - ELIAS        
--            30/09/2002 - Acertos - ELIAS
---------------------------------------------------
as
begin

  declare @ic_parametro            int
  declare @cd_cliente              int
  declare @vl_documento_receber    float
  declare @dt_emissao_documento    datetime
  declare @dt_vencimento_documento datetime
  declare @cd_usuario              int

  -- parametro de atualização de um único cliente
  set @ic_parametro = 1

  -- carrega as variáveis p/ execução da stored procedure de atualização
  select 
    @cd_cliente              = cd_cliente,
    @vl_documento_receber    = vl_documento_receber,
    @dt_emissao_documento    = dt_emissao_documento,
    @dt_vencimento_documento = dt_vencimento_documento,
    @cd_usuario              = cd_usuario
  from 
    Inserted

  If exists (select 'X' from Inserted)
      exec pr_atualiza_informacao_comercial @ic_parametro,
                                            @cd_cliente,
                                            @vl_documento_receber,
                                            @dt_emissao_documento,
                                            @dt_vencimento_documento,
                                            0,
                                            0,
                                            @cd_usuario

end

