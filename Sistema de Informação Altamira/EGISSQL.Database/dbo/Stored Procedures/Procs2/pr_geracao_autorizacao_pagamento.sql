
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_autorizacao_pagamento
-------------------------------------------------------------------------------
--pr_geracao_autorizacao_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Autorização de Pagamento
--Data             : 19.05.2007
--Alteração        : 25.05.2007 - Acertos com novos campos
--                   26.05.2007 - Verificação Completa - Carlos Fernandes
--                   18.06.2007 - Saldo do Documento - Carlos Fernandes
--                   13.07.2007 - Verificação da Geração - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_geracao_autorizacao_pagamento
@ic_parametro    int = 0,
@cd_cheque_pagar int = 0,
@cd_usuario      int = 0,
@cd_ap_exclusao  int = 0

as

--Parâmetros 
--1: Geração Automática da AP para Cheque Pagar
--2: Exclusão Completa  da AP
--3: Consulta de Documentos a Pagar para Geração
--4: Geração Automática da Ap para Documentos a Pagar

  declare @Tabela		     varchar(50)
  declare @cd_ap                     int
  declare @cd_item_ap                int 
  declare @vl_ap                     float
  declare @ds_ap                     varchar(8000)

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Autorizacao_Pagamento' as varchar(50))

------------------------------------------------------------------------------
--Cheque Pagar
------------------------------------------------------------------------------

if @ic_parametro = 1 and @cd_cheque_pagar>0 
begin

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
	
  while exists(Select top 1 'x' from autorizacao_pagamento where cd_ap = @cd_ap)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'
  end
  
  select 
    @vl_ap = isnull(vl_cheque_pagar,0),
    @ds_ap = 'Chq.Pagar : '+cast(cd_cheque_pagar as varchar)
  from
    cheque_pagar
  where
    cd_cheque_pagar = @cd_cheque_pagar and
    isnull(cd_ap,0) = 0

   --Atualização do Cheque
     
   update
     cheque_pagar
   set
     cd_ap = @cd_ap
   where
     cd_cheque_pagar = @cd_cheque_pagar

   --Atualização de documentos a pagar

   update
     documento_pagar
   set
     cd_ap = @cd_ap
   where
     cd_cheque_pagar = @cd_cheque_pagar


------------------------------------------------------------------------------
--Geração da AP
------------------------------------------------------------------------------
--select * from tipo_autorizacao_pagamento

  select
    @cd_ap                             as cd_ap,
    convert(varchar, getdate(), 103)   as dt_ap,
    @ds_ap                             as ds_ap,
    null                     as dt_aprovacao_ap,
    @vl_ap                   as vl_ap,
    @cd_usuario              as cd_usuario,
    getdate()                as dt_usuario,
    null                     as cd_usuario_aprovacao,
    2                        as cd_tipo_ap,
    @cd_cheque_pagar         as cd_cheque_pagar,
    null                     as cd_requisicao_viagem,
    null                     as cd_solicitacao,
    null                     as cd_funcionario,
    null                     as cd_fornecedor,
    null                     as cd_documento_pagar,
    null                     as cd_prestacao,
    null                     as cd_item_adto_fornecedor,
    null                     as dt_pagamento_ap,
    null                     as cd_controle_folha
    
  into
    #ap

  insert into 
    autorizacao_pagamento
  select
    *
  from
    #ap

  --composicao

  select
    @cd_ap                                as cd_ap,
    cd_documento_pagar                    as cd_item_ap,
    null                                  as cd_tipo_documento,
    cd_documento_pagar                    as cd_documento_ap,
    @cd_usuario                           as cd_usuario,
    getdate()                             as dt_usuario,
    'D'                                   as ic_tipo_documento_ap,
    cd_identificacao_document             as cd_identificacao_documento
  into
    #autorizacao_pagto_composicao
  from
    documento_pagar dp
  where
    cd_cheque_pagar = @cd_cheque_pagar      

  --select * from #autorizacao_pagto_composicao
 
  insert into
    autorizacao_pagto_composicao 
  select
    *
  from
    #autorizacao_pagto_composicao

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'
 
end

------------------------------------------------------------------------------
--Exclusão Completa da AP para Cheque Pagar
------------------------------------------------------------------------------

if @ic_parametro = 2 and @cd_cheque_pagar>0 
begin

  --Busca o Número da AP

  select top 1 @cd_ap = isnull(cd_ap,0)
  from
   cheque_pagar 
  where
   cd_cheque_pagar = @cd_cheque_pagar

   --Atualização do Cheque

   update
     cheque_pagar
   set
     cd_ap = 0
   where
     cd_cheque_pagar = @cd_cheque_pagar

   --Atualização de documentos a pagar

   update
     documento_pagar
   set
     cd_ap     = 0,
     ic_sel_ap = 'N'
   where
     cd_cheque_pagar = @cd_cheque_pagar

   -- Deletando a Composição Autorização de Pagamento

   delete from autorizacao_pagto_composicao where cd_ap = @cd_ap
  
   -- Deletando a Autorização de Pagamento

   delete from autorizacao_pagamento        where cd_ap = @cd_ap


end

