

-------------------------------------------------------------------------------  
--sp_helptext pr_resumo_cliente_aberto_receber
-------------------------------------------------------------------------------  
--pr_resumo_cliente_aberto_receber
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2009  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Cardoso Fernandes  
--Banco de Dados   : Egissql  
--
--Objetivo         : Resumo de Contas a Receber de Cliente Anual em Aberto
--  
--Data             : 05.10.2009  
--Alteração        : 06.10.2009   
-- 15.10.2009 - Ajustes Diversos - Carlos Fernandes  
-- 08.02.2010 - Verificação das baixas parciais - Carlos Fernandes
--  
------------------------------------------------------------------------------  
create procedure pr_resumo_cliente_aberto_receber
@dt_inicial        datetime = '',  
@dt_final          datetime = ''

as  

------------------------------------------------------------------------------  
--Montagem da Tabela Auxiliar com as Baixas até o Período
------------------------------------------------------------------------------  
-- select
-- 
--   drp.cd_documento_receber,
--   max(d.cd_identificacao)                    as cd_identificacao,
--   max(drp.dt_pagamento_documento)            as dt_pagamento_documento,
--   sum(isnull(drp.vl_pagamento_documento,0))  as vl_pagamento_documento,
--   sum(isnull(drp.vl_juros_pagamento,0))      as vl_juros_pagamento,
--   sum(isnull(drp.vl_desconto_documento,0))   as vl_desconto_documento,
--   sum(isnull(drp.vl_abatimento_documento,0)) as vl_abatimento_documento,
--   sum(isnull(drp.vl_despesa_bancaria,0))     as vl_despesa_bancaria,
--   sum(isnull(drp.vl_reembolso_documento,0))  as vl_reembolso_documento,
--   sum(isnull(drp.vl_credito_pendente,0))     as vl_credito_pendente,
--   max(vw.nm_fantasia)                        as nm_fantasia,
--   max(vw.nm_razao_social)                    as nm_razao_social
-- 
-- into
--   #BaixaDocumento
-- 
-- from
--   documento_receber_pagamento drp with (nolock) 
--   inner join documento_receber d  with (nolock) on d.cd_documento_receber  = drp.cd_documento_receber
--   inner join vw_destinatario   vw with (nolock) on vw.cd_destinatario      = d.cd_cliente and
--                                                    vw.cd_tipo_destinatario = d.cd_tipo_destinatario
-- where
--   drp.dt_pagamento_documento between @dt_inicial and @dt_final
-- 
-- group by
--   drp.cd_documento_receber

------------------------------------------------------------------------------  
--Montagem da Tabela Auxiliar com Documentos com Saldo e Baixas após o Período
------------------------------------------------------------------------------  
--                     dr.vl_documento_receber               -
--                     (isnull(drp.vl_pagamento_documento,0) -
--                     isnull(drp.vl_juros_pagamento,0)      +
--                     isnull(drp.vl_desconto_documento,0) ) 


select

  drp.cd_documento_receber,
  max(d.cd_identificacao)                    as cd_identificacao,
  max(drp.dt_pagamento_documento)            as dt_pagamento_documento,

  sum(
      isnull(drp.vl_pagamento_documento,0)
      - 
      isnull(drp.vl_juros_pagamento,0)
      +
      isnull(drp.vl_desconto_documento,0))   as vl_saldo_documento,

  max(vw.nm_fantasia)                        as nm_fantasia,
  max(vw.nm_razao_social)                    as nm_razao_social

into
  #SaldoDocumentoBaixa

from
  documento_receber_pagamento drp with (nolock) 
  inner join documento_receber d  with (nolock) on d.cd_documento_receber  = drp.cd_documento_receber
  inner join vw_destinatario   vw with (nolock) on vw.cd_destinatario      = d.cd_cliente and
                                                   vw.cd_tipo_destinatario = d.cd_tipo_destinatario
where
  isnull(d.vl_saldo_documento,0) = 0  
  and drp.dt_pagamento_documento > @dt_final

group by
  drp.cd_documento_receber

--select * from   #SaldoDocumentoBaixa order by nm_razao_social


--select * from #BaixaDocumento

--select * from vw_destinatario
--select * from cliente
  
