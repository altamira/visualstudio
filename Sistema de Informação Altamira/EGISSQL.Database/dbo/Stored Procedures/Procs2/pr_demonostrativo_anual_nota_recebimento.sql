
-------------------------------------------------------------------------------
--sp_helptext pr_demonostrativo_anual_nota_recebimento
-------------------------------------------------------------------------------
--pr_demonostrativo_anual_nota_recebimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : 
--Data             : 17.05.2010
--Alteração        : 
--
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_demonostrativo_anual_nota_recebimento
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

declare @qt_ano int
--declare @qt_mes int

set @qt_ano = year(@dt_final)
--set @qt_mes = month(@dt_final)

--select * from vw_faturamento

select
  distinct
--  vw.cd_nota_saida,

  case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
       vw.cd_identificacao_nota_saida
     else
       vw.cd_nota_saida
   end                                                  as 'cd_nota_saida',

  vw.dt_nota_saida,
  vw.nm_razao_social_nota,
  vw.vl_total,
  cp.nm_condicao_pagamento,

  qtd_parcela = isnull( ( select count(*)
    from
      nota_saida_parcela nsp with (nolock) 
    where
      nsp.cd_nota_saida = vw.cd_nota_saida) ,0),

  1                                        as cd_status,
  'Total'                                  as nm_status,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 1     ) as vl_janeiro,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 2     ) as vl_fevereiro,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 3     ) as vl_marco,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 4     ) as vl_abril,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 5     ) as vl_maio,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 6     ) as vl_junho,


  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 7     ) as vl_julho,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 8     ) as vl_agosto,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 9     ) as vl_setembro,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 10     ) as vl_outubro,

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 11     ) as vl_novembro,

--select * from documento_receber

  ( select 
    sum(dr.vl_documento_receber) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 12     ) as vl_dezembro,


     0.00 as vl_total_anual

--   0.00 as vl_janeiro,
--   0.00 as vl_fevereiro,
--   0.00 as vl_marco,
--   0.00 as vl_abril,
--   0.00 as vl_maio,
--   0.00 as vl_junho,
--   0.00 as vl_julho,
--   0.00 as vl_agosto,
--   0.00 as vl_setembro,
--   0.00 as vl_outubro,
--   0.00 as vl_novembro,
--   0.00 as vl_dezembro,
--   0.00 as vl_total

into
  #Total


from
  vw_faturamento vw with (nolock) 
  left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = vw.cd_condicao_pagamento

where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  and isnull(vw.ic_comercial_operacao,'N')='S'
  --Status da Nota Fiscal 
  and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)
  and ( vw.ic_analise_op_fiscal  = 'S' )      --Verifica apenas as operações fiscais selecionadas para o BI
  and ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

order by
  vw.dt_nota_saida


select
  distinct
--  vw.cd_nota_saida,

  case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
       vw.cd_identificacao_nota_saida
     else
       vw.cd_nota_saida
   end                                                  as 'cd_nota_saida',

  vw.dt_nota_saida,
  vw.nm_razao_social_nota,
  0.00                                          as vl_total,
  cp.nm_condicao_pagamento,

  qtd_parcela = isnull( ( select count(*)
    from
      nota_saida_parcela nsp with (nolock) 
    where
      nsp.cd_nota_saida = vw.cd_nota_saida) ,0),

  2                                        as cd_status,
  'Aberto'                                  as nm_status,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 1     ) as vl_janeiro,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 2     ) as vl_fevereiro,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 3     ) as vl_marco,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)=@qt_ano and
     month(dr.dt_vencimento_documento) = 4     ) as vl_abril,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 5     ) as vl_maio,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 6     ) as vl_junho,


  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 7     ) as vl_julho,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 8     ) as vl_agosto,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 9     ) as vl_setembro,

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 10     ) as vl_outubro,

  --vl_saldo_documento
  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 11     ) as vl_novembro,

