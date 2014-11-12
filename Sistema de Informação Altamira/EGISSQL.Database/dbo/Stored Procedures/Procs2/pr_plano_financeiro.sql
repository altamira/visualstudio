
--------------------------------------------------------------------------------
CREATE PROCEDURE pr_plano_financeiro
-------------------------------------------------------------------------------- 
--GBS - Global Business Solution                2003 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)      : Daniel C. Neto 
--Banco de Dados : EGISSQL 
--Objetivo       : Trazer valores de plano financeiro.
--Data           : 14/08/2003
--Alteração		 : 25.08.2003 - Fabio - Realizar os calculos nas colunas de Valor Realizado e Previsto
--                 13/02/2004 - Daniel C. Neto. - Realizar também para a coluna emitido.
--                 16.10.2005 - Colocar do Tipo de Conta financeira (E/S) - Carlos Fernandes  
--                 03.05.2006 - Adição do campo "Operacional" para uso no CashFlow - Fabio Cesar
--                 16/11/2006 - Incluído 2 campos novos. - Daniel C. Neto.
--                 22.03.2007 - Busca dos movimentos no Movimento Bancários - Manuais - Carlos Fernandes
--                 14.06.2007 - Verificação do Rateio do Plano Financeiro - Carlos Fernandes
--                 18.07.2007 - Rateiro de baixa de parcial - Carlos Fernandes
--                 03.09.2007 - Plano Competence - Carlos Fernandes.
--                 10.10.2007 - Mostrar o Desconto no Realizado - Carlos Fernandes.
--                 29.10.2007 - Único Dia - Carlos Fernandes
--                 07.11.2007 - Conta Redutora no Plano Financeiro - Carlos Fernandes
-- 21.11.2007 - Mostrar a Coluna de Orçamento no Período - Carlos Fernandes
-- 19.12.2007 - Descontar o Valor do Abatimento quando documento em aberto - Carlos Fernandes
-- 28.05.2008 - Conta Contábil - Carlos Fernandes
-- 15.02.2009 - Verificação do contas a receber - Carlos Fernandes 
-- 19.04.2010 - Ajustes Diversos - Carlos / Márcio
-- 05.08.2010 - Checagem se o Lote deve ou não ser demonstrado na consulta - Carlos Fernandes
-- 14.08.2010 - Previsto/Lote - Carlos Fernandes 
----------------------------------------------------------------------------------------------------------------- 
  
@dt_inicial          datetime = '',  
@dt_final            datetime = '' 
  
as   
  
--select * from conta_banco_lancamento  
  
declare @cd_plano_financeiro           int,  
        @vl_plano_financeiro_previsto  float,  
        @vl_plano_financeiro_realizado float,  
        @vl_emitido_periodo            float,
        @vl_orcamento_plano_financeiro float

--        @ic_lote_fluxo_caixa           char(1)


--select * from parametro_lote_receber

