
--USE EGISSQL
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_prestacao_conta
-------------------------------------------------------------------------------
--pr_resumo_prestacao_conta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Resumo de Prestação de Contas 
--Data             : 28/05/2007
--Alteração        : Ajustes Diversos - Carlos Fernandes
-- 16.11.2007 - Acerto do Projeto para buscar na composição
-- 25.01.2008 - Ajustes de Colunas dos valores - Carlos Fernandes
-- 12.05.2008 - Observação / Cliente - Carlos Fernandes
-- 04.07.2008 - Centro Custo - Carlos Fernandes
-- 11.08.2008 - Quando for Fornecedor tem que ser mostrado o campo de funcionário - Carlos Fernandes
----------------------------------------------------------------------------------------------------
create procedure pr_resumo_prestacao_conta
@ic_parametro        int         = 0,
@dt_inicial          datetime    = '',
@dt_final            datetime    = '',
@cd_funcionario      int         = 0,
@cd_departamento     int         = 0,
@cd_centro_custo     int         = 0,
@cd_projeto_viagem   int         = 0,
@cd_tipo_viagem      int         = 0,
@cd_tipo_despesa     int         = 0,
@cd_moeda            int         = 0,
@nm_obs_item_despesa varchar(40) = '',
@nm_cliente_despesa  varchar(40) = ''
as

--select * from prestacao_conta
--select * from prestacao_conta_composicao

------------------------------------------------------------------------------
--Resumo
------------------------------------------------------------------------------

if @ic_parametro = 1

begin

  select
    pc.cd_prestacao,
    f.nm_funcionario                             as Funcionario,
    d.nm_departamento                            as Departamento,
    cc.sg_centro_custo                           as CC,
    cc.nm_centro_custo                           as CentroCusto,
    isnull(pv.cd_identificacao_projeto,'')       as Identificacao,
    isnull(pv.nm_projeto_viagem,'')              as Projeto,
    isnull(tv.nm_tipo_viagem,'')                 as TipoViagem,

    --Total de Adiantamentos

    isnull(( select
        sum( isnull(sa.vl_adiantamento,0) )
      from
        Solicitacao_Adiantamento sa
      where
        sa.cd_prestacao = pc.cd_prestacao ),0)   as TotalAdiantamento,

    --Total de Despesas

