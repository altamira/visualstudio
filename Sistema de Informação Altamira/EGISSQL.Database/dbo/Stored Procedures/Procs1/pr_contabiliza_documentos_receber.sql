

CREATE PROCEDURE pr_contabiliza_documentos_receber
--------------------------------------------------------- 
--GBS - Global Business Solution              2002 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es) : Daniel C. Neto 
--Banco de Dados : EGISSQL 
--Objetivo      : Contabilização de Documentos a Receber.
--Data : 02/09/2002 
------------------------------------------------------------------------------ 

@dt_inicial datetime,
@dt_final   datetime

with recompile

as
begin

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_receber_pagamento' 
	   AND 	  type = 'U')
    truncate table #documento_receber_pagamento

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_receber_pagamento_juros' 
	   AND 	  type = 'U')
    truncate table #documento_receber_pagamento_juros

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_receber_pagamento_desconto' 
	   AND 	  type = 'U')
    truncate table #documento_receber_pagamento_desconto

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_receber_pagamento_abatimento' 
	   AND 	  type = 'U')
    truncate table #documento_receber_pagamento_abatimento

  IF EXISTS (SELECT name 
	   FROM   sysobjects 
	   WHERE  name = N'#documento_receber_pagamento_abatimento_total' 
	   AND 	  type = 'U')
    truncate table #documento_receber_pagamento_abatimento_total

  -- tabela temporária c/ os pagamentos
  select 
    p.cd_documento_receber,
    p.dt_pagamento_documento,
    d.cd_identificacao, 
    d.cd_tipo_liquidacao,
    cast((isnull(cast(str(p.vl_pagamento_documento,25,2) as decimal(25,2)),0) -
     (isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) +
      isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0))) as decimal(25,2))as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_pagamento',
    cast(0.00 as decimal(25,2)) as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2)) as 'vl_abatimento_documento'
  into
    #documento_receber_pagamento
  from 
    Documento_Receber d inner join
    Documento_Receber_Pagamento p on d.cd_documento_receber = p.cd_documento_receber 

  where
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final)

  -- tabela temporária c/ os juros
  select
    p.cd_documento_receber,
    p.dt_pagamento_documento,
    d.cd_identificacao,
    d.cd_tipo_liquidacao,
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(p.vl_juros_pagamento as decimal(25,2)) as 'vl_juros_pagamento',
    cast(0.00 as decimal(25,2)) as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2)) as 'vl_abatimento_documento'
  into
    #documento_receber_pagamento_juros
  from 
    Documento_Receber d inner join
    Documento_Receber_Pagamento p on d.cd_documento_Receber = p.cd_documento_receber
  where
    isnull(cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)),0) <> 0.00 and
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) 

  -- tabela temporária c/ o desconto
  select 
    p.cd_documento_receber,
    p.dt_pagamento_documento,
    d.cd_identificacao, 
    d.cd_tipo_liquidacao,
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_pagamento',
    cast(p.vl_desconto_documento as decimal(25,2)) as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2)) as 'vl_abatimento_documento'
  into
    #documento_receber_pagamento_desconto
  from 
    Documento_Receber d inner join
    documento_receber_pagamento p on d.cd_documento_receber = p.cd_documento_receber 
  where
    isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0.00 and
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final)

  -- tabela temporária c/ o abatimento
  select 
    p.cd_documento_receber,
    p.dt_pagamento_documento,
    d.cd_identificacao, 
    d.cd_tipo_liquidacao,
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_pagamento',
    cast(0.00 as decimal(25,2)) as 'vl_desconto_documento',
    cast(p.vl_abatimento_documento as decimal(25,2)) as 'vl_abatimento_documento'
  into
    #documento_receber_pagamento_abatimento
  from 
    documento_Receber d inner join 
    documento_Receber_pagamento p on d.cd_documento_receber = p.cd_documento_receber
  where
    isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0.00 and
    (p.dt_pagamento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final)

  -- tabela temporária c/ os abatimentos e descontos totais
  select
    d.cd_documento_receber,
    d.dt_vencimento_documento as 'dt_pagamento_documento',
    d.cd_identificacao,
    999 as 'cd_tipo_liquidacao',
    cast(0.00 as decimal(25,2)) as 'vl_pagamento_documento',
    cast(0.00 as decimal(25,2)) as 'vl_juros_pagamento',
    cast(0.00 as decimal(25,2)) as 'vl_desconto_documento',
    cast(0.00 as decimal(25,2)) as 'vl_abatimento_documento'

  into
    #documento_receber_pagamento_abatimento_total
  from 
    documento_receber d
  where