-- select
--   @ic_lote_fluxo_caixa = isnull(ic_fluxo_caixa,'N')
-- from
--   parametro_lote_receber
-- where
--   cd_empresa = dbo.fn_empresa()

  
select       
  pf.ic_fluxo_plano_financeiro,  
  pf.cd_plano_financeiro,   
  pf.nm_conta_plano_financeiro,   
  pf.sg_conta_plano_financeiro,   
  pf.cd_mascara_plano_financeiro,   
  pf.nm_rotina_atualizacao,   
  pf.cd_grupo_financeiro,   
  pf.cd_usuario,   
  pf.dt_usuario,   
  pf.cd_plano_financeiro_pai,   
  pf.cd_lancamento_padrao,  
  pf.cd_centro_receita,  
  pf.ic_importcao_plano_fin,    
  pf.ic_conta_orcamento,  
  pf.cd_procedimento,  
  
  --Calculando valor emitido no período tirando os cancelamentos ------------------------------------ 
  
  case   
  when gf.cd_tipo_operacao = 2 then   
  (select   
     sum( isnull(vl_documento_receber,0) - isnull(vl_abatimento_documento,0) )   
   from   
     documento_receber  with (nolock)
   where  
     cd_plano_financeiro = pf.cd_plano_financeiro and  
     dt_emissao_documento between @dt_inicial and @dt_final and  
     dt_cancelamento_documento is null                      and  
     dt_devolucao_documento    is null                      and                   
     isnull(ic_lote_documento,'S') = 'S' 
     )   

  when gf.cd_tipo_operacao = 1 then   
  (select  
     sum(isnull(vl_documento_pagar,0))  
   from  
     documento_pagar  with (nolock)
   where  
     cd_plano_financeiro = pf.cd_plano_financeiro and  
     dt_emissao_documento_paga between @dt_inicial and @dt_final and  
     dt_cancelamento_documento is null and
      IsNull(pf.ic_conta_analitica,'N') = 'S')   
  end                                          as vl_emitido_periodo,  
  
  --Calculando valor previsto para recebimento no período  
  
  case   
  when gf.cd_tipo_operacao = 2 then   
  (select   
     sum( isnull(vl_documento_receber,0) - - isnull(vl_abatimento_documento,0) )   
   from   
     documento_receber  with (nolock)
   where  
     cd_plano_financeiro = pf.cd_plano_financeiro and  
     dt_vencimento_documento between @dt_inicial and @dt_final and  
     dt_cancelamento_documento is null   and  
     dt_devolucao_documento    is null   and   
     isnull(ic_lote_documento,'S') = 'S' and
     IsNull(pf.ic_conta_analitica,'N') = 'S')   

  when gf.cd_tipo_operacao = 1 then   
  (select  
     sum(isnull(vl_documento_pagar,0))  
   from  
     documento_pagar  with (nolock)
   where  
     cd_plano_financeiro = pf.cd_plano_financeiro and  
     dt_vencimento_documento between @dt_inicial and @dt_final and  
     dt_cancelamento_documento is null and IsNull(pf.ic_conta_analitica,'N') = 'S')   
  end                                           as vl_previsto_financeiro,  
  
  --Calculando valor realizado no período -------------------------------------------------------------- 
  
  case   
  when gf.cd_tipo_operacao = 2 then   
  (select   
     sum(  
   case   
  when ( dr.dt_devolucao_documento is not null ) then  
                   isnull(dr.vl_documento_receber,0) - isnull(dr.vl_abatimento_documento,0)  
  else  
                   isnull(drp.vl_pagamento_documento,0)    
                 end )  
  
   from   
     documento_receber dr   with (nolock)
     inner join documento_receber_pagamento drp with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber  
   where  
     dr.cd_plano_financeiro = pf.cd_plano_financeiro and  
    ( IsNull(dr.dt_devolucao_documento, drp.dt_pagamento_documento ) between @dt_inicial and @dt_final )  and     
     dr.dt_cancelamento_documento is null and  
     dr.dt_devolucao_documento    is null    and IsNull(pf.ic_conta_analitica,'N') = 'S' 
     and isnull(ic_lote_documento,'S') = 'S' 
     and dr.cd_documento_receber not in ( select cd_documento_receber from documento_receber_desconto )
     )   

     --Não pode estar descontado
  
  when gf.cd_tipo_operacao = 1 then   
  --Contas a Pagar 
  (select   
     sum(isnull(dpp.vl_pagamento_documento,0))   
   from   
     documento_pagar_pagamento dpp with (nolock)
     inner join documento_pagar dp with (nolock) on dpp.cd_documento_pagar = dp.cd_documento_pagar  
   where  
     dp.cd_plano_financeiro = pf.cd_plano_financeiro and  
     dpp.dt_pagamento_documento between @dt_inicial and @dt_final and  
     dp.dt_cancelamento_documento is null and IsNull(pf.ic_conta_analitica,'N') = 'S')   
  end                                           as vl_realizado_financeiro,  
  
  pf.ic_conta_analitica,   
  pf.pc_liq_plano_financeiro,   
  pf.cd_centro_custo,   
  pf.cd_tipo_operacao,  
  pf.cd_categoria_financeiro,  
  pf.ic_cpv_plano_financeiro,  
  IsNull(pf.ic_plano_operacional,'N')          as ic_plano_operacional,
  pf.cd_plano_competence,
  isnull(pf.ic_redutora_plano_financeiro,'N')  as ic_redutora_plano_financeiro,
  