select

  c.cd_cliente,

  max( case when isnull(c.cd_interface,0)=0 then c.cd_cliente else c.cd_interface end ) 
                                    as cd_interface,

  max(c.nm_fantasia_cliente)        as nm_fantasia_cliente,
  max(c.nm_razao_social_cliente)    as nm_razao_social_cliente,

  --Vencidas------------------------------------------------------------------------------------------------  
  --select * from documento_receber

    sum( case when ((dr.dt_vencimento_documento <= @dt_final)
                    --and 
                    --( isnull(dr.vl_saldo_documento,0) = 0 or 
                    -- ( dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) ) >0 )
                    )


         then  
          cast(  round(
                  isnull(dr.vl_saldo_documento,0)
                  +
                  isnull(ds.vl_saldo_documento,0) --Saldo de Baixas Após

--                   +
--                   case when isnull(dr.vl_saldo_documento,0)=0
--                   then
--                     dr.vl_documento_receber               -
--                     (isnull(drp.vl_pagamento_documento,0) -
--                     isnull(drp.vl_juros_pagamento,0)      +
--                     isnull(drp.vl_desconto_documento,0) ) 
--                   else
--                     0.00
--                   end
                                        ,2)   as decimal(25,2))
         else 
           0.00
         end )                         as 'Total_Vencidas',  

--     sum( case when ( (dr.dt_vencimento_documento between @dt_inicial and @dt_final) and 
--                      (dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) ) >0  )
                                                                        
     sum( case when ( (dr.dt_vencimento_documento between @dt_inicial-31 and @dt_inicial) 
                      --and (dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) ) >0 
                    )

    then  
      --dr.vl_saldo_documento 
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)
                  +
                  isnull(ds.vl_saldo_documento,0) --Saldo de Baixas Após

--                  + 
--                   (isnull(drp.vl_pagamento_documento,0) -
--                   isnull(drp.vl_juros_pagamento,0)     +
--                   isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))
    else 
      0.00
    end )                              as 'Vencidas em 30 dias',  

    sum( case when ((dr.dt_vencimento_documento between @dt_inicial-60 and @dt_inicial-31) 
                     --and (dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) ) >0 
                    )

    then  
      --dr.vl_saldo_documento 
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
 
     cast(round(
                  isnull(dr.vl_saldo_documento,0)

                  +
                  isnull(ds.vl_saldo_documento,0) --Saldo de Baixas Após

--                   + 
--                   (isnull(drp.vl_pagamento_documento,0) -
--                   isnull(drp.vl_juros_pagamento,0)     +
--                   isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))

    else 
      0.00 end ) as 'Vencidas de 30-60 dias',  

    sum( case when ((dr.dt_vencimento_documento between @dt_inicial-90 and @dt_inicial-61) 
                    --and (dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) ) >0
                    )
    then  
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)

                  +
                  isnull(ds.vl_saldo_documento,0) --Saldo de Baixas Após

--                   +
--                   case when isnull(dr.vl_saldo_documento,0)=0
--                   then
--                     (isnull(drp.vl_pagamento_documento,0) -
--                     isnull(drp.vl_juros_pagamento,0)     +
--                     isnull(drp.vl_desconto_documento,0) ) 
--                   else
--                     0.00
--                   end

--                   + 
--                   (isnull(drp.vl_pagamento_documento,0) -
--                   isnull(drp.vl_juros_pagamento,0)     +
--                   isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))
    else

      0.00

    end ) as 'Vencidas de 60-90 dias',  
 
    sum( case when ((dr.dt_vencimento_documento <= @dt_inicial-91) 
                    --and 
                    --(dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) )
                    -->0
                     )

    then  
      --dr.vl_saldo_documento
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)

                  +
                  isnull(ds.vl_saldo_documento,0) --Saldo de Baixas Após

--                   + 
--                   (isnull(drp.vl_pagamento_documento,0) -
--                   isnull(drp.vl_juros_pagamento,0)     +
--                   isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))
    else
      0.00
     end )                                  as 'Vencidas < 90 dias',  

  sum( case when ((dr.dt_vencimento_documento between @dt_inicial and @dt_final) )
    then  
      --dr.vl_saldo_documento 
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)

                  + 

                  (isnull(drp.vl_pagamento_documento,0) -
                  isnull(drp.vl_juros_pagamento,0)     +
                  isnull(drp.vl_desconto_documento,0) ) 

