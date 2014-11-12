
-------------------------------------------------------------------------------
--sp_helptext pr_analitico_plano_financeiro
-------------------------------------------------------------------------------
--pr_analitico_plano_financeiro
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta do Plano Financeiro com os movimentos
--                   ( Contas Pagar, Receber, Banco e Caixa )
--
--Data             : 19.04.2010
--Alteração        : 
--
-- 06.07.2010 - Ajustes Diversos - Carlos Fernandes
-- 16.08.2010 - Lote - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_analitico_plano_financeiro
@dt_inicial               datetime = '',
@dt_final                 datetime = '',
@cd_plano_financeiro      int      = 0,
@cd_tipo_lancamento_fluxo int      = 0,
@ic_tipo_consulta         char(1)  = 'R' --Previsto / Realizado / Competência

as

--documento_receber

if @ic_tipo_consulta = 'P'
begin

    Select
      'PF'                                                                                 as nm_origem,
      cast(LTrim(RTrim(str(pfm.cd_movimento)))  as varchar(25))                            as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
      pfm.dt_movto_plano_financeiro                                                        as dt_lancamento,
      pfm.vl_plano_financeiro                                                              as vl_lancamento,
      tof.nm_tipo_operacao                                                                 as nm_tipo_operacao,
      tof.sg_tipo_operacao                                                                 as sg_tipo_operacao,
      hf.nm_historico_financeiro                                                           as nm_historico_padrao,
      isnull(pfm.nm_historico_movimento,'')                                                as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      isnull(cc.nm_centro_custo,'')                                                        as nm_centro_custo,
      isnull(cc.cd_mascara_centro_custo,'')                                                as cd_mascara_centro_custo     

    from 
      Plano_financeiro_movimento pfm               with (nolock) 
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Tipo_Operacao_Financeira tof with (nolock) on pfm.cd_tipo_operacao        = tof.cd_tipo_operacao
      Left Outer Join Historico_Financeiro     hf  with (nolock) on pfm.cd_historico_financeiro = hf.cd_historico_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
      pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
      pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end

--     order by
--         pfm.dt_movto_plano_financeiro desc

    union all

    --select * from documento_receber

    Select
      'CR'                                                                                 as nm_origem,
       cast(LTrim(RTrim(pfm.cd_identificacao))  as varchar(25))                            as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
      pfm.dt_vencimento_documento                                                          as dt_lancamento,
      pfm.vl_documento_receber                                                             as vl_lancamento,
      'Entrada'                                                                            as nm_tipo_operacao,
      'E'                                                                                  as sg_tipo_operacao,
      cast(pfm.ds_documento_receber as varchar(50))                                        as nm_historico_padrao,
      cast('' as varchar(40))                                                              as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      isnull(cc.nm_centro_custo,'')                                                        as nm_centro_custo,
      isnull(cc.cd_mascara_centro_custo,'')                                                as cd_mascara_centro_custo     

    from 
      documento_receber                        pfm with (nolock) 
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
      pfm.dt_vencimento_documento between @dt_inicial and @dt_final and
      --pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end
      and isnull(pfm.ic_lote_documento,'S') = 'S' 


    union all

    --select * from documento_receber

    Select
      'CP'                                                                                 as nm_origem,
      cast(LTrim(RTrim(pfm.cd_identificacao_document))  as varchar(25))                    as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
      pfm.dt_vencimento_documento                                                          as dt_lancamento,
      pfm.vl_documento_pagar                                                               as vl_lancamento,
      'Saída'                                                                              as nm_tipo_operacao,
      'S'                                                                                  as sg_tipo_operacao,
      cast(pfm.nm_observacao_documento as varchar(50))                                     as nm_historico_padrao,
      cast('' as varchar(40))                                                              as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      isnull(cc.nm_centro_custo,'')                                                        as nm_centro_custo,
      isnull(cc.cd_mascara_centro_custo,'')                                                as cd_mascara_centro_custo     

    from 
      documento_pagar                          pfm with (nolock) 
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
      pfm.dt_vencimento_documento between @dt_inicial and @dt_final and
      --pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end

--select * from documento_pagar


--     order by
--         pfm.dt_vencimento_documento desc


      
--select @dt_inicial,@dt_final

--     union all
-- 

end


--Realizado

if @ic_tipo_consulta = 'R'
begin

    Select
      'PF'                                                                                 as nm_origem,
      cast(LTrim(RTrim(str(pfm.cd_movimento)))  as varchar(25))                            as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
      pfm.dt_movto_plano_financeiro                                                        as dt_lancamento,
      pfm.vl_plano_financeiro                                                              as vl_lancamento,
      tof.nm_tipo_operacao                                                                 as nm_tipo_operacao,
      tof.sg_tipo_operacao                                                                 as sg_tipo_operacao,
      hf.nm_historico_financeiro                                                           as nm_historico_padrao,
      isnull(pfm.nm_historico_movimento,'')                                                as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      isnull(cc.nm_centro_custo,'')                                                        as nm_centro_custo,
      isnull(cc.cd_mascara_centro_custo,'')                                                as cd_mascara_centro_custo,     
      pfm.cd_plano_financeiro                                                              as wcdplano     
 
    from 
      Plano_financeiro_movimento pfm               with (nolock) 
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Tipo_Operacao_Financeira tof with (nolock) on pfm.cd_tipo_operacao        = tof.cd_tipo_operacao
      Left Outer Join Historico_Financeiro     hf  with (nolock) on pfm.cd_historico_financeiro = hf.cd_historico_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
      pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
      pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end
    

       -- order by
       --  pfm.cd_plano_financeiro,pfm.dt_movto_plano_financeiro desc
 
    --group by
    --     pf.cd_plano_financeiro