--     isnull(( select 
--         sum ( isnull(vl_total_despesa,0) )
--       from
--         prestacao_conta_composicao pcc with (nolock) 
--       where
--         pcc.cd_prestacao = pc.cd_prestacao ),0)  as TotalDespesa,

     --Somente as Despesas Reembolsáveis

     dbo.fn_total_despesa_prestao_conta(pc.cd_prestacao) as TotalDespesa, 

    --Despesa Não Reembolsável

    isnull((select
       isnull(sum( isnull(vl_total_despesa,0) ),0)
     from
       prestacao_conta_composicao pcc with (nolock) 
       left join tipo_despesa td      with (nolock) on td.cd_tipo_despesa = pcc.cd_tipo_despesa  
     where
       pcc.cd_prestacao = pc.cd_prestacao and
       isnull(td.ic_reembolsavel_despesa,'N') = 'N' ),0) as TotalNaoReembolsavel,


    --Despesa Reembolsável

    isnull((select
       isnull(sum( isnull(vl_total_despesa,0) ),0)
     from
       prestacao_conta_composicao pcc with (nolock) 
       left join tipo_despesa td      with (nolock) on td.cd_tipo_despesa = pcc.cd_tipo_despesa  
     where
       pcc.cd_prestacao = pc.cd_prestacao and
       isnull(td.ic_reembolsavel_despesa,'N') = 'S' ),0) as TotalReembolsavel,
    tc.nm_cartao_credito,

    case when pc.ic_tipo_deposito_prestacao='F' 
    then
      isnull(pc.vl_prestacao,0)
    else
      0.00
    end                                as vl_pagamento_funcionario,

    case when pc.ic_tipo_deposito_prestacao='E'
    then
      isnull(pc.vl_prestacao,0) * -1
    else
      0.00
    end                                as vl_pagamento_empresa

   into
     #ResumoViagem

   from
     Prestacao_Conta pc                          with (nolock) 
     left outer join Funcionario f               with (nolock) on f.cd_funcionario        = pc.cd_funcionario
     left outer join Departamento d              with (nolock) on d.cd_departamento       = pc.cd_departamento
     left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo      = pc.cd_centro_custo
     left outer join Requisicao_Viagem rv        with (nolock) on rv.cd_requisicao_viagem = pc.cd_requisicao_viagem
     left outer join Projeto_Viagem    pv        with (nolock) on pv.cd_projeto_viagem    = 
                                                                  case when isnull(rv.cd_projeto_viagem,0)>0 then
                                                                    rv.cd_projeto_viagem
                                                                  else
                                                                    case when isnull(pc.cd_projeto_viagem,0)>0 then
                                                                      pc.cd_projeto_viagem
                                                                    else
                                                                      ( select top 1 cd_projeto_viagem from prestacao_conta_composicao where cd_prestacao = pc.cd_prestacao and cd_projeto_viagem>0 )
                                                                    end
                                                                  end
 
     left outer join Tipo_Viagem       tv        with (nolock) on tv.cd_tipo_viagem       = rv.cd_tipo_viagem
     --left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao         = pc.cd_prestacao
     left outer join Tipo_Cartao_Credito tc      with (nolock) on tc.cd_cartao_credito    = pc.cd_cartao_credito
   where
     pc.dt_prestacao between @dt_inicial and @dt_final and
     pc.cd_funcionario    = case when @cd_funcionario    = 0 then pc.cd_funcionario    else @cd_funcionario    end and
     pc.cd_departamento   = case when @cd_departamento   = 0 then pc.cd_departamento   else @cd_departamento   end and
     pc.cd_centro_custo   = case when @cd_centro_custo   = 0 then pc.cd_centro_custo   else @cd_centro_custo   end and
--     pc.cd_projeto_viagem = case when @cd_projeto_viagem = 0 then pc.cd_projeto_viagem else @cd_projeto_viagem end and
     1=1     



   declare @vl_total decimal(25,2)

   select
     @vl_total = sum( isnull(TotalDespesa,0) )
   from
     #ResumoViagem

   select
     *,
     Resultado = (isnull(TotalDespesa,0) - isnull(TotalAdiantamento,0)) *
                 (case when isnull(TotalDespesa,0) - isnull(TotalAdiantamento,0)>0 
                 then 1 else -1 end ),

     Tipo      = case when isnull(TotalDespesa,0) - isnull(TotalAdiantamento,0)>0 
                 then 'E'
                 else 'F' end,
      
     Perc      = (isnull(TotalDespesa,0)/@vl_total)*100

   from
     #ResumoViagem
   

end


------------------------------------------------------------------------------
--Analítico
------------------------------------------------------------------------------
--select * from prestacao_conta

if @ic_parametro = 2

begin

  select
    pc.cd_prestacao                              as Codigo,
    pc.dt_prestacao                              as DataPrestacao,
    f.nm_funcionario                             as Funcionario,
    d.nm_departamento                            as Departamento,
    cc.sg_centro_custo                           as CC,
    cc.nm_centro_custo                           as CentroCusto,
    pv.cd_identificacao_projeto                  as Identificacao,
    pv.nm_projeto_viagem                         as Projeto,
    tv.nm_tipo_viagem                            as TipoViagem,
    rv.cd_requisicao_viagem                      as RV,
    pc.vl_prestacao                              as ValorPrestacao,
    pc.dt_fechamento_prestacao                   as DataFechamento,
    pc.cd_ap                                     as AP,

    --Total de Adiantamentos

    isnull(( select
        sum( isnull(sa.vl_adiantamento,0) )
      from
        Solicitacao_Adiantamento sa
      where
        sa.cd_prestacao = pc.cd_prestacao ),0)   as TotalAdiantamento,

    --Total de Despesas