------------------------------------------------------------------------------
--Consulta / Exclusão
------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  --select * from documento_pagar

  select
    0                           as Sel,
    d.cd_documento_pagar,
    d.cd_identificacao_document,
    d.vl_saldo_documento_pagar,
    d.dt_vencimento_documento,
    d.dt_emissao_documento_paga,
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then   

          cast((select top 1 z.sg_empresa_diversa   
             from empresa_diversa z   
                where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
             
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then   
              cast((select top 1 w.nm_fantasia_fornecedor   
                from contrato_pagar w   
                  where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
  
           when (isnull(d.cd_funcionario, 0) <> 0) then   
              cast((select top 1 k.nm_funcionario   
                 from funcionario k   
                   where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then   
              cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',   
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then d.cd_empresa_diversa  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then d.cd_contrato_pagar  
           when (isnull(d.cd_funcionario, 0) <> 0) then d.cd_funcionario  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then d.cd_fornecedor  
      end                             as 'cd_favorecido_chave',  
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then 'E'  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then 'C'  
           when (isnull(d.cd_funcionario, 0) <> 0) then 'U'  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then 'F'   
      end                             as 'ic_tipo_favorecido'

  from
    documento_pagar d
  where
    isnull(d.cd_ap,0) = 0                           and
    round(isnull(d.vl_saldo_documento_pagar,0),2)>0 and
    d.dt_vencimento_documento is not null           and
    isnull(d.ic_sel_ap,'N') = 'N'
  order by
    d.dt_vencimento_documento

end

------------------------------------------------------------------------------
--Geração através de Seleção de Documentos
------------------------------------------------------------------------------

if @ic_parametro = 4
begin

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
	
  while exists(Select top 1 'x' from autorizacao_pagamento where cd_ap = @cd_ap)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_ap output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'
  end
  
  select 
    @vl_ap = sum( isnull(vl_saldo_documento_pagar,0.00) ),
    @ds_ap = 'Geração Documentos Diversos'
  from
    documento_pagar d
  where
    isnull(d.cd_ap,0) = 0 and
    isnull(d.vl_saldo_documento_pagar,0)>0 and
    d.dt_vencimento_documento is not null  and
    isnull(d.ic_sel_ap,'N')='S'            --selecionado para Geração de AP

------------------------------------------------------------------------------
--Geração da AP
------------------------------------------------------------------------------
--select * from tipo_autorizacao_pagamento
--select convert(varchar, getdate(), 103) as data
  select
    @cd_ap                           as cd_ap,
    convert(varchar, getdate(), 103) as dt_ap,
    @ds_ap                           as ds_ap,
    null                             as dt_aprovacao_ap,
    @vl_ap                           as vl_ap,
    @cd_usuario                      as cd_usuario,
    getdate()                        as dt_usuario,
    null                             as cd_usuario_aprovacao,
    1                                as cd_tipo_ap,
    null                             as cd_cheque_pagar,
    null                             as cd_requisicao_viagem,
    null                             as cd_solicitacao,
    null                             as cd_funcionario,
    null                             as cd_fornecedor,
    null                             as cd_documento_pagar,
    null                             as cd_prestacao,
    null                             as cd_item_adto_fornecedor,
    null                             as dt_pagamento_ap,
    null                             as cd_controle_folha
    
  into
    #apd

  insert into 
    autorizacao_pagamento
  select
    *
  from
    #apd

  --composicao

  select
    @cd_ap                                as cd_ap,
    cd_documento_pagar                    as cd_item_ap,
    null                                  as cd_tipo_documento,
    cd_documento_pagar                    as cd_documento_ap,
    @cd_usuario                           as cd_usuario,
    getdate()                             as dt_usuario,
    'D'                                   as ic_tipo_documento_ap,
    cd_identificacao_document             as cd_identificacao_documento
  into
    #autorizacao_pagto_composicaod
  from
    documento_pagar d
  where
    isnull(d.cd_ap,0) = 0 and
    isnull(d.vl_saldo_documento_pagar,0)>0 and
    d.dt_vencimento_documento is not null  and
    isnull(d.ic_sel_ap,'N')='S'            --selecionado para Geração de AP
  order by
    d.dt_vencimento_documento

  --select * from #autorizacao_pagto_composicao
 
  insert into
    autorizacao_pagto_composicao 
  select
    *
  from
    #autorizacao_pagto_composicaod

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_ap, 'D'

   --Atualização de documentos a pagar

   update
     documento_pagar
   set
     cd_ap = @cd_ap
   from
     documento_pagar d
   where
    isnull(d.cd_ap,0) = 0 and
    isnull(d.vl_saldo_documento_pagar,0)>0 and
    d.dt_vencimento_documento is not null  and
    isnull(d.ic_sel_ap,'N')='S'            --selecionado para Geração de AP

end

if @ic_parametro = 5
begin

  set @cd_ap = @cd_ap_exclusao

   -- Deletando a Composição Autorização de Pagamento

   delete from autorizacao_pagto_composicao where cd_ap = @cd_ap
  
   -- Deletando a Autorização de Pagamento

   delete from autorizacao_pagamento        where cd_ap = @cd_ap

end

