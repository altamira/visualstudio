
create procedure pr_selecao_documento_pagar_banco
@ic_parametro         int,      -- tipo de operação executada p/ esta stored procedure
@dt_envio             datetime, -- data de envio p/ banco
@cd_documento_pagar   int,      -- código do documento p/ envio p/ banco
@cd_portador          int,      -- código do portador p/ envio
@cd_conta_banco       int = 0,  -- Codigo da conta do banco.  
@cd_tipo_pagto_eletronico int = 0,
@cd_forma_pagto_eletronica int = 0
as

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Listar os Documentos à Pagar p/ seleção
-------------------------------------------------------------------------------
  begin

    declare @qt_dias_envio      int -- qtde de dias p/ envio
    declare @qt_dias_vencimento int -- qtde de dias entre emissão e vencimento

    -- alterar futuramente o carregamento destas variáveis
    -- informações deverão ser configuradas em parametro_empresa

    set @qt_dias_envio = 2
    set @qt_dias_vencimento = 10
  
    select 
      distinct
      0                            as 'Enviar', 
      p.dt_vencimento_documento    as 'Vencimento',
      case when ((p.dt_vencimento_documento - p.dt_emissao_documento_paga) < @qt_dias_vencimento) then 
        'S'
      else case when (@dt_envio < (p.dt_emissao_documento_paga + @qt_dias_envio)) then 
        'N' 
      else
        'S' end end                as 'Status',
      p.cd_fornecedor              as 'CodFornecedor',
      p.cd_portador,
      p.nm_fantasia_fornecedor     as 'NomeFornecedor',
      p.vl_documento_pagar         as 'VlrDocumento',
      p.cd_identificacao_document  as 'IdentDocumento',
      p.cd_documento_pagar         as 'CodIntDocumento',
      p.dt_emissao_documento_paga  as 'Emissao',
      LTrim(Rtrim(B.nm_codigo_barra_documento)) as nm_codigo_barra_documento,
      case 
        when (@dt_envio < (p.dt_emissao_documento_paga + @qt_dias_envio)) then 'Emissão < que '+cast(@qt_dias_envio as varchar(2))+' dias do envio.'
        when ((p.dt_vencimento_documento - p.dt_emissao_documento_paga) < @qt_dias_vencimento) then 'Vencimento < que '+cast(@qt_dias_vencimento as varchar(2))+' dias da emissão.'        
      else null 
      end as 'Observacao'
    from 
      Documento_Pagar p left join
		documento_pagar_cod_barra B on (p.cd_documento_pagar = B.cd_documento_pagar)
    where    
--      p.cd_portador   = 999                     and
      isnull(p.dt_cancelamento_documento,'')='' and
      isnull(p.dt_devolucao_documento,'')=''    and 
      isnull(p.vl_saldo_documento_pagar,0) > 0  and
      isnull(p.ic_envio_documento,'N')= 'N' 
    order by
      Vencimento,
      IdentDocumento,
      NomeFornecedor
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Configuração do registro p/ envio 
-------------------------------------------------------------------------------
  begin
    update
      Documento_Pagar
    set
      ic_envio_documento        = 'S',
      cd_portador               = @cd_portador,
      dt_selecao_documento      = getdate(),
      cd_conta_banco_pagamento  = @cd_conta_banco,
		cd_tipo_pagto_eletronico  = @cd_tipo_pagto_eletronico,
		cd_forma_pagto_eletronica = @cd_forma_pagto_eletronica
    where
      cd_documento_pagar     = @cd_documento_pagar
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Acerto do Documento para nova Remessa 
-------------------------------------------------------------------------------
  begin
    update Documento_Pagar 
    set
       ic_envio_documento       ='N',
       cd_portador              = 999,  
       dt_envio_banco_documento = null,
       dt_selecao_documento     = null
    where 
      dt_envio_banco_documento between @dt_envio and @dt_envio+1 and
      cd_portador = @cd_portador   and
      vl_saldo_documento_pagar>0         
  end     