--     isnull(( select 
--         sum ( isnull(vl_total_despesa,0) )
--       from
--         prestacao_conta_composicao pcc
--       where
--         pcc.cd_prestacao = pc.cd_prestacao ),0)  as TotalDespesa,

     dbo.fn_total_despesa_prestao_conta(pc.cd_prestacao) as TotalDespesa, 

    --Despesa Não Reembolsável

    isnull((select
       isnull(sum(vl_total_despesa),0)
     from
       prestacao_conta_composicao pcc
       left join tipo_despesa td on td.cd_tipo_despesa = pcc.cd_tipo_despesa  
     where
       pcc.cd_prestacao = pc.cd_prestacao and
       isnull(td.ic_reembolsavel_despesa,'N') = 'N' ),0) as TotalNaoReembolsavel,

    --Despesa Reembolsável

    isnull((select
       isnull(sum(vl_total_despesa),0)
     from
       prestacao_conta_composicao pcc
       left join tipo_despesa td on td.cd_tipo_despesa = pcc.cd_tipo_despesa  
     where
       pcc.cd_prestacao = pc.cd_prestacao and
       isnull(td.ic_reembolsavel_despesa,'N') = 'S' ),0) as TotalReembolsavel,

    tc.nm_cartao_credito,

    case when pc.ic_tipo_deposito_prestacao='F' 
    then
      isnull(pc.vl_prestacao,0)
    else
      0.00
    end                                as vl_pagamento_funcionario,

    case when pc.ic_tipo_deposito_prestacao='E'
    then
      isnull(pc.vl_prestacao,0) * -1
    else
      0.00
    end                                as vl_pagamento_empresa


   from
     Prestacao_Conta pc                          with (nolock) 
     left outer join Funcionario f               with (nolock) on f.cd_funcionario        = pc.cd_funcionario
     left outer join Departamento d              with (nolock) on d.cd_departamento       = pc.cd_departamento
     left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo      = pc.cd_centro_custo
     left outer join Requisicao_Viagem rv        with (nolock) on rv.cd_requisicao_viagem = pc.cd_requisicao_viagem
     left outer join Projeto_Viagem    pv        with (nolock) on pv.cd_projeto_viagem    = rv.cd_projeto_viagem
     left outer join Tipo_Viagem       tv        with (nolock) on tv.cd_tipo_viagem       = rv.cd_tipo_viagem
     left outer join Tipo_Cartao_Credito tc      with (nolock) on tc.cd_cartao_credito    = pc.cd_cartao_credito

     --left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao         = pc.cd_prestacao

   where
     pc.dt_prestacao between @dt_inicial and @dt_final and
     pc.cd_funcionario  = case when @cd_funcionario  = 0 then pc.cd_funcionario  else @cd_funcionario  end and
     pc.cd_departamento = case when @cd_departamento = 0 then pc.cd_departamento else @cd_departamento end and
     pc.cd_centro_custo = case when @cd_centro_custo = 0 then pc.cd_centro_custo else @cd_centro_custo end 

end


------------------------------------------------------------------------------
--Despesas
------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  select
    td.nm_tipo_despesa                           as TipoDespesa,
    sum( isnull(pcc.vl_total_despesa,0))         as TotalDespesa
