CREATE PROCEDURE pr_maior_custo_bitola
---------------------------------------------------------------------------------------
--pr_maior_custo_bitola
---------------------------------------------------------------------------------------
--GBS - Global Business Solution               2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s): Elias Pereira da Silva
--Banco de Dados: EGISSQL
--Objetivo   : Consultar os Maiores Custos das Bitolas
--Data       : 01/11/2004
--           : 01.08.2005 - Revisão Geral - Carlos Fernandes
--                        - Modificado a Quantidade de Placa para o Peso Bruto - Carlos Fernandes
--                        - qt_pesbru_nota_entrada
--           : 03/10/2005 - Refeito procedure - ELIAS
--           : 04/10/2005 - Ajuste para Buscar a Tabela de Histórico de Custo da Bitola - ELIAS
--           : 05/10/2005 - Converter de Tonelada para Kilo - ELIAS
--           : 19/10/2005 - Ajuste para listar todas as Bitolas, independente de estarem cadastradas
--                          no produto_custo - ELIAS
--           : 22/02/2006 - Ajuste para demonstrar corretamente quando custos de anos anteriores - ELIAS
--           : 27/09/2006 - Ajuste filtrando Revenda - ELIAS
-------------------------------------------------------------------------------------------------
@ic_parametro integer,
@dt_inicial   datetime,
@dt_final     datetime,
@cd_usuario   int = 0

as

