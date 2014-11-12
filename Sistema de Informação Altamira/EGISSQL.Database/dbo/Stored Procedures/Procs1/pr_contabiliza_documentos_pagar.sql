
CREATE PROCEDURE pr_contabiliza_documentos_pagar
@dt_inicial datetime,
@dt_final   datetime

with recompile

as

begin

  declare @ic_novo_padrao char(1)

  -- Verifica se é para manter o padrão antigo de pesquisa - POLIMOLD
  if exists(select 'x' from egisadmin.dbo.empresa 
            where cd_empresa = dbo.fn_empresa() and nm_empresa like '%POLIMOLD%')
    set @ic_novo_padrao = 'N'
  else
    set @ic_novo_padrao = 'S'

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_pagar_pagamento' 
	   AND 	  type = 'U')
    truncate table #documento_pagar_pagamento

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_pagar_pagamento_juros' 
	   AND 	  type = 'U')
    truncate table #documento_pagar_pagamento_juros

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_pagar_pagamento_desconto' 
	   AND 	  type = 'U')
    truncate table #documento_pagar_pagamento_desconto

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_pagar_pagamento_abatimento' 
	   AND 	  type = 'U')
    truncate table #documento_pagar_pagamento_abatimento

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_pagar_pagamento_abatimento_total' 
	   AND 	  type = 'U')
    truncate table #documento_pagar_pagamento_abatimento_total

  -- tabela temporária c/ os pagamentos

  select 
    p.cd_documento_pagar,
    p.dt_pagamento_documento,
    p.cd_identifica_documento, 
    p.cd_item_pagamento,
    p.cd_tipo_pagamento,
    lp.cd_lancamento_padrao,
    cast((isnull(cast(str(p.vl_pagamento_documento,25,2) as decimal(25,2)),0) +
     IsNull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) - 
     isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) -
     isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0)) as decimal(25,2))as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2))          as 'vl_juros_documento_pagar',
    cast(0.00 as decimal(25,2))          as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2))          as 'vl_abatimento_documento',
    isnull(lp.cd_conta_debito,0)         as 'cd_conta_debito',
    --Verifica se existe a conta para crédito no plano financeiro
    case when isnull(pf.cd_conta,0)>0 then
      pf.cd_conta
    else
      isnull(lp.cd_conta_credito,0)
    end                                  as 'cd_conta_credito',
    isnull(hc.nm_historico_contabil,'')  as 'nm_historico',
    isnull(lp.cd_historico_contabil,0)   as 'cd_historico',
    isnull(lp.cd_conta_debito_padrao,0)  as 'cd_reduzido_conta_debito',
    isnull(lp.cd_conta_credito_padrao,0) as 'cd_reduzido_conta_credito'

--select * from lancamento_padrao
   
  into
    #documento_pagar_pagamento	
  from 
    documento_pagar_pagamento p             with (nolock) 
    inner join documento_pagar d            with (nolock) on d.cd_documento_pagar  = p.cd_documento_pagar
    inner join tipo_conta_pagar t           with (nolock) on d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
    left outer join conta_agencia_banco cab with (nolock) on cab.cd_conta_banco    = p.cd_conta_banco
    left outer join tipo_pagamento_contabilizacao tpc     on 
      isnull(tpc.cd_tipo_pagamento,0)   = case when (isnull(p.cd_tipo_pagamento,0)<>0) then p.cd_tipo_pagamento else isnull(tpc.cd_tipo_pagamento,0) end and
      isnull(tpc.cd_tipo_conta_pagar,0) = case when (isnull(d.cd_tipo_conta_pagar,0) <> 0) then d.cd_tipo_conta_pagar else isnull(tpc.cd_tipo_conta_pagar,0) end and
      isnull(cab.cd_banco,0)            = case when (isnull(tpc.cd_banco,0)<>0) then isnull(tpc.cd_banco,0) else isnull(cab.cd_banco,0) end
    left outer join lancamento_padrao lp  on isnull(tpc.cd_lancamento_pagamento,0) = isnull(lp.cd_lancamento_padrao,0)

    left outer join historico_contabil hc on isnull(lp.cd_historico_contabil,0) = isnull(hc.cd_historico_contabil,0)

    left outer join plano_financeiro pf   on pf.cd_plano_financeiro = d.cd_plano_financeiro

  where
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
    isnull(t.ic_razao_contabil,'N') = 'S'