--                   +
--                   case when isnull(dr.vl_saldo_documento,0)=0
--                   then
--                     (isnull(drp.vl_pagamento_documento,0) -
--                     isnull(drp.vl_juros_pagamento,0)     +
--                     isnull(drp.vl_desconto_documento,0) ) 
--                   end

 
                                        ,2)   as decimal(25,2))
    else 
      0.00

 end ) as 'Aberto Período',  
  
    sum( case when ((dr.dt_vencimento_documento between @dt_final+1 and @dt_final+30) )
    then  
      --dr.vl_saldo_documento
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)

                  + 

                  (isnull(drp.vl_pagamento_documento,0) -
                  isnull(drp.vl_juros_pagamento,0)     +
                  isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))

    else 0 end ) as '30 dias',  
  
    sum( case when ((dr.dt_vencimento_documento between @dt_final+31 and  @dt_final+60) ) 
    then  
      --dr.vl_saldo_documento 
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)
                  + 
                  (isnull(drp.vl_pagamento_documento,0) -
                  isnull(drp.vl_juros_pagamento,0)     +
                  isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))
    else 0 end ) as '60 dias',  
  
    sum( case when ((dr.dt_vencimento_documento between @dt_final+61 and @dt_final+90) ) 
    then  
      --dr.vl_saldo_documento
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)

      cast(round(
                  isnull(dr.vl_saldo_documento,0)
                  + 
                  (isnull(drp.vl_pagamento_documento,0) -
                  isnull(drp.vl_juros_pagamento,0)     +
                  isnull(drp.vl_desconto_documento,0) ) 

                                        ,2)   as decimal(25,2))
    else 0 end ) as '90 dias',  
  
    sum( case when ((dr.dt_vencimento_documento >= @dt_final+91 ) ) 
    then  
      --dr.vl_saldo_documento 
      --dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0)
      cast(round(
                  isnull(dr.vl_saldo_documento,0)
                  + 
                  (isnull(drp.vl_pagamento_documento,0) -
                  isnull(drp.vl_juros_pagamento,0)     +
                  isnull(drp.vl_desconto_documento,0) ) 
 
                                        ,2)   as decimal(25,2))
   else 0 end ) as '120 dias',  
        
  --  sum ( isnull(dr.vl_saldo_documento,0) )      as 'TotalGeral'   
  sum ( 
  case when ( drp.dt_pagamento_documento > @dt_final and isnull(dr.vl_saldo_documento,0)=0 ) 
  then
    case when isnull(ds.vl_saldo_documento,0)>0 then
      isnull(ds.vl_saldo_documento,0)
    else
      dr.vl_documento_receber 
    end
    --- 
    --isnull(ds.vl_saldo_documento,0)

    --- isnull( drp.vl_pagamento_documento,0)

--       cast(round(
-- --                  isnull(dr.vl_saldo_documento,0)
-- --                  + 
--                   (isnull(drp.vl_pagamento_documento,0) -
--                   isnull(drp.vl_juros_pagamento,0)     +
--                   isnull(drp.vl_desconto_documento,0) ) 
--                                         ,2)   as decimal(25,2))

  else 

    isnull(dr.vl_saldo_documento,0) 

  end)                                              as 'TotalGeral'   

into
  #ResumoAbertoCliente

from
  cliente c                                       with (nolock)
  left outer join Documento_receber dr            with (nolock) on dr.cd_cliente            = c.cd_cliente
 -- left outer join Documento_receber_Pagamento drp with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
  left outer join vw_baixa_documento_receber drp  with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
--  left outer join #BaixaDocumento drp with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber
  left outer join #SaldoDocumentoBaixa ds         with (nolock) on ds.cd_documento_receber = dr.cd_documento_receber

where  
    dr.dt_emissao_documento <= @dt_final  and
    dr.dt_cancelamento_documento is null and  
    dr.dt_devolucao_documento    is null and 

   ( isnull(dr.vl_saldo_documento,0)>0  or 
      drp.dt_pagamento_documento > @dt_final )

--     drp.dt_pagamento_documento >= dr.dt_vencimento_documento and drp.dt_pagamento_documento > @dt_final )
--   (dr.vl_documento_receber - isnull( drp.vl_pagamento_documento,0) ) >0  )


group by   
    c.cd_cliente  

order by  
    c.cd_interface
 

select 
  *
from
  #ResumoAbertoCliente
 
order by
  nm_razao_social_cliente  