declare @dt_inicial_ano datetime
set @dt_inicial_ano = cast('01/01/'+cast(year(@dt_final) as varchar) as datetime)

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Tipo de Consulta Analítica
-------------------------------------------------------------------------------
begin

  -----------------------------------------------------------------------------
  -- BITOLAS
  -----------------------------------------------------------------------------
  select b.cd_bitola as CodBitola, 
    null as CodMatPrima,
    b.nm_fantasia_bitola as Bitola,
    b.nm_bitola as Descricao
  into #Bitola
  from Bitola b with(nolock)
  group by b.cd_bitola, b.nm_fantasia_bitola, b.nm_bitola

  create index IX_#Bitola on #Bitola (CodBitola)

  -----------------------------------------------------------------------------
  -- HISTORICO DO CUSTO DA BITOLA - DENTRO DO ANO
  -----------------------------------------------------------------------------
  select
    b.CodBitola,     
    f.nm_fantasia_fornecedor as Fornecedor,
    bmc.cd_fornecedor as CodFornecedor,
    cast(bmc.cd_nota_entrada as varchar) as NFE,
    bmc.dt_nota_entrada as Data,
    cast(bmc.vl_maior_custo_anterior as decimal(25,2)) as CustoAnterior,
    cast(bmc.vl_maior_custo_periodo as decimal(25,2)) as CustoPeriodo,
    bmc.dt_maior_custo as DataApuracao
  into
    #BitolaHistorico
  from
    #Bitola b
    left outer join Bitola_Maior_Custo bmc with(nolock)on b.CodBitola = bmc.cd_bitola
    left outer join Fornecedor f with(nolock) on f.cd_fornecedor = bmc.cd_fornecedor
  where
    bmc.dt_maior_custo = (select max(a.dt_maior_custo)
                          from Bitola_Maior_Custo a with(nolock)
                          where a.cd_bitola = b.CodBitola and
                            a.dt_maior_custo between @dt_inicial_ano and @dt_final)

  -----------------------------------------------------------------------------
  -- HISTORICO DO CUSTO DA BITOLA - ANOS ANTERIORES
  -----------------------------------------------------------------------------
  select
    b.CodBitola,
    f.nm_fantasia_fornecedor as Fornecedor,
    cast(bmc.cd_nota_entrada as varchar) as NFE,
    bmc.dt_nota_entrada as Data,
    cast(bmc.vl_maior_custo_periodo as decimal(25,2)) as CustoPeriodo,
    bmc.dt_maior_custo as DataApuracao
  into
    #BitolaHistoricoAnterior
  from
    #Bitola b
    left outer join Bitola_Maior_Custo bmc with(nolock)on b.CodBitola = bmc.cd_bitola
    left outer join Fornecedor f with(nolock) on f.cd_fornecedor = bmc.cd_fornecedor
  where
    bmc.dt_maior_custo = (select max(a.dt_maior_custo)
                          from Bitola_Maior_Custo a with(nolock)
                          where a.cd_bitola = b.CodBitola and
                            a.dt_maior_custo < @dt_inicial_ano)

  -----------------------------------------------------------------------------
  -- BITOLAS PROCESSADAS - ANOS ANTERIORES
  -----------------------------------------------------------------------------
  select
    b.CodBitola,
    f.nm_fantasia_fornecedor as Fornecedor,
    cast(bmch.cd_nota_entrada as varchar) as NFE,
    bmch.dt_nota_entrada as Data,
    cast(bmch.vl_custo_historico as decimal(25,2)) as CustoPeriodo,
    bmch.dt_custo_historico as DataApuracao
  into
    #BitolaHistoricoProcessadaAnterior
  from
    #Bitola b
    left outer join Bitola_Maior_Custo_Historico bmch with(nolock)on b.CodBitola = bmch.cd_bitola
    left outer join Fornecedor f with(nolock) on f.cd_fornecedor = bmch.cd_fornecedor
  where
    bmch.dt_custo_historico = (select max(a.dt_custo_historico)
                               from Bitola_Maior_Custo_Historico a with(nolock)
                               where a.cd_bitola = b.CodBitola and
                                 a.dt_custo_historico < @dt_inicial_ano)

  create index IX_#BitolaHistorico on #BitolaHistorico (CodBitola)
  create index IX_#BitolaHistoricoApuracao on #BitolaHistorico (DataApuracao)
  create index IX_#BitolaHistoricoAnterior on #BitolaHistoricoAnterior (CodBitola)
  create index IX_#BitolaHistoricoAnteriorApuracao on #BitolaHistoricoAnterior (DataApuracao)
  create index IX_#BitolaHistoricoProcessadaAnterior on #BitolaHistoricoProcessadaAnterior (CodBitola)
  create index IX_#BitolaHistoricoProcessadaAnteriorApuracao on #BitolaHistoricoProcessadaAnterior (DataApuracao)

  -----------------------------------------------------------------------------
  -- PEPS DE BITOLA
  -----------------------------------------------------------------------------
  select peps.cd_produto as Produto,
    pc.cd_bitola as CodBitola,
    peps.cd_documento_entrada_peps as NFE,
    f.nm_fantasia_fornecedor as Fornecedor,
    peps.cd_fornecedor as CodFornecedor,
    peps.dt_documento_entrada_peps as Data,
    cast(peps.vl_custo_total_peps / 
       (case when isnull(peps.qt_peso_entrada_peps,0) = 0 
        then 1 
        else (case when (nei.cd_unidade_medida  = 22) -- TONELADA
              then (peps.qt_peso_entrada_peps * 1000)
              else peps.qt_peso_entrada_peps end)
        end) as decimal(25,2)) as CustoPEPS
  into #PEPS
  from Nota_Entrada_Peps peps with(nolock) 
    inner join Nota_Entrada_Item nei with(nolock) on peps.cd_documento_entrada_peps = cast(nei.cd_nota_entrada as varchar) and
                                                     peps.cd_fornecedor = nei.cd_fornecedor and
                                                     peps.cd_produto = nei.cd_produto and
                                                     peps.cd_item_documento_entrada = nei.cd_item_nota_entrada
    inner join Fornecedor f with(nolock) on peps.cd_fornecedor = f.cd_fornecedor
    inner join Produto_Custo pc with(nolock) on peps.cd_produto = pc.cd_produto
    inner join Produto p with(nolock) on p.cd_produto = pc.cd_produto
    inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join #BitolaHistorico bh on bh.CodBitola = pc.cd_bitola
  where peps.cd_fase_produto = 1 and -- BRUTO
    isnull(gp.ic_revenda_grupo_produto,'N') = 'N' and
    peps.dt_documento_entrada_peps between isnull(bh.DataApuracao, @dt_inicial_ano) and @dt_final

  create index IX_#PEPS_Bitola on #PEPS (CodBitola)

--  select * from #PEPS where CodBitola between 674 and 679

  -----------------------------------------------------------------------------
  -- CUSTO ANTERIOR
  -----------------------------------------------------------------------------
  select 
    peps.CodBitola,
    isnull(max(peps.CustoPEPS),0) as CustoAnterior
  into #CustoAnterior
  from #PEPS peps
    left outer join #BitolaHistorico bh on bh.CodBitola = peps.CodBitola
  where (peps.Data between isnull(bh.DataApuracao, @dt_inicial_ano) and @dt_inicial)
  group by peps.CodBitola, bh.CustoAnterior