--select * from #documento_pagar_pagamento

  -- tabela temporária c/ os juros

  select
    p.cd_documento_pagar,
    p.dt_pagamento_documento,
    p.cd_identifica_documento,
    p.cd_item_pagamento,
    p.cd_tipo_pagamento,
    lp.cd_lancamento_padrao,
    cast(0.00 as decimal(25,2))          as 'vl_pagamento_documento',
    cast(p.vl_juros_documento_pagar as decimal(25,2)) as 'vl_juros_documento_pagar',
    cast(0.00 as decimal(25,2))          as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2))          as 'vl_abatimento_documento',
    isnull(lp.cd_conta_debito,0)         as 'cd_conta_debito',
    isnull(lp.cd_conta_credito,0)        as 'cd_conta_credito',
    isnull(hc.nm_historico_contabil,'')  as 'nm_historico',
    isnull(lp.cd_historico_contabil,0)   as 'cd_historico',
    isnull(lp.cd_conta_debito_padrao,0)  as 'cd_reduzido_conta_debito',
    isnull(lp.cd_conta_credito_padrao,0) as 'cd_reduzido_conta_credito'

  into
    #documento_pagar_pagamento_juros
  from 
    documento_pagar_pagamento p   with (nolock) 
    inner join documento_pagar d  with (nolock) on d.cd_documento_pagar = p.cd_documento_pagar
    inner join tipo_conta_pagar t with (nolock) on d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
    left outer join conta_agencia_banco cab with (nolock) on cab.cd_conta_banco = p.cd_conta_banco
    left outer join tipo_pagamento_contabilizacao tpc with (nolock) on 
      isnull(tpc.cd_tipo_pagamento,0) = case when (isnull(p.cd_tipo_pagamento,0)<>0) then p.cd_tipo_pagamento else isnull(tpc.cd_tipo_pagamento,0) end and
      isnull(tpc.cd_tipo_conta_pagar,0) = case when (isnull(d.cd_tipo_conta_pagar,0) <> 0) then d.cd_tipo_conta_pagar else isnull(tpc.cd_tipo_conta_pagar,0) end and
      isnull(cab.cd_banco,0) = case when (isnull(tpc.cd_banco,0)<>0) then isnull(tpc.cd_banco,0) else isnull(cab.cd_banco,0) end
    left outer join lancamento_padrao lp with (nolock) on
      isnull(tpc.cd_lancamento_juros,0) = isnull(lp.cd_lancamento_padrao,0)
    left outer join historico_contabil hc with (nolock) on
      isnull(lp.cd_historico_contabil,0) = isnull(hc.cd_historico_contabil,0)
  where
    isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0.00 and
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
    isnull(t.ic_razao_contabil,'N') = 'S'

  -- tabela temporária c/ o desconto

  select 
    p.cd_documento_pagar,
    p.dt_pagamento_documento,
    p.cd_identifica_documento, 
    p.cd_item_pagamento,
    p.cd_tipo_pagamento,
    lp.cd_lancamento_padrao,
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_documento_pagar',
    cast(p.vl_desconto_documento as decimal(25,2)) as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2))          as 'vl_abatimento_documento',
    isnull(lp.cd_conta_debito,0)         as 'cd_conta_debito',
    isnull(lp.cd_conta_credito,0)        as 'cd_conta_credito',
    isnull(hc.nm_historico_contabil,'')  as 'nm_historico',
    isnull(lp.cd_historico_contabil,0)   as 'cd_historico',
    isnull(lp.cd_conta_debito_padrao,0)  as 'cd_reduzido_conta_debito',
    isnull(lp.cd_conta_credito_padrao,0) as 'cd_reduzido_conta_credito'

  into
    #documento_pagar_pagamento_desconto
  from 
    documento_pagar_pagamento p 
    inner join documento_pagar d on d.cd_documento_pagar = p.cd_documento_pagar
    inner join tipo_conta_pagar t on d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
    left outer join conta_agencia_banco cab on cab.cd_conta_banco = p.cd_conta_banco
    left outer join tipo_pagamento_contabilizacao tpc on 
      isnull(tpc.cd_tipo_pagamento,0) = case when (isnull(p.cd_tipo_pagamento,0)<>0) then p.cd_tipo_pagamento else isnull(tpc.cd_tipo_pagamento,0) end and
      isnull(tpc.cd_tipo_conta_pagar,0) = case when (isnull(d.cd_tipo_conta_pagar,0) <> 0) then d.cd_tipo_conta_pagar else isnull(tpc.cd_tipo_conta_pagar,0) end and
      isnull(cab.cd_banco,0) = case when (isnull(tpc.cd_banco,0)<>0) then isnull(tpc.cd_banco,0) else isnull(cab.cd_banco,0) end
    left outer join lancamento_padrao lp on
      isnull(tpc.cd_lancamento_desconto,0) = isnull(lp.cd_lancamento_padrao,0)
    left outer join historico_contabil hc on
      isnull(lp.cd_historico_contabil,0) = isnull(hc.cd_historico_contabil,0)
  where
    isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0.00 and
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
    isnull(t.ic_razao_contabil,'N') = 'S'

  -- tabela temporária c/ o abatimento

  select 
    p.cd_documento_pagar,
    p.dt_pagamento_documento,
    p.cd_identifica_documento, 
    p.cd_item_pagamento,
    p.cd_tipo_pagamento,
    lp.cd_lancamento_padrao,
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_documento_pagar',
    cast(0.00 as decimal(25,2)) as 'vl_desconto_documento',
    cast(p.vl_abatimento_documento as decimal(25,2)) as 'vl_abatimento_documento',
    isnull(lp.cd_conta_debito,0)         as 'cd_conta_debito',
    isnull(lp.cd_conta_credito,0)        as 'cd_conta_credito',
    isnull(hc.nm_historico_contabil,'')  as 'nm_historico',
    isnull(lp.cd_historico_contabil,0)   as 'cd_historico',
    isnull(lp.cd_conta_debito_padrao,0)  as 'cd_reduzido_conta_debito',
    isnull(lp.cd_conta_credito_padrao,0) as 'cd_reduzido_conta_credito'

  into
    #documento_pagar_pagamento_abatimento
  from
    documento_pagar_pagamento p 
    inner join documento_pagar d on d.cd_documento_pagar = p.cd_documento_pagar
    inner join tipo_conta_pagar t on d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar 
    left outer join conta_agencia_banco cab on cab.cd_conta_banco = p.cd_conta_banco
    left outer join tipo_pagamento_contabilizacao tpc on 
      isnull(tpc.cd_tipo_pagamento,0) = case when (isnull(p.cd_tipo_pagamento,0)<>0) then p.cd_tipo_pagamento else isnull(tpc.cd_tipo_pagamento,0) end and
      isnull(tpc.cd_tipo_conta_pagar,0) = case when (isnull(d.cd_tipo_conta_pagar,0) <> 0) then d.cd_tipo_conta_pagar else isnull(tpc.cd_tipo_conta_pagar,0) end and
      isnull(cab.cd_banco,0) = case when (isnull(tpc.cd_banco,0)<>0) then isnull(tpc.cd_banco,0) else isnull(cab.cd_banco,0) end
    left outer join lancamento_padrao lp on
      isnull(tpc.cd_lancamento_abatimento,0) = isnull(lp.cd_lancamento_padrao,0)
    left outer join historico_contabil hc on
      isnull(lp.cd_historico_contabil,0) = isnull(hc.cd_historico_contabil,0)
  where
    isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0.00 and
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
    isnull(t.ic_razao_contabil,'N') = 'S'

  -- tabela temporária c/ os abatimentos e descontos totais

  select
    d.cd_documento_pagar,
    d.dt_vencimento_documento as 'dt_pagamento_documento',
    d.cd_identificacao_document as 'cd_identifica_documento',
    0 as 'cd_item_pagamento',
    999 as 'cd_tipo_pagamento',
    0 as 'cd_lancamento_padrao',
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_documento_pagar',
    cast(0.00 as decimal(25,2)) as 'vl_desconto_documento',
    cast((d.vl_abatimento_documento + d.vl_desconto_documento) as decimal(25,2)) as 'vl_abatimento_documento',
    0 as 'cd_conta_debito',
    0 as 'cd_conta_credito',
    cast('' as varchar(40)) as 'nm_historico',
    0 as 'cd_historico',
    0 as 'cd_conta_debito_padrao',
    0 as 'cd_conta_credito_padrao'

