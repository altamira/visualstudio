
create procedure pr_consulta_movimento_financeiro
--------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Igor Gama
--Banco de Dados   : EgisSql
--Objetivo         : Consulta dos movimentos de Plano Financeiro, Caixa e Banco
--Data             : 01.04.2004
--                 : 16.04.2006 - Acertos Diversos na Consulta - Carlos Fernandes
--                 : 18.04.2006 - Centro de Custo na Consulta - Carlos Fernandes
-- 19.04.2010 - Ajustes Diversos - Carlos Fernandes/Márcio Martins
--------------------------------------------------------------------------------------------------
@cd_tipo_lancamento_fluxo int,
@cd_plano_financeiro      int,
@dt_inicial               datetime,
@dt_final                 datetime
as

--select * from centro_custo

    --Plano Financeiro

    Select
      'PF'                                                                                 as nm_origem,
      'PF-' + LTrim(RTrim(str(pfm.cd_movimento)))                                          as cd_codigo,
      Substring(pf.cd_mascara_plano_financeiro+' - '+pf.nm_conta_plano_financeiro,1 , 255) as nm_plano_financeiro,
      pfm.dt_movto_plano_financeiro                                                        as dt_lancamento,
      pfm.vl_plano_financeiro                                                              as vl_lancamento,
      tof.nm_tipo_operacao                                                                 as nm_tipo_operacao_fiscal,
      tof.sg_tipo_operacao                                                                 as sg_tipo_operacao_fiscal,
      hf.nm_historico_financeiro                                                           as nm_historico_padrao,
      pfm.nm_historico_movimento                                                           as nm_complemento,
      pfm.cd_moeda,
      m.nm_moeda + ' - ' + m.sg_moeda                                                      as nm_moeda,
      cc.nm_centro_custo,
      cc.cd_mascara_centro_custo     

    from 
      Plano_financeiro_movimento pfm               with (nolock) 
      Left Outer Join Plano_Financeiro         pf  with (nolock) on pfm.cd_plano_financeiro     = pf.cd_plano_financeiro
      Left Outer Join Tipo_Operacao_Financeira tof with (nolock) on pfm.cd_tipo_operacao        = tof.cd_tipo_operacao
      Left Outer Join Historico_Financeiro     hf  with (nolock) on pfm.cd_historico_financeiro = hf.cd_historico_financeiro
      Left Outer Join Moeda m                      with (nolock) on pfm.cd_moeda                = m.cd_moeda
      Left Outer Join Centro_Custo cc              with (nolock) on pfm.cd_centro_custo         = cc.cd_centro_custo

    where
      pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
      pfm.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo        and
      pfm.cd_plano_financeiro      = case when @cd_plano_financeiro = 0 then pfm.cd_plano_financeiro else @cd_plano_financeiro end

--     union all
-- 
--     --Caixa
--     Select
--       'CX-' + LTrim(RTrim(str(cl.cd_lancamento_caixa))) cd_codigo,
--       Substring(pf.cd_mascara_plano_financeiro+' - '+pf.nm_conta_plano_financeiro,1 , 255) nm_plano_financeiro,
--       cl.dt_lancamento_caixa dt_lancamento,
--       cl.vl_lancamento_caixa vl_lancamento,
--       tof.nm_tipo_operacao                                      as nm_tipo_operacao_fiscal,
--       tof.sg_tipo_operacao                                      as sg_tipo_operacao_fiscal,
--       hf.nm_historico_financeiro nm_historico_padrao,
--       IsNull(cl.nm_historico_lancamento + ' - ','') + tc.nm_tipo_caixa as nm_complemento,
--       cl.cd_moeda,
--       m.nm_moeda + ' - ' + m.sg_moeda                                  as nm_moeda
--     From
--       Caixa_Lancamento cl
--       Left Outer Join Plano_Financeiro pf          on cl.cd_plano_financeiro = pf.cd_plano_financeiro
--       Left Outer Join Tipo_Operacao_Financeira tof on cl.cd_tipo_operacao = tof.cd_tipo_operacao
--       Left Outer Join Historico_Financeiro hf      on cl.cd_historico_Financeiro = hf.cd_historico_financeiro
--       Left Outer Join Tipo_Caixa tc                on cl.cd_tipo_caixa = tc.cd_tipo_caixa
--       Left Outer Join Moeda m                      on cl.cd_moeda = m.cd_moeda
--     Where
--       (cl.cd_plano_financeiro = @cd_plano_financeiro or @cd_plano_financeiro = 0) and
--        cl.dt_lancamento_caixa between @dt_inicial and @dt_final

--     union all
--     
--     --Lancamentos do Banco
--     Select
--       'BC-' + LTrim(RTrim(str(bl.cd_lancamento))) as cd_codigo,
--       Substring(pf.cd_mascara_plano_financeiro+' - '+pf.nm_conta_plano_financeiro,1 , 255) as nm_plano_financeiro,
--       bl.dt_lancamento,
--       bl.vl_lancamento,
--       tof.nm_tipo_operacao        as nm_tipo_operacao_fiscal,
--       tof.sg_tipo_operacao        as sg_tipo_operacao_fiscal,
--       hf.nm_historico_financeiro  as nm_historico_padrao,
--       IsNull(bl.nm_historico_lancamento + ' - ','') + IsNull(d.nm_diversos,'') as nm_complemento,
--       bl.cd_moeda,
--       m.nm_moeda + ' - ' + m.sg_moeda as nm_moeda
--     From
--       Conta_Banco_Lancamento bl
--       Left Outer join Plano_Financeiro pf          on bl.cd_plano_financeiro     = pf.cd_plano_financeiro
--       Left Outer Join Tipo_Operacao_financeira tof on bl.cd_tipo_operacao        = tof.cd_tipo_operacao
--       Left Outer Join Historico_Financeiro hf      on bl.cd_historico_financeiro = hf.cd_historico_financeiro
--       Left Outer Join Moeda m                      on bl.cd_moeda = m.cd_moeda
--       Left Outer Join
--       (select b.nm_banco+' - '+a.cd_numero_agencia_banco+' - c/c: '+c.nm_conta_banco nm_diversos, c.cd_conta_banco
--        from conta_agencia_banco c, banco b, agencia_banco a
--        where c.cd_banco = b.cd_banco and c.cd_agencia_banco = a.cd_agencia_banco) d
--         on bl.cd_conta_banco = d.cd_conta_banco
--     where
--       bl.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo and
--       (bl.cd_plano_financeiro = @cd_plano_financeiro or @cd_plano_financeiro = 0) and
--       bl.dt_lancamento between @dt_inicial and @dt_final
--     order by 
--       nm_plano_financeiro