--     order by
--         pfm.dt_movto_plano_financeiro desc

    union all

    Select
      'MB'                                                                                 as nm_origem,
      cast(LTrim(RTrim(str(pfm.cd_lancamento)))  as varchar(25))                           as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
      pfm.dt_lancamento                                                                    as dt_lancamento,
      pfm.vl_lancamento                                                                    as vl_lancamento,
      tof.nm_tipo_operacao                                                                 as nm_tipo_operacao,
      tof.sg_tipo_operacao                                                                 as sg_tipo_operacao,
      pfm.nm_historico_lancamento                                                           as nm_historico_padrao,
      isnull(pfm.nm_compl_lancamento,'')                                                   as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      cast('' as varchar(40))                                                              as nm_centro_custo,
      cast('' as varchar(20))                                                              as cd_mascara_centro_custo,     
      pfm.cd_plano_financeiro                                                              as wcdplano
    from 
      conta_banco_lancamento pfm                   with (nolock) 
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Tipo_Operacao_Financeira tof with (nolock) on pfm.cd_tipo_operacao        = tof.cd_tipo_operacao
      Left Outer Join Historico_Financeiro     hf  with (nolock) on pfm.cd_historico_financeiro = hf.cd_historico_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      --Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
      pfm.dt_lancamento between @dt_inicial and @dt_final and
      pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end
      and isnull(pfm.cd_documento_receber,0)=0
      and isnull(pfm.cd_documento_baixa,0)  =0

    union all
    
    --select * from conta_banco_lancamento

    --select * from documento_receber

    Select
      'CR'                                                                                 as nm_origem,
       cast(LTrim(RTrim(pfm.cd_identificacao))  as varchar(25))                            as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
--       pfm.dt_vencimento_documento                                                          as dt_lancamento,
--       pfm.vl_documento_receber                                                             as vl_lancamento,
      drp.dt_pagamento_documento                                                          as dt_lancamento,
      drp.vl_pagamento_documento                                                          as vl_lancamento,

      'Entrada'                                                                            as nm_tipo_operacao,
      'E'                                                                                  as sg_tipo_operacao,
      cast(pfm.ds_documento_receber as varchar(50))                                        as nm_historico_padrao,
      cast('' as varchar(40))                                                              as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      isnull(cc.nm_centro_custo,'')                                                        as nm_centro_custo,
      isnull(cc.cd_mascara_centro_custo,'')                                                as cd_mascara_centro_custo,
      pfm.cd_plano_financeiro                                                              as wcdplano     

    from 
      documento_receber                        pfm with (nolock) 
      inner join documento_receber_pagamento   drp with (nolock) on drp.cd_documento_receber    = pfm.cd_documento_receber
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

--select * from documento_receber_pagamento

    where
      --pfm.dt_vencimento_documento between @dt_inicial and @dt_final and
      drp.dt_pagamento_documento between @dt_inicial and @dt_final and
      --pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end


    union all

    --select * from documento_receber

    Select
      'CP'                                                                                 as nm_origem,
      cast(LTrim(RTrim(pfm.cd_identificacao_document))  as varchar(25))                    as cd_codigo,
      pf.nm_conta_plano_financeiro                                                         as nm_conta,
      pf.cd_mascara_plano_financeiro                                                       as cd_plano_financeiro,
--      pfm.dt_vencimento_documento                                                          as dt_lancamento,
      dpp.dt_pagamento_documento                                                          as dt_lancamento,
--      pfm.vl_documento_pagar                                                               as vl_lancamento,
      dpp.vl_pagamento_documento                                                           as vl_lancamento,
      'Saída'                                                                              as nm_tipo_operacao,
      'S'                                                                                  as sg_tipo_operacao,
      cast(pfm.nm_observacao_documento as varchar(50))                                     as nm_historico_padrao,
      cast('' as varchar(40))                                                              as nm_complemento,
      isnull(pfm.cd_moeda,1)                                                               as cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      isnull(cc.nm_centro_custo,'')                                                        as nm_centro_custo,
      isnull(cc.cd_mascara_centro_custo,'')                                                as cd_mascara_centro_custo,
      pfm.cd_plano_financeiro                                                              as wcdplano     

    from 
      documento_pagar                          pfm with (nolock) 
      inner join documento_pagar_pagamento     dpp with (nolock) on dpp.cd_documento_pagar      = pfm.cd_documento_pagar
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
--      pfm.dt_vencimento_documento between @dt_inicial and @dt_final and
      dpp.dt_pagamento_documento between @dt_inicial and @dt_final and
      --pfm.cd_tipo_lancamento_fluxo = case when @cd_tipo_lancamento_fluxo = 0 then pfm.cd_tipo_lancamento_fluxo else @cd_tipo_lancamento_fluxo end      and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro      = 0 then pfm.cd_plano_financeiro      else @cd_plano_financeiro end
    
     order by
         pfm.cd_plano_financeiro,pfm.dt_movto_plano_financeiro desc

--select * from documento_pagar


--     order by
--         pfm.dt_vencimento_documento desc


      
--select @dt_inicial,@dt_final

--     union all
-- 

end