( select top 1 isnull(o.vl_previsto_p_financeiro,0)
    from
      plano_financeiro_orcamento o
    where
      o.cd_plano_financeiro = pf.cd_plano_financeiro and
      o.dt_inicio_p_financeiro >= @dt_inicial        and
      o.dt_final_p_financeiro <=  @dt_final    ) as vl_orcamento_plano_financeiro,

--  0.00                                           as pc_orcamento_plano_financeiro,
  pf.cd_conta,
  pc.cd_mascara_conta,
  pc.nm_conta,
  pf.cd_historico_contabil

--select * from plano_conta
  
into 
  #Plano  
  
from           
  plano_financeiro pf                 with (nolock) 
  left outer join grupo_financeiro gf with (nolock) on pf.cd_grupo_financeiro = gf.cd_grupo_financeiro  
  left outer join plano_conta      pc with (nolock) on pc.cd_conta            = pf.cd_conta

order by   
  pf.cd_mascara_plano_financeiro  


--select * from #Plano

--select * from plano_financeiro_orcamento  
------------------------------------------------------------------------------------------------  
--Gera a Tabela com o Movimento do Contas a Receber com Desconto
------------------------------------------------------------------------------------------------  
--select * from documento_receber_desconto

   select  
     pf.cd_plano_financeiro,  
     sum(isnull(drd.vl_desconto_documento,0)) as vl_desconto_documento
   into  
     #MovimentoDesconto
   from  
     documento_receber d                       with (nolock)
     inner join documento_receber_desconto drd with (nolock) on drd.cd_documento_receber = d.cd_documento_receber  
     inner join plano_financeiro pf            with (nolock) on pf.cd_plano_financeiro   = d.cd_plano_financeiro  
   where  
     d.cd_plano_financeiro = pf.cd_plano_financeiro and  
     drd.dt_desconto_documento between @dt_inicial and @dt_final and  
     d.dt_cancelamento_documento is null and
     d.dt_devolucao_documento    is null and   
     isnull(ic_lote_documento,'S') = 'S' and
     IsNull(pf.ic_conta_analitica,'N') = 'S'  
   group by  
     pf.cd_plano_financeiro  

