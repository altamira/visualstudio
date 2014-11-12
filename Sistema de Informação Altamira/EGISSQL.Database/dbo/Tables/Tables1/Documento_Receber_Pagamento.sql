CREATE TABLE [dbo].[Documento_Receber_Pagamento] (
    [cd_documento_receber]      INT          NOT NULL,
    [cd_item_documento_receber] INT          NOT NULL,
    [dt_pagamento_documento]    DATETIME     NULL,
    [vl_pagamento_documento]    FLOAT (53)   NULL,
    [vl_juros_pagamento]        FLOAT (53)   NULL,
    [vl_desconto_documento]     FLOAT (53)   NULL,
    [vl_abatimento_documento]   FLOAT (53)   NULL,
    [vl_despesa_bancaria]       FLOAT (53)   NULL,
    [cd_recibo_documento]       VARCHAR (20) NULL,
    [ic_tipo_abatimento]        CHAR (1)     NULL,
    [ic_tipo_liquidacao]        CHAR (1)     NULL,
    [vl_reembolso_documento]    FLOAT (53)   NULL,
    [vl_credito_pendente]       FLOAT (53)   NULL,
    [ic_desconto_comissao]      CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_obs_documento]          VARCHAR (60) NULL,
    [dt_fluxo_doc_rec_pagament] DATETIME     NULL,
    [dt_fluxo_doc_rec_pagto]    DATETIME     NULL,
    [dt_pagto_contab_documento] DATETIME     NULL,
    [cd_tipo_liquidacao]        INT          NULL,
    [cd_banco]                  INT          NULL,
    [cd_conta_banco]            INT          NULL,
    [cd_lancamento]             INT          NULL,
    [cd_tipo_caixa]             INT          NULL,
    [cd_lancamento_caixa]       INT          NULL,
    CONSTRAINT [PK_Documento_Receber_Pagamento] PRIMARY KEY CLUSTERED ([cd_documento_receber] ASC, [cd_item_documento_receber] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_pagamento_documento]
    ON [dbo].[Documento_Receber_Pagamento]([dt_pagamento_documento] ASC) WITH (FILLFACTOR = 90);


GO

--1
CREATE  trigger tI_documento_receber_pagamento_informacao_comercial
on Documento_Receber_Pagamento
after insert
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização da tabela Cliente_Informacao_Credito após
--          inserção em documento_receber_pagamento
--Data: 20/03/2002
--Atualizado: 02/04/2002 - Migração p/ EGISSQL - Elias
--            12/06/2002 - Mundaça de nome p/ padrao GBS - Elias

---------------------------------------------------
as
begin
  
  declare @ic_parametro            int
  declare @cd_cliente              int
  declare @vl_documento_receber    float
  declare @dt_emissao_documento    datetime
  declare @dt_vencimento_documento datetime
  declare @cd_usuario              int
  
  -- parametro de atualização de um único cliente na inclusão de pagamento
  set @ic_parametro = 1

  -- carrega as variáveis p/ execução da stored procedure de atualização
  select
    @cd_cliente              = d.cd_cliente,
    @vl_documento_receber    = d.vl_documento_receber,
    @dt_emissao_documento    = d.dt_emissao_documento,
    @dt_vencimento_documento = d.dt_vencimento_documento,
    @cd_usuario              = p.cd_usuario
  from
    inserted p,
    documento_receber d
  where
    p.cd_documento_receber = d.cd_documento_receber

  If exists(select 'x' from inserted)
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

create  trigger tD_documento_receber_pagamento_informacao_comercial
on Documento_Receber_Pagamento
after delete
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização da tabela Cliente_Informacao_Credito após
--          deleção de documento_receber_pagamento
--Data: 20/03/2002
--Atualizado: 02/04/2002 - Migração p/ EGISSQL - Elias
--            12/06/2002 - Mudança de nome p/ padrao GBS
--            22/05/2003 - Acerto. - Daniel C. Neto.
---------------------------------------------------
as
begin
  
  declare @ic_parametro            int
  declare @cd_cliente              int
  declare @vl_documento_receber    float
  declare @dt_emissao_documento    datetime
  declare @dt_vencimento_documento datetime
  declare @cd_usuario              int
  
  -- parametro de atualização de um único cliente na deleção de pagamento
  set @ic_parametro = 2

  -- carrega as variáveis p/ execução da stored procedure de atualização
  select
    @cd_cliente              = d.cd_cliente,
    @vl_documento_receber    = d.vl_documento_receber,
    @dt_emissao_documento    = d.dt_emissao_documento,
    @dt_vencimento_documento = d.dt_vencimento_documento,
    @cd_usuario              = p.cd_usuario
  from
    deleted p,
    documento_receber d
  where
    p.cd_documento_receber = d.cd_documento_receber

   If Exists( Select 'X' from Deleted)
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

create trigger tU_documento_receber_pagamento_informacao_comercial
on Documento_Receber_Pagamento
after update
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: SapSql
--Objetivo: Trigger para atualização da tabela Cliente_Informacao_Credito após
--          atualização em documento_receber_pagamento
--Data: 20/03/2002
--Atualizado: 02/04/2002 - Migração p/ EGISSQL - Elias
--            12/06/2002 - Mudança de nome p/ padrao GBS - Elias

---------------------------------------------------
as
begin
  
  declare @ic_parametro            int
  declare @cd_cliente              int
  declare @vl_documento_receber    float
  declare @dt_emissao_documento    datetime
  declare @dt_vencimento_documento datetime
  declare @cd_usuario              int
  
  -- parametro de atualização de um único cliente na atualizacao de pagamento
  set @ic_parametro = 2

  -- carrega as variáveis p/ execução da stored procedure de atualização
  --Para a trigger, não existe a tabela updated e sim se referencia a tabela
  -- inserted para pegar os valores inseridos.
  select
    @cd_cliente              = d.cd_cliente,
    @vl_documento_receber    = d.vl_documento_receber,
    @dt_emissao_documento    = d.dt_emissao_documento,
    @dt_vencimento_documento = d.dt_vencimento_documento,
    @cd_usuario              = p.cd_usuario
  from
    Inserted p,
    documento_receber d
  where
    p.cd_documento_receber = d.cd_documento_receber

  If exists(select 'x' from Inserted)
    exec pr_atualiza_informacao_comercial @ic_parametro,
                                          @cd_cliente,
                                          @vl_documento_receber,
                                          @dt_emissao_documento,
                                          @dt_vencimento_documento,
                                          0,
                                          0,
                                          @cd_usuario

end

