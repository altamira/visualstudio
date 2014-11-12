
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_despesa_prestacao_conta
-------------------------------------------------------------------------------
--pr_resumo_despesa_prestacao_conta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 28/05/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_resumo_despesa_prestacao_conta
@ic_parametro      int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@cd_tipo_despesa   int      = 0,
@cd_funcionario    int      = 0

as

--select * from prestacao_conta

if @ic_parametro = 1

begin

  select
    f.nm_funcionario                             as Funcionario,
    d.nm_departamento                            as Departamento,
    cc.sg_centro_custo                           as CC,
    cc.nm_centro_custo                           as CentroCusto,
    pv.cd_identificacao_projeto                  as Identificacao,
    pv.nm_projeto_viagem                         as Projeto,
    tv.nm_tipo_viagem                            as TipoViagem,

    --Total de Adiantamentos

    isnull(( select
        sum( isnull(sa.vl_adiantamento,0) )
      from
        Solicitacao_Adiantamento sa
      where
        sa.cd_prestacao = pc.cd_prestacao ),0)   as TotalAdiantamento,

    --Total de Despesas

    isnull(( select 
        sum ( isnull(vl_total_despesa,0) )
      from
        prestacao_conta_composicao pcc
      where
        pcc.cd_prestacao = pc.cd_prestacao ),0)  as TotalDespesa,

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
       isnull(td.ic_reembolsavel_despesa,'N') = 'S' ),0) as TotalReembolsavel

   into
     #ResumoViagem

   from
     Prestacao_Conta pc                          with (nolock) 
     left outer join Funcionario f               with (nolock) on f.cd_funcionario        = pc.cd_funcionario
     left outer join Departamento d              with (nolock) on d.cd_departamento       = pc.cd_departamento
     left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo      = pc.cd_centro_custo
     left outer join Requisicao_Viagem rv        with (nolock) on rv.cd_requisicao_viagem = pc.cd_requisicao_viagem
     left outer join Projeto_Viagem    pv        with (nolock) on pv.cd_projeto_viagem    = rv.cd_projeto_viagem
     left outer join Tipo_Viagem       tv        with (nolock) on tv.cd_tipo_viagem       = rv.cd_tipo_viagem
     --left outer join Solicitacao_Adiantamento sa with (nolock) on sa.cd_prestacao         = pc.cd_prestacao

   where
     pc.dt_prestacao between @dt_inicial and @dt_final and
     pc.cd_funcionario = case when @cd_funcionario = 0 then pc.cd_funcionario else @cd_funcionario end 

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


--Despesas