------------------------------------------------------------------------------------------------  
--Gera a Tabela com o Movimento Rateado do Contas a Pagar  
------------------------------------------------------------------------------------------------  
--select * from documento_pagar_plano_financ  
  
   select  
     pf.cd_plano_financeiro,  
     sum(isnull(dpf.vl_plano_financeiro,0)) as vl_emitido_periodo  
   into  
     #RateioPagarEmitido  
   from  
     documento_pagar d                                with (nolock)
     inner join      documento_pagar_plano_financ dpf with (nolock) on dpf.cd_documento_pagar  = d.cd_documento_pagar  
     inner join      plano_financeiro pf              with (nolock) on pf.cd_plano_financeiro  = dpf.cd_plano_financeiro  
   where  
     dpf.cd_plano_financeiro = pf.cd_plano_financeiro and  
     d.dt_emissao_documento_paga between @dt_inicial and @dt_final and  
     d.dt_cancelamento_documento is null and IsNull(pf.ic_conta_analitica,'N') = 'S'  
   group by  
     pf.cd_plano_financeiro  
  
   select  
     pf.cd_plano_financeiro,  
     sum(isnull(dpf.vl_plano_financeiro,0)) as vl_previsto_financeiro  
   into  
     #RateioPagarPrevisto  
   from  
     documento_pagar d  with (nolock)
     inner join documento_pagar_plano_financ dpf with (nolock) on dpf.cd_documento_pagar = d.cd_documento_pagar  
     inner join plano_financeiro pf              with (nolock) on pf.cd_plano_financeiro = dpf.cd_plano_financeiro  
   where  
     dpf.cd_plano_financeiro = pf.cd_plano_financeiro and  
     d.dt_vencimento_documento between @dt_inicial and @dt_final and  
     d.dt_cancelamento_documento is null and IsNull(pf.ic_conta_analitica,'N') = 'S'  
   group by  
     pf.cd_plano_financeiro  
  
   --select * from documento_pagar_pagamento
   --select * from documento_pagar_plano_financ

   select  
     pf.cd_plano_financeiro,  
     sum(isnull(dpp.vl_pagamento_documento,0)*(dpf.pc_plano_financeiro/100)) as vl_realizado_financeiro  
   into  
     #RateioPagarRealizado  
   from  
     documento_pagar d                           with (nolock)
     inner join documento_pagar_plano_financ dpf with (nolock) on dpf.cd_documento_pagar = d.cd_documento_pagar  
     inner join plano_financeiro pf              with (nolock) on pf.cd_plano_financeiro = dpf.cd_plano_financeiro  
     inner join documento_pagar_pagamento dpp    with (nolock) on dpp.cd_documento_pagar = d.cd_documento_pagar  
   where  
     dpf.cd_plano_financeiro = pf.cd_plano_financeiro and  
    ( IsNull(d.dt_devolucao_documento, dpp.dt_pagamento_documento ) between @dt_inicial and @dt_final )  and     
     d.dt_cancelamento_documento is null and  
     d.dt_devolucao_documento    is null and IsNull(pf.ic_conta_analitica,'N') = 'S'   
   group by  
     pf.cd_plano_financeiro  
  
   --select * from #RateioPagarRealizado

------------------------------------------------------------------------------------------------  
--Gera a Tabela com o Movimento Bancário Manual  
------------------------------------------------------------------------------------------------  
  
--select * from conta_banco_lancamento  
  
select  
  pf.cd_plano_financeiro,   
  sum ( isnull(cbl.vl_lancamento,0) ) as vl_emitido_periodo,  
  sum ( isnull(cbl.vl_lancamento,0) ) as vl_realizado_financeiro  
  
into #PlanoMovimentoBancario  
  
from           
  plano_financeiro pf                  with (nolock)
  inner join conta_banco_lancamento cbl with (nolock) on cbl.cd_plano_financeiro  = pf.cd_plano_financeiro  
where  
  isnull(cbl.cd_documento,0) = 0     and  
  isnull(cbl.ic_fluxo_caixa,'N')='S' and
  cbl.dt_lancamento between @dt_inicial and @dt_final   
group by  
  pf.cd_plano_financeiro  
  
--select * from #PlanoMovimentoBancario  
--select * from caixa_lancamento  
--select * from tipo_operacao_financeira
--  left outer join tipo_operacao_financeira tpf on tpf.cd_tipo_operacao      = cs.cd_tipo_operacao_final 
  
------------------------------------------------------------------------------------------------  
--Gera a Tabela com o Movimento de Caixa Manual  
------------------------------------------------------------------------------------------------  
--select * from plano_financeiro
 
select  
  pf.cd_plano_financeiro,   