--    sum( dbo.fn_total_despesa_prestao_conta( pc.cd_prestacao )) as TotalDespesa


   into
     #Despesa

   from
     Prestacao_Conta pc                          with (nolock) 
     inner join Prestacao_Conta_composicao pcc   with (nolock) on pcc.cd_prestacao        = pc.cd_prestacao
     left join tipo_despesa td                   with (nolock) on td.cd_tipo_despesa      = pcc.cd_tipo_despesa  
     left outer join Funcionario f               with (nolock) on f.cd_funcionario        = pc.cd_funcionario
     left outer join Departamento d              with (nolock) on d.cd_departamento       = pc.cd_departamento
     left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo      = pc.cd_centro_custo
     left outer join Requisicao_Viagem rv        with (nolock) on rv.cd_requisicao_viagem = pc.cd_requisicao_viagem
     left outer join Projeto_Viagem    pv        with (nolock) on pv.cd_projeto_viagem    = rv.cd_projeto_viagem
     left outer join Tipo_Viagem       tv        with (nolock) on tv.cd_tipo_viagem       = rv.cd_tipo_viagem
     --left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao         = pc.cd_prestacao

   where
     pc.dt_prestacao between @dt_inicial and @dt_final and
     pc.cd_funcionario  = case when @cd_funcionario  = 0 then pc.cd_funcionario  else @cd_funcionario  end and
     pc.cd_departamento = case when @cd_departamento = 0 then pc.cd_departamento else @cd_departamento end and
     pc.cd_centro_custo = case when @cd_centro_custo = 0 then pc.cd_centro_custo else @cd_centro_custo end 
     and isnull(td.ic_reembolsavel_despesa,'S') = 'S'

   group by
    td.nm_tipo_despesa


   declare @vl_total_despesa decimal(25,2)

   select 
     @vl_total_despesa = sum( isnull(totaldespesa,0))
   from
     #Despesa


   select
     *,
     Perc = (TotalDespesa/@vl_total_despesa)*100 
   from
     #Despesa

end


------------------------------------------------------------------------------
--Detalhe Geral por Tipo de Despesa
------------------------------------------------------------------------------

if @ic_parametro = 4

begin
  select
    identity(int,1,1)                            as cd_controle,     
    pc.cd_prestacao,
    isnull(pc.qt_item_despesa,0)                 as Quantidade,
    pc.nm_tipo_despesa                           as Despesa,
    pc.cd_prestacao                              as Codigo,
    pc.dt_prestacao                              as DataPrestacao,
    pc.cd_item_prestacao                         as Item,
    pc.nm_funcionario                            as Funcionario,
    pc.nm_departamento                           as Departamento,
    pc.sg_centro_custo                           as CC,
    pc.nm_centro_custo                           as CentroCusto,
    pc.cd_identificacao_projeto                  as Identificacao,
    pc.nm_projeto_viagem                         as Projeto,
    pc.nm_tipo_viagem                            as TipoViagem,
    pc.cd_requisicao_viagem                      as RV,
    pc.vl_prestacao                              as ValorPrestacao,
    pc.dt_fechamento_prestacao                   as DataFechamento,
    pc.cd_ap                                     as AP,

    --Total de Adiantamentos

    isnull(( select
        sum( isnull(sa.vl_adiantamento,0) )
      from
        Solicitacao_Adiantamento sa
      where
        sa.cd_prestacao = pc.cd_prestacao ),0)           as TotalAdiantamento,

    --Total de Despesas

     pc.vl_total_despesa                                 as TotalDespesa,

    pc.nm_cartao_credito,
    isnull(pc.nm_obs_item_despesa,'')                    as nm_obs_item_despesa,
    isnull(pc.nm_cliente_despesa,'')                     as nm_cliente_despesa

   into
     #Detalhe

   from
     vw_resumo_prestacao_conta_composicao pc

   where
     pc.dt_prestacao between @dt_inicial and @dt_final and
     pc.cd_funcionario  = case when @cd_funcionario  = 0 then pc.cd_funcionario  else @cd_funcionario  end and
     pc.cd_departamento = case when @cd_departamento = 0 then pc.cd_departamento else @cd_departamento end and
     pc.cd_centro_custo = case when @cd_centro_custo = 0 then pc.cd_centro_custo else @cd_centro_custo end and
     isnull(pc.ic_reembolsavel_despesa,'S') = 'S'                                                          and
     isnull(pc.nm_cliente_despesa,'') like '%'+ case when @nm_cliente_despesa = '' then isnull(pc.nm_cliente_despesa,'') 
                                                                           else @nm_cliente_despesa end +'%' and

     isnull(pc.nm_obs_item_despesa,'') like '%'+ case when @nm_obs_item_despesa = '' then isnull(pc.nm_obs_item_despesa,'') 
                                                                           else @nm_obs_item_despesa end +'%'


   select
     *
   from
     #Detalhe
   order by cd_prestacao desc 


end