--select * from lancamento_padrao

  into
    #documento_pagar_pagamento_abatimento_total
  from 
    tipo_conta_pagar t,
    documento_pagar d
  where
    (cast(str((d.vl_abatimento_documento + d.vl_desconto_documento),25,2) as decimal(25,2)) =
    cast(str(d.vl_documento_pagar,25,2) as decimal(25,2))) and
    (d.dt_vencimento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar and
    isnull(t.ic_razao_contabil,'N') = 'S'
    
  -- junção das tabelas temporárias

  insert into
    #Documento_pagar_pagamento
  select
   *
  from
    #documento_pagar_pagamento_juros

  insert into
    #Documento_pagar_pagamento
  select 
    *
  from
    #documento_pagar_pagamento_desconto

  insert into
    #Documento_pagar_pagamento
  select 
    *
  from
    #documento_pagar_pagamento_abatimento

  insert into
    #Documento_pagar_pagamento
  select 
    *
  from
    #documento_pagar_pagamento_abatimento_total

  
  -- inclusão da classificação e do histórico

  select
    identity(int,1,1)                                as cd_item,
    d.cd_documento_pagar,
    p.cd_lancamento_padrao,
    p.dt_pagamento_documento,
    p.cd_item_pagamento,
    cast(d.cd_identificacao_document as varchar(30)) as 'Documento',
    case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
         when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))
         when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))
         when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))
    end                             as 'Fornecedor', 
    p.dt_pagamento_documento        as 'Pagamento',

    case when @ic_novo_padrao = 'S' 
    then p.cd_conta_debito
    else
      case when isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0 then 5977 else
           case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then null else
                case when d.dt_cancelamento_documento is not null then 0 
                     else null end 
                end
           end
    end as 'Debito',

    case when @ic_novo_padrao = 'S' then p.cd_conta_credito else
      case when isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0 then null else
           case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then 6267 else
                case when d.dt_cancelamento_documento is not null then 1134 
                     else 141 end
                end   
           end                        
    end as 'Credito',

    case when isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0 then cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)) else
         case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)) + cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)) else
              case when d.dt_cancelamento_documento is not null then cast(str(d.vl_documento_pagar,25,2) as decimal(25,2))
                   else cast(str(p.vl_pagamento_documento,25,2) as decimal(25,2)) end
              end
         end                        as 'Total',


    case when @ic_novo_padrao = 'S' then p.cd_historico else
      case when isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0 then 918 else
           case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then 833 else
                case when d.dt_cancelamento_documento is not null then 462 else
                     case when p.cd_tipo_pagamento = 2 then 20 else 711 end
                     end
                end
           end                        
    end as 'Historico',

    case when @ic_novo_padrao = 'S' then
      case when (rtrim(p.nm_historico) = '') then rtrim(d.cd_identificacao_document)+' '+rtrim(d.nm_fantasia_fornecedor)+' em '+isnull(convert(varchar,p.dt_pagamento_documento,103),'')
        else rtrim(p.nm_historico)+' '+rtrim(d.cd_identificacao_document)+' '+rtrim(d.nm_fantasia_fornecedor)+' em '+isnull(convert(varchar,p.dt_pagamento_documento,103),'')
        end 
    else 
      case when isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0 then 'DUPL '+rtrim(d.cd_identificacao_document)+'-'+d.nm_fantasia_fornecedor else
           case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then 'DUPL '+rtrim(d.cd_identificacao_document)+'-'+d.nm_fantasia_fornecedor else
                case when d.dt_cancelamento_documento is not null then 'S/NF.......... N/NF'+d.cd_identificacao_document else
                     case when p.cd_tipo_pagamento = 2 then 'CHQ. '+rtrim(p.cd_identifica_documento)+' de '+convert(char(10), p.dt_pagamento_documento, 103) else
                          case when p.cd_tipo_pagamento = 1 then 'BORDERO PAGAMENTO N. '+rtrim(p.cd_identifica_documento) 
                               else (select rtrim(sg_tipo_pagamento) from tipo_pagamento_documento where cd_tipo_pagamento = p.cd_tipo_pagamento)+' N. '+p.cd_identifica_documento end end
                     end
                end
           end 
    end as 'DescHistorico',
    
    case when isnull(cast(str(p.vl_juros_documento_pagar,25,2) as decimal(25,2)),0) <> 0 then p.vl_juros_documento_pagar
         when isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0 then p.vl_desconto_documento
         when isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0 then p.vl_abatimento_documento 
         when d.dt_cancelamento_documento is not null then 0
    else cast(str(d.vl_documento_pagar,25,2) as decimal(25,2))
    end                       as 'vl_documento_pagar',  -- Adicionado por Carrasco.

    p.cd_tipo_pagamento       as 'TipoPagamento',
    p.cd_identifica_documento as 'DocPagamento',
    p.cd_reduzido_conta_debito,
    p.cd_reduzido_conta_credito

  into
    #Documento_Contabil
  from  
    tipo_conta_pagar t,  
    documento_pagar d,
    #documento_pagar_pagamento p
  where
    d.cd_documento_pagar = p.cd_documento_pagar and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) and
    d.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar and
    isnull(t.ic_razao_contabil,'N') = 'S'
  order by
    TipoPagamento,
    Pagamento,
    DocPagamento,
    Fornecedor,
    Documento        

  -- Consulta para o Relatório de Contabilização

  select
    Documento,
    Fornecedor, 
    Pagamento,
    Debito,
    Credito,
    Total,
    Historico,
    DescHistorico,
    vl_documento_pagar, 
    TipoPagamento,
    DocPagamento,
    cd_reduzido_conta_debito,
    cd_reduzido_conta_credito
  
  from #Documento_Contabil

  -- Preenche a Tabela de Contabilização de Documentos a Pagar   
  delete from documento_pagar_contabil
  where cd_documento_pagar in (select cd_documento_pagar from #Documento_Contabil)
  
  insert into documento_pagar_contabil 
    (cd_documento_pagar, cd_item_contab_documento, cd_item_pagamento, dt_contab_documento,
     cd_lancamento_padrao, cd_conta_debito, cd_conta_credito, vl_contab_documento,
     cd_historico_contabil, nm_historico_documento, ic_sct_contab_documento,
     dt_sct_contab_documento, cd_lote_contabil, cd_usuario, dt_usuario,
     cd_reduzido_conta_debito,
     cd_reduzido_conta_credito)
  select
    distinct
    cd_documento_pagar, cd_item, cd_item_pagamento, dt_pagamento_documento,
    cd_lancamento_padrao, Debito, Credito, vl_documento_pagar,
    Historico, cast(DescHistorico as varchar(40)), 'N',
    null, null, 0, getDate(),
    cd_reduzido_conta_debito,
    cd_reduzido_conta_credito

  from
    #Documento_Contabil
    
end