--  sum ( case when cx.cd_tipo_operacao = 1 then 1 else 1 end * isnull(cx.vl_lancamento_caixa,0) ) as vl_emitido_periodo,  
--  sum ( case when cx.cd_tipo_operacao = 1 then 1 else 1 end * isnull(cx.vl_lancamento_caixa,0) ) as vl_realizado_financeiro  
  sum ( case when isnull(pf.ic_redutora_plano_financeiro,'N')='S' then -1 else 1 end * isnull(cx.vl_lancamento_caixa,0) ) as vl_emitido_periodo,  
  sum ( case when isnull(pf.ic_redutora_plano_financeiro,'N')='S' then -1 else 1 end * isnull(cx.vl_lancamento_caixa,0) ) as vl_realizado_financeiro  
  
into #PlanoMovimentoCaixa  
  
from           
  plano_financeiro pf            with (nolock)
  inner join caixa_lancamento cx with (nolock)   on cx.cd_plano_financeiro  = pf.cd_plano_financeiro  
where  
  isnull(cx.cd_documento,0) = 0 and  
  cx.dt_lancamento_caixa between @dt_inicial and @dt_final   
group by  
  pf.cd_plano_financeiro  
  
 
------------------------------------------------------------------------------------------------  
--Gera a Tabela com o Movimento de Aplicação Financeira
------------------------------------------------------------------------------------------------  
--select * from aplicacao_financeira
select  
  pf.cd_plano_financeiro,   
  sum ( case when isnull(pf.ic_redutora_plano_financeiro,'N')='S' then -1 else 1 end * isnull(af.vl_atual_aplicacao,0) ) as vl_emitido_periodo,  
  sum ( case when isnull(pf.ic_redutora_plano_financeiro,'N')='S' then -1 else 1 end * isnull(af.vl_atual_aplicacao,0) ) as vl_realizado_financeiro  
  
into #PlanoMovimentoAplicacao
  
from           
  plano_financeiro pf                with (nolock)
  inner join aplicacao_financeira af with (nolock)   on af.cd_plano_financeiro  = pf.cd_plano_financeiro  
where  
  isnull(af.ic_liquidacao_aplicacao,'N')='N' and
  af.dt_aplicacao_financeira between @dt_inicial and @dt_final   
group by  
  pf.cd_plano_financeiro  


--Atualizado a Tabela Plano com a Aplicação Financeira
  
update  
  #Plano  
set  
  vl_emitido_periodo      = isnull(pf.vl_emitido_periodo,0)      + isnull(pa.vl_emitido_periodo,0),  
  vl_realizado_financeiro = isnull(pf.vl_realizado_financeiro,0) + isnull(pa.vl_realizado_financeiro,0)   
from   
  #Plano pf  
  inner join #PlanoMovimentoAplicacao pa on pa.cd_plano_financeiro = pf.cd_plano_financeiro  

 
--Atualizado a Tabela Plano com Movimento Bancário  
  
update  
  #Plano  
set  
  vl_emitido_periodo      = isnull(pf.vl_emitido_periodo,0)      + isnull(pb.vl_emitido_periodo,0),  
  vl_realizado_financeiro = isnull(pf.vl_realizado_financeiro,0) + isnull(pb.vl_realizado_financeiro,0)   
from   
  #Plano pf  
  inner join #PlanoMovimentoBancario pb on pb.cd_plano_financeiro = pf.cd_plano_financeiro  
  
  
--Atualizado a Tabela Plano com Movimento de Caixa  
  
update  
  #Plano  
set  
  vl_emitido_periodo      = isnull(pf.vl_emitido_periodo,0)      + isnull(pc.vl_emitido_periodo,0),  
  vl_realizado_financeiro = isnull(pf.vl_realizado_financeiro,0) + isnull(pc.vl_realizado_financeiro,0)   
from   
  #Plano pf  
  inner join #PlanoMovimentoCaixa pc on pc.cd_plano_financeiro = pf.cd_plano_financeiro  
  
--Atualizando a Tabela de Rateio do Contas a Pagar  
  
update  
  #Plano  