--    (cast(str((d.vl_abatimento_documento + d.vl_desconto_documento),25,2) as decimal(25,2)) =
--    cast(str(d.vl_documento_Receber,25,2) as decimal(25,2))) and
    (d.dt_vencimento_documento between @dt_inicial and @dt_final) and
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final) 
    
  -- junção das tabelas temporárias
  insert into
    #Documento_Receber_pagamento
  select
   *
  from
    #documento_Receber_pagamento_juros

  insert into
    #Documento_Receber_pagamento
  select 
    *
  from
    #documento_Receber_pagamento_desconto

  insert into
    #Documento_Receber_pagamento
  select 
    *
  from
    #documento_Receber_pagamento_abatimento

  insert into
    #Documento_Receber_pagamento
  select 
    *
  from
    #documento_receber_pagamento_abatimento_total


  -- inclusão da classificação e do histórico
  select
    d.cd_identificacao,
    cli.nm_fantasia_cliente as 'Cliente',
    p.dt_pagamento_documento        as 'Pagamento',
    case when isnull(cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)),0) <> 0 then 5977 else
         case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then null else
              case when d.dt_cancelamento_documento is not null then 0 
                   else null end 
              end
         end                        as 'Debito',
    case when isnull(cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)),0) <> 0 then null else
         case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then 6267 else
              case when d.dt_cancelamento_documento is not null then 1134 
                   else 141 end -- O QUE É ISSO AQUI???
              end   
         end                        as 'Credito',
    case when isnull(cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)),0) <> 0 then cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)) else
         case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)) + cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)) else
              case when d.dt_cancelamento_documento is not null then cast(str(d.vl_documento_receber,25,2) as decimal(25,2))
                   else cast(str(p.vl_pagamento_documento,25,2) as decimal(25,2)) end
              end
         end                        as 'Total',
    case when isnull(cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)),0) <> 0 then 918 else
         case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then 833 else
              case when d.dt_cancelamento_documento is not null then 462 else
                   case when p.cd_tipo_liquidacao = 2 then 20 else 711 end
                   end
              end
         end                        as 'Historico',
/*    case when isnull(cast(str(p.vl_juros_pagamento,25,2) as decimal(25,2)),0) <> 0 then 'DUPL '+rtrim(d.cd_identificacao_document)+'-'+d.nm_fantasia_fornecedor else
         case when ((isnull(cast(str(p.vl_desconto_documento,25,2) as decimal(25,2)),0) <> 0) or (isnull(cast(str(p.vl_abatimento_documento,25,2) as decimal(25,2)),0) <> 0)) then 'DUPL '+rtrim(d.cd_identificacao_document)+'-'+d.nm_fantasia_fornecedor else
              case when d.dt_cancelamento_documento is not null then 'S/NF.......... N/NF'+d.cd_identificacao_document else
                   case when p.cd_tipo_liquidacao = 2 then 'CHQ. '+rtrim(p.cd_identifica_documento)+' de '+convert(char(10), p.dt_pagamento_documento, 103) else
                        case when p.cd_tipo_liquidacao = 1 then 'BORDERO PAGAMENTO N. '+rtrim(p.cd_identifica_documento) 
                             else (select rtrim(sg_tipo_liquidacao) from tipo_liquidacao where cd_tipo_liquidacao = p.cd_tipo_liquidacao)+' N. '+p.cd_identifica_documento end
                        end
                   end
              end
         end                        as 'DescHistorico', */
    p.cd_tipo_liquidacao as 'TipoLiquidacao'

  from  
    documento_receber d inner join
    #documento_receber_pagamento p on     d.cd_documento_receber = p.cd_documento_receber inner join
    Cliente cli on cli.cd_cliente = d.cd_cliente
  where
    (d.dt_cancelamento_documento is null or d.dt_cancelamento_documento >= @dt_final)
  order by
--    TipoLiquidacao,
    d.cd_identificacao,
    Pagamento,
    Cliente
    

end