--  select * from #CustoAnterior where CodBitola between 674 and 679

  -----------------------------------------------------------------------------
  -- CUSTO DO PERIODO
  -----------------------------------------------------------------------------
  select 
    peps.CodBitola,
    isnull(max(peps.CustoPEPS), 0) as CustoPeriodo
  into #CustoPeriodo
  from #PEPS peps
  where (peps.Data between @dt_inicial and @dt_final)
  group by peps.CodBitola

--  select * from #CustoPeriodo where CodBitola between 674 and 679

  -----------------------------------------------------------------------------
  -- MAIOR DATA DO PERIODO ANTERIOR
  -----------------------------------------------------------------------------
  select
    peps.CodBitola,
    max(peps.Data) as Data,
    mcb.CustoAnterior as CustoAnterior
  into
    #DataAnterior
  from #PEPS peps
    inner join #CustoAnterior mcb on mcb.CodBitola = peps.CodBitola and                                         
                                     mcb.CustoAnterior = peps.CustoPEPS
    left outer join #BitolaHistorico bh on bh.CodBitola = peps.CodBitola
  where (peps.Data between isnull(bh.DataApuracao, @dt_inicial_ano) and @dt_inicial)
  group by peps.CodBitola, mcb.CustoAnterior

--  select * from #DataAnterior where CodBitola between 674 and 679

  -----------------------------------------------------------------------------
  -- MAIOR DATA DO PERIODO ATUAL
  -----------------------------------------------------------------------------
  select
    mcb.CodBitola,
    max(peps.Data) as Data,
    mcb.CustoPeriodo as CustoPeriodo
  into
    #DataPeriodo
  from #PEPS peps
    inner join #CustoPeriodo mcb on mcb.CodBitola = peps.CodBitola and                                         
                                    mcb.CustoPeriodo = peps.CustoPEPS
  where (peps.Data between @dt_inicial and @dt_final) 
  group by mcb.CodBitola, mcb.CustoPeriodo

  -----------------------------------------------------------------------------
  -- LISTAGEM COM O CUSTO ANTERIOR, CASO SEJA MAIOR QUE O HISTÓRICO
  -----------------------------------------------------------------------------
  select 
    b.CodBitola,
    b.CodMatPrima,
    b.Bitola,
    b.Descricao,
    case when (isnull(bh.CustoAnterior,0) >= isnull(da.CustoAnterior,0)) then
      bh.NFE
    else
      (select top 1 peps.NFE 
       from #PEPS peps
       where peps.Data = da.Data and
         peps.CodBitola = da.CodBitola and
         peps.CustoPEPS = da.CustoAnterior  
       order by peps.NFE desc) end as NFE,
    case when (isnull(bh.CustoAnterior,0) >= isnull(da.CustoAnterior,0)) then
      bh.Data else da.Data
    end as Data,
    case when (isnull(bh.CustoAnterior,0) >= isnull(da.CustoAnterior,0)) then
      bh.Fornecedor
    else
      (select top 1 peps.Fornecedor
       from #PEPS peps
       where peps.Data = da.Data and
         peps.CodBitola = da.CodBitola and
         peps.CustoPEPS = da.CustoAnterior  
       order by peps.NFE desc) end as Fornecedor,
    case when (isnull(bh.CustoAnterior,0) >= isnull(da.CustoAnterior,0)) then
      bh.CodFornecedor
    else
      (select top 1 peps.CodFornecedor
       from #PEPS peps
       where peps.Data = da.Data and
         peps.CodBitola = da.CodBitola and
         peps.CustoPEPS = da.CustoAnterior  
       order by peps.NFE desc) end as CodFornecedor,
    cast(null as decimal(25,2)) as CustoAtual,
    case when (isnull(bh.CustoAnterior,0) >= isnull(da.CustoAnterior,0)) then
      bh.CustoAnterior else da.CustoAnterior end as CustoAnterior
  into #MaiorCustoBitola
  from #Bitola b
    left outer join #DataAnterior da on b.CodBitola = da.CodBitola 
    left outer join #BitolaHistorico bh on b.CodBitola = bh.CodBitola 

  -----------------------------------------------------------------------------
  -- AJUSTE COM O CÓDIGO DO PERÍODO
  -----------------------------------------------------------------------------
  update #MaiorCustoBitola
  set 
    NFE = case when (isnull(cp.CustoPeriodo,0) <= isnull(mcb.CustoAnterior,0)) then
            NFE
          else 
            (select top 1 peps.NFE
             from #PEPS peps 
             where peps.Data = dp.Data and
               peps.CodBitola = dp.CodBitola and
               peps.CustoPEPS = dp.CustoPeriodo
             order by peps.NFE desc) end,

    Data = case when (isnull(cp.CustoPeriodo,0) <= isnull(mcb.CustoAnterior,0)) then mcb.Data
           else dp.Data end,

    Fornecedor = case when (isnull(cp.CustoPeriodo,0) <= isnull(mcb.CustoAnterior,0)) then
                   mcb.Fornecedor
                 else
                   (select top 1 peps.Fornecedor
                    from #PEPS peps 
                    where peps.Data = dp.Data and
                      peps.CodBitola = dp.CodBitola and
                      peps.CustoPEPS = dp.CustoPeriodo
                    order by peps.NFE desc) end,

    CustoAtual = case when (isnull(cp.CustoPeriodo,0) <= isnull(mcb.CustoAnterior,0)) then
                   mcb.CustoAnterior else cp.CustoPeriodo end

  from #MaiorCustoBitola mcb
    left outer join #DataPeriodo dp on mcb.CodBitola = dp.CodBitola 
    left outer join #CustoPeriodo cp on mcb.CodBitola = cp.CodBitola
    left outer join #DataAnterior da on mcb.CodBitola = da.CodBitola
    left outer join #CustoAnterior ca on mcb.CodBitola = ca.CodBitola


  -----------------------------------------------------------------------------
  -- AJUSTE PARA PREENCHIMENTO DOS CUSTO DOS ANOS ANTERIORES 
  -- (SOMENTE QUANDO NÃO HÁ HISTÓRICO NO ANO CORRENTE)
  -----------------------------------------------------------------------------
  update #MaiorCustoBitola
  set 
    NFE = bha.NFE,
    Data = bha.Data,
    Fornecedor = bha.Fornecedor,
    CustoAtual = bha.CustoPeriodo,
    CustoAnterior = bha.CustoPeriodo
  from #MaiorCustoBitola mcb
    left outer join #BitolaHistoricoProcessadaAnterior bha on mcb.CodBitola = bha.CodBitola 
  where (isnull(mcb.CustoAtual,0) = 0)    

  update #MaiorCustoBitola
  set 
    NFE = bha.NFE,
    Data = bha.Data,
    Fornecedor = bha.Fornecedor,
    CustoAtual = bha.CustoPeriodo,
    CustoAnterior = bha.CustoPeriodo
  from #MaiorCustoBitola mcb
    left outer join #BitolaHistoricoAnterior bha on mcb.CodBitola = bha.CodBitola 
  where (isnull(mcb.CustoAtual,0) = 0)    

  -----------------------------------------------------------------------------
  -- ATUALIZAÇÃO DOS CUSTOS DE BITOLA ARMAZENADOS PARA VALORAÇÃO DOS 
  -- PRODUTOS PADRÃO
  -----------------------------------------------------------------------------
  delete from Bitola_Maior_Custo_Historico
  where dt_custo_historico = @dt_final

  insert into Bitola_Maior_Custo_Historico
  select CodBitola, @dt_final, CustoAtual, @cd_usuario, getDate(), CodFornecedor, NFE, Data
  from #MaiorCustoBitola

  -- SELECT FINAL
  select 
    CodBitola, CodMatPrima, mp.nm_fantasia_mat_prima as Aco, Bitola, Descricao,
    NFE, Data, Fornecedor, CustoAtual, CustoAnterior,
    cast((((CustoAtual/CustoAnterior)-1)*100) as decimal(25,2)) as Variacao
  from #MaiorCustoBitola mcb
    left outer join Materia_Prima mp with(nolock) on mp.cd_mat_prima = mcb.CodMatPrima
  order by 4, 1, 2

  drop index #Bitola.IX_#Bitola 
  drop index #BitolaHistorico.IX_#BitolaHistorico
  drop index #BitolaHistorico.IX_#BitolaHistoricoApuracao
  drop index #BitolaHistoricoAnterior.IX_#BitolaHistoricoAnterior
  drop index #BitolaHistoricoAnterior.IX_#BitolaHistoricoAnteriorApuracao
  drop index #PEPS.IX_#PEPS_Bitola

  drop table #MaiorCustoBitola
  drop table #BitolaHistorico
  drop table #BitolaHistoricoAnterior
  drop table #CustoAnterior
  drop table #CustoPeriodo
  drop table #DataAnterior
  drop table #DataPeriodo
  drop table #Bitola
  drop table #PEPS

end