set  
  vl_previsto_financeiro  = isnull(pf.vl_previsto_financeiro,0)  + isnull(rp.vl_previsto_financeiro,0),  
  vl_emitido_periodo      = isnull(pf.vl_emitido_periodo,0)      + isnull(re.vl_emitido_periodo,0),  
  vl_realizado_financeiro = isnull(pf.vl_realizado_financeiro,0) + isnull(rr.vl_realizado_financeiro,0)   
from   
  #Plano pf  
  left outer join #RateioPagarPrevisto  rp on rp.cd_plano_financeiro = pf.cd_plano_financeiro  
  left outer join #RateioPagarEmitido   re on re.cd_plano_financeiro = pf.cd_plano_financeiro  
  left outer join #RateioPagarRealizado rr on rr.cd_plano_financeiro = pf.cd_plano_financeiro  
  
--Atualizando a Tabela com o Movimento de desconto

update  
  #Plano  
set  
  vl_realizado_financeiro = isnull(pf.vl_realizado_financeiro,0) + isnull(md.vl_desconto_documento,0)   
from   
  #Plano pf  
  left outer join #MovimentoDesconto    md on md.cd_plano_financeiro = pf.cd_plano_financeiro  

------------------------------------------------------------------------------------------------  
-- Pegando todas as que não são contas analíticas.  
------------------------------------------------------------------------------------------------  
select * into #PlanoPai from #Plano where ic_conta_analitica = 'N'  
  
--Cria um cursor para atualizar as contas pais  
  
declare crPlano cursor for  
   select cd_plano_financeiro  
   from #PlanoPai  
   order by 
     len(cd_mascara_plano_financeiro) desc  
  
open crPlano  
  
FETCH NEXT FROM crPlano INTO @cd_plano_financeiro  
while @@FETCH_STATUS = 0   
begin  
 select   
          @vl_plano_financeiro_previsto  = sum(IsNull(vl_previsto_financeiro,0)        * case when ic_redutora_plano_financeiro='S' then -1 else 1 end ),  
          @vl_plano_financeiro_realizado = sum(IsNull(vl_realizado_financeiro,0)       * case when ic_redutora_plano_financeiro='S' then -1 else 1 end ),  
          @vl_emitido_periodo            = sum(IsNull(vl_emitido_periodo,0)            * case when ic_redutora_plano_financeiro='S' then -1 else 1 end ),
          @vl_orcamento_plano_financeiro = sum(IsNull(vl_orcamento_plano_financeiro,0) * case when ic_redutora_plano_financeiro='S' then -1 else 1 end )
 from  
    #Plano  
 where  
  cd_plano_financeiro_pai = @cd_plano_financeiro  
   
 update   
   #Plano  
 set  
  vl_previsto_financeiro        = @vl_plano_financeiro_previsto,  
  vl_realizado_financeiro       = @vl_plano_financeiro_realizado,  
  vl_emitido_periodo            = @vl_emitido_periodo,
  vl_orcamento_plano_financeiro = @vl_orcamento_plano_financeiro
 where  
  cd_plano_financeiro = @cd_plano_financeiro   
  
 FETCH NEXT FROM crPlano INTO @cd_plano_financeiro  
end  
CLOSE crPlano  
DEALLOCATE crPlano  
  
--Mostra a Tabela Final  
  
--select * from #Plano  
  
select   
  pf.*,   
  isnull(pf.vl_previsto_financeiro,0)                            as vl_previsto_corrigido,   
  isnull(pf.vl_realizado_financeiro,0)                           as vl_realizado_corrigido,
  case when isnull(pf.vl_emitido_periodo,0)>0 
  then
    case when pf.vl_orcamento_plano_financeiro>0 then 
       (pf.vl_emitido_periodo/pf.vl_orcamento_plano_financeiro) * 100 
    else
      0.00
    end
  else
    0.00
  end                                                            as pc_plano_financeiro_orcamento    
from   
  #Plano pf  
order by   
  pf.cd_mascara_plano_financeiro  

