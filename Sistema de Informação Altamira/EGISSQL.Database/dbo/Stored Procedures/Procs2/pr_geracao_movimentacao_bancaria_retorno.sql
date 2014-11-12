
-------------------------------------------------------------------------------
--pr_geracao_movimentacao_bancaria_retorno
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes / Alexandre Rogério de Assis
--Banco de Dados   : Egissql
--Objetivo         : Geração da Movimentação do documento a receber na movimentação
--                   do Banco do retorno
--Data             : 02.03.2006
--Alteração        : 02.03.2006 
--                 : 03.06.2007
-- 05.06.2009 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_geracao_movimentacao_bancaria_retorno
@cd_documento_receber       int           = 0,
@cd_item_documento_receber  int           = 0,
@cd_conta_banco             int           = 0,
@dt_retorno                 datetime      = '',
@dt_credito                 datetime      = '',
@vl_recebido                decimal(25,2) = '',
@cd_plano_financeiro        int           = 0,
@cd_moeda                   int           = 0,
@cd_usuario                 int           = 0,
@cd_conta_banco_remessa     int           = 0,
@cd_identificacao           varchar(15)   = ''
as

  declare @Tabela		     varchar(80)
  declare @cd_lancamento             int 

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Conta_Banco_Lancamento' as varchar(50))
  
--	    	    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output	     
--		        -- limpeza da tabela de código
--	    	    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'


------------------------------------------------------------------------------
--Atualização individual do Documento no Banco
------------------------------------------------------------------------------

--select * from conta_banco_lancamento

if isnull(@cd_documento_receber,0)<>0
begin

   --Gera o Código do Lançamento no Banco
   exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output	     
  
   insert 
    into Conta_Banco_Lancamento
    (cd_lancamento, 
     dt_lancamento,
     vl_lancamento,
     nm_historico_lancamento, 
     cd_conta_banco, 
     cd_plano_financeiro, 
     cd_tipo_operacao, 
     cd_historico_financeiro, 
     cd_moeda,
     cd_usuario, 
     dt_usuario, 
     cd_tipo_lancamento_fluxo, 
     ic_lancamento_conciliado, 
     ic_transferencia_conta, 
     cd_empresa,
     cd_documento,
     cd_documento_receber,
     cd_documento_baixa)
  values
    (@cd_lancamento, 
     @dt_credito,
     @vl_recebido, 
     'Retorno Banco '+@cd_identificacao, 
     case when @cd_conta_banco_remessa>0 then @cd_conta_banco_remessa else @cd_conta_banco end, 
     @cd_plano_financeiro, 
     1, --Entrada
     0, 
     @cd_moeda, 
     @cd_usuario, 
     getdate(),
     2, 
     'N', 
     'N', 
     dbo.fn_empresa(), --Empresa 
     @cd_documento_receber,
     @cd_documento_receber,
     @cd_item_documento_receber ) 

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'

-- 
-- --Atualiza o documento receber pago com o número do Lançamento
-- update
--    documento_receber_pagamento
-- set
--    cd_lancamento = :cd_lancamento
-- where
--    cd_documento_receber = :cd_documento_receber and
--    cd_item_documento_receber = :cd_item_documento_receber

end
else
begin
  --Sintético
  print 'terminar'
end