--select * from documento_receber

  ( select 
    sum(dr.vl_saldo_documento) 
  from
     documento_receber dr with (nolock)
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dr.dt_vencimento_documento)  = @qt_ano and
     month(dr.dt_vencimento_documento) = 12     ) as vl_dezembro,


     0.00 as vl_total_anual

--   0.00 as vl_janeiro,
--   0.00 as vl_fevereiro,
--   0.00 as vl_marco,
--   0.00 as vl_abril,
--   0.00 as vl_maio,
--   0.00 as vl_junho,
--   0.00 as vl_julho,
--   0.00 as vl_agosto,
--   0.00 as vl_setembro,
--   0.00 as vl_outubro,
--   0.00 as vl_novembro,
--   0.00 as vl_dezembro,
--   0.00 as vl_total

into
  #Saldo


from
  vw_faturamento vw with (nolock) 
  left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = vw.cd_condicao_pagamento

where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  and isnull(vw.ic_comercial_operacao,'N')='S'
  --Status da Nota Fiscal 
  and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)
  and ( vw.ic_analise_op_fiscal  = 'S' )      --Verifica apenas as operações fiscais selecionadas para o BI
  and ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

order by
  vw.dt_nota_saida

select
  distinct

--  vw.cd_nota_saida,

  case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
       vw.cd_identificacao_nota_saida
     else
       vw.cd_nota_saida
   end                                                  as 'cd_nota_saida',

  vw.dt_nota_saida,
  vw.nm_razao_social_nota,
  0.00                                          as vl_total,
  cp.nm_condicao_pagamento,

  qtd_parcela = isnull( ( select count(*)
    from
      nota_saida_parcela nsp with (nolock) 
    where
      nsp.cd_nota_saida = vw.cd_nota_saida) ,0),

  3                                            as cd_status,
  'Pagamento'                                  as nm_status,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 1     ) as vl_janeiro,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 2     ) as vl_fevereiro,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 3     ) as vl_marco,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida      and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 4     ) as vl_abril,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 5     ) as vl_maio,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 6     ) as vl_junho,


  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 7     ) as vl_julho,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 8     ) as vl_agosto,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 9     ) as vl_setembro,

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 10     ) as vl_outubro,

  --vl_saldo_documento
  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 11     ) as vl_novembro,

--select * from documento_receber
--select * from documento_receber_pagamento

  ( select 
    sum( isnull(dp.vl_pagamento_documento,0) ) 
  from
     documento_receber dr with (nolock)
     inner join documento_receber_pagamento dp on dp.cd_documento_receber = dr.cd_documento_receber
  where
     dr.cd_nota_saida = vw.cd_nota_saida         and
     dr.dt_cancelamento_documento is null        and
     dr.dt_devolucao_documento    is null        and
     year(dp.dt_pagamento_documento)  = @qt_ano  and
     month(dp.dt_pagamento_documento) = 12     ) as vl_dezembro,


     0.00 as vl_total_anual

--   0.00 as vl_janeiro,
--   0.00 as vl_fevereiro,
--   0.00 as vl_marco,
--   0.00 as vl_abril,
--   0.00 as vl_maio,
--   0.00 as vl_junho,
--   0.00 as vl_julho,
--   0.00 as vl_agosto,
--   0.00 as vl_setembro,
--   0.00 as vl_outubro,
--   0.00 as vl_novembro,
--   0.00 as vl_dezembro,
--   0.00 as vl_total

into
  #Pagamento


from
  vw_faturamento vw with (nolock) 
  left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = vw.cd_condicao_pagamento

where
  vw.dt_nota_saida between @dt_inicial and @dt_final
  and isnull(vw.ic_comercial_operacao,'N')='S'
  --Status da Nota Fiscal 
  and (isnull(vw.cd_status_nota,1) = 5 or isnull(vw.cd_status_nota,1) = 1)
  and ( vw.ic_analise_op_fiscal  = 'S' )      --Verifica apenas as operações fiscais selecionadas para o BI
  and ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

order by
  vw.dt_nota_saida



select
  *
from
  #Total
union all
 select * from #Saldo
union all
 select * from #Pagamento

order by
  cd_nota_saida,
  cd_status

