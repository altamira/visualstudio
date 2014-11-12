
create procedure pr_consulta_registro_orcamento

@dt_inicial   datetime,
@dt_final     datetime,
@cd_vendedor  int = 0,
@cd_parametro int = 0

as

-- Valor total das Somas
declare @vl_total_orcamento float
set     @vl_total_orcamento = 0

declare @cd_ano int
set     @cd_ano = year(@dt_final)

select ci.cd_consulta,
       ci.cd_item_consulta,
       max(c.dt_consulta)              as dt_consulta,
       max(ci.dt_item_consulta)        as dt_item_consulta,
       max(c.cd_cliente)               as cd_cliente, 
       max(c.cd_vendedor)              as cd_vendedor,
       max(ci.dt_perda_consulta_itens) as dt_perda_consulta_itens,
       max(ci.dt_fechamento_consulta)  as dt_fechamento_consulta,
--        max(ci.qt_item_consulta * 
--            ci.vl_lista_item_consulta)  as ValorTotal,

       round(max(ci.qt_item_consulta * 
           ci.vl_lista_item_consulta),2)  as ValorTotal_Orcado,

       round(max(ci.qt_item_consulta * 
           ci.vl_unitario_item_consulta),2)  as ValorTotal,

       max(ci.cd_categoria_produto)    as cd_categoria_produto,
       month(max(ci.dt_item_consulta)) as MesConsulta,
       year(max(ci.dt_item_consulta))  as AnoConsulta,
       max(ci.qt_item_consulta)        as qt_item_consulta,
       max(ci.cd_pedido_venda)         as cd_pedido_venda,
       max(ci.cd_item_pedido_venda)    as cd_item_pedido_venda
-------
into #Consulta_Itens
-------

from Consulta_Itens ci with (nolock),
     Consulta c        with (nolock)

where 
   --year(ci.dt_item_consulta)     >= @cd_ano      and -- Não têm item de consulta > data orçamento
   year(c.dt_consulta) >= @cd_ano                 and
   isnull(ci.ic_orcamento_consulta,'N')     = 'S' and
    isnull(c.ic_consignacao_consulta,'N')   = 'N' and
   --ci.dt_orcamento_liberado_con  is not null     and
   --isnull(ci.vl_lista_item_consulta,0)     > 0             and

   (ci.qt_item_consulta * ci.vl_unitario_item_consulta) > 0  and

--   isnull(ci.ic_orcamento_comercial,'N')   <> 'S'          and
   ci.cd_consulta                    = c.cd_consulta and
  (@cd_vendedor = 0 or c.cd_vendedor = @cd_vendedor)

group by 
   ci.cd_consulta,
   ci.cd_item_consulta

--select * from #Consulta_Itens


--------------------------------------
-- Início das sub-querys por parâmetro
--------------------------------------

if @cd_parametro = 1 -- RESUMO MENSAL
begin

   select AnoConsulta,
          MesConsulta,
          Sum(ValorTotal) as ValorTotal,
          Count(*)        as Qtd
   -------
   into #Consulta_Itens_Mes
   -------
   from #Consulta_Itens
   group by AnoConsulta,
            MesConsulta

   select 
      max(isnull(cim.Qtd,ci.qt_item_consulta))                      as Qtd,
--      year(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta))   as Ano,
--      month(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta))  as Mes,

--      max(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta))    as Data, 
      year(isnull(cio.dt_orcamento_consulta,ci.dt_consulta))   as Ano,
      month(isnull(cio.dt_orcamento_consulta,ci.dt_consulta))  as Mes,

      max(isnull(cio.dt_orcamento_consulta,ci.dt_consulta))    as Data, 

      sum( isnull(cat.qt_hora_item_orcamento,0))                    as TotalHoras,
      max( isnull(cim.ValorTotal,ci.ValorTotal))                    as ValorTotal
   -------
   into #ResumoMes
   -------
   from
      #Consulta_Itens ci

   left outer join Consulta_Item_Orcamento cio on cio.cd_consulta      = ci.cd_consulta and
                                                  cio.cd_item_consulta = ci.cd_item_consulta

   left outer join #Consulta_Itens_Mes cim     on
                                                  month(cio.dt_orcamento_consulta) = cim.MesConsulta and
                                                  year(cio.dt_orcamento_consulta)  = cim.AnoConsulta
  
   left outer Join Consulta_Item_Orcamento_Cat cat on
                                                   cio.cd_consulta       = cat.cd_consulta and
                                                   cio.cd_item_consulta  = cat.cd_item_consulta and
                                                   cio.cd_item_orcamento = cat.cd_item_orcamento

   where
      --year(cio.dt_orcamento_consulta) = @cd_ano
      --year(ci.dt_item_consulta)=@cd_ano
       year(ci.dt_consulta)=@cd_ano

   Group by 
     --year(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)),month(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)) 
       year(isnull(cio.dt_orcamento_consulta,ci.dt_consulta)),month(isnull(cio.dt_orcamento_consulta,ci.dt_consulta)) 
   order by
--            year(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)) desc, 
--            month(isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)) desc
            year(isnull(cio.dt_orcamento_consulta,ci.dt_consulta)) desc, 
            month(isnull(cio.dt_orcamento_consulta,ci.dt_consulta)) desc

   --Resultado do 1

   select 
      cast(null as varchar(15)) as Cliente,
      cast(null as varchar(20)) as Categoria,
      cast(null as varchar(20)) as Vendedor,
      cast(0 as int)            as Setor,
      cast(0 as float)          as Perc,
      cast(DateName(month,Data) as varchar(20)) as Mes,
      Qtd,
      TotalHoras,
      ValorTotal

   from #ResumoMes

end

else

----------------------------------------------------------------------------

----------------------------------------------------------------------------

if @cd_parametro = 2 -- PERÍODO
begin

   -----------
   -- GERAL --
   -----------
   select 
          ci.dt_consulta                 as DataGeral,
          --ci.dt_item_consulta           as DataGeral,
          Count(*)                      as Qtd,
          Sum(ci.ValorTotal)            as ValorTotal
   -------
   into #Consulta_Itens_Geral
   -------
   from
      #Consulta_Itens ci

   group by 
      ci.dt_consulta
      --ci.dt_item_consulta

   -- Liga com a query agrupada por dia GERAL

   select 
          --isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)       as DataGeral,
          isnull(cio.dt_orcamento_consulta,ci.dt_consulta)       as DataGeral,
          max(rg.Qtd)                     as QtdGeral,
          sum(cat.qt_hora_item_orcamento) as TotalHorasGeral,
          max(rg.ValorTotal)		  as ValorTotalGeral
   -------
   into #ResumoPeriodoGeral
   -------
   from
        #Consulta_Itens ci

   left outer join Consulta_Item_Orcamento cio     on cio.cd_consulta      = ci.cd_consulta and
                                                      cio.cd_item_consulta = ci.cd_item_consulta
 
--   left outer join #Consulta_Itens_Geral rg        on ci.dt_item_consulta = rg.datageral
   left outer join #Consulta_Itens_Geral rg        on ci.dt_consulta = rg.datageral

   left outer Join Consulta_Item_Orcamento_Cat cat on cio.cd_consulta       = cat.cd_consulta and
                                                      cio.cd_item_consulta  = cat.cd_item_consulta and
                                                      cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final
      --ci.dt_item_consulta between @dt_inicial and @dt_final
      ci.dt_consulta between @dt_inicial and @dt_final
   Group by 
--      isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)
      isnull(cio.dt_orcamento_consulta,ci.dt_consulta)

   ---------------
   -- EM ABERTO --
   ---------------

   select 
          --ci.dt_item_consulta           as DataGeral,
          ci.dt_consulta                as DataGeral,
          Count(*)                      as Qtd,
          Sum(ci.ValorTotal)            as ValorTotal
   -------
   into #Consulta_Itens_Aberto
   -------
   from
      #Consulta_Itens ci

   where 
      ci.dt_perda_consulta_itens  is null     and -- Consulta não perdida
      ci.dt_fechamento_consulta   is null         -- Consulta em aberto (sem PV)

   group by 
      --ci.dt_item_consulta
      ci.dt_consulta

   -- Liga com a query agrupada por dia ABERTO

   select 
          --isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)       as DataAberto,
          isnull(cio.dt_orcamento_consulta,ci.dt_consulta)       as DataAberto,
          max(ra.Qtd)                                                 as QtdAberto,
          sum(cat.qt_hora_item_orcamento)                             as TotalHorasAberto,
          max(ra.ValorTotal)		                              as ValorTotalAberto

   -------
   into #ResumoPeriodoAberto
   -------
   from
      #Consulta_Itens ci

   left outer join Consulta_Item_Orcamento cio     on cio.cd_consulta      = ci.cd_consulta and
                                                      cio.cd_item_consulta = ci.cd_item_consulta

--   left outer join #Consulta_Itens_Aberto ra       on ci.dt_item_consulta  = ra.datageral
   left outer join #Consulta_Itens_Aberto ra       on ci.dt_consulta  = ra.datageral

   left outer Join Consulta_Item_Orcamento_Cat cat on cio.cd_consulta       = cat.cd_consulta and
                                                      cio.cd_item_consulta  = cat.cd_item_consulta and
                                                      cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final and
--      ci.dt_item_consulta between @dt_inicial and @dt_final and
      ci.dt_consulta  between @dt_inicial and @dt_final and
      ci.dt_perda_consulta_itens  is null     and -- Consulta não perdida
      ci.dt_fechamento_consulta   is null         -- Consulta em aberto (sem PV)

   Group by 
--      isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)
      isnull(cio.dt_orcamento_consulta,ci.dt_consulta)

   -------------
   -- PERDIDO --
   -------------

   select
         -- ci.dt_item_consulta           as DataGeral,
          ci.dt_consulta                as DataGeral,
          Count(*)                      as Qtd,
          Sum(ci.ValorTotal)            as ValorTotal
   -------
   into #Consulta_Itens_Perda
   -------
   from
      #Consulta_Itens ci

   where 
      ci.dt_perda_consulta_itens  is not null

   group by 
     --ci.dt_item_consulta
     ci.dt_consulta

   -- Liga com a query agrupada por dia PERDA

   select 
          --isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta) as DataPerda,
          isnull(cio.dt_orcamento_consulta,ci.dt_consulta)      as DataPerda,
          max(rp.Qtd)                                           as QtdPerda,
          sum(cat.qt_hora_item_orcamento)                       as TotalHorasPerda,
          max(rp.ValorTotal)		                        as ValorTotalPerda
   -------
   into #ResumoPeriodoPerda
   -------
   from
      #Consulta_Itens ci 

   left outer join  Consulta_Item_Orcamento cio on
                       cio.cd_consulta      = ci.cd_consulta and
                       cio.cd_item_consulta = ci.cd_item_consulta

--   left outer join #Consulta_Itens_Perda rp on ci.dt_item_consulta = rp.datageral

   left outer join #Consulta_Itens_Perda rp on ci.dt_consulta = rp.datageral

   left outer Join Consulta_Item_Orcamento_Cat cat on
   cio.cd_consulta       = cat.cd_consulta and
   cio.cd_item_consulta  = cat.cd_item_consulta and
   cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final and
--      ci.dt_item_consulta between @dt_inicial and @dt_final and
      ci.dt_consulta between @dt_inicial and @dt_final and
      ci.dt_perda_consulta_itens  is not null

   Group by 
      --isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)
    isnull(cio.dt_orcamento_consulta,ci.dt_consulta)

   -------------
   -- FECHADO --
   -------------

   select 
          --ci.dt_item_consulta           as DataGeral,
          ci.dt_consulta                as DataGeral,
          Count(*)                      as Qtd,
          Sum(ci.ValorTotal)            as ValorTotal
   -------
   into #Consulta_Itens_Fechado
   -------
   from
      #Consulta_Itens ci

   where 
   --   ci.dt_perda_consulta_itens is null and  -- Consulta não perdida
   --   ci.dt_fechamento_consulta  is not null  -- Consulta fechada (Virou PV)
     isnull(ci.cd_pedido_venda,0)>0 

   group by 
--      ci.dt_item_consulta
      ci.dt_consulta

   -- Liga com a query agrupada por dia FECHADO

   select 
          --isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)       as DataFechado,
          isnull(cio.dt_orcamento_consulta,ci.dt_consulta)       as DataFechado,
          max(rf.Qtd)                     as QtdFechado,
          sum(cat.qt_hora_item_orcamento) as TotalHorasFechado,
          max(rf.ValorTotal)		  as ValorTotalFechado
   -------
   into #ResumoPeriodoFechado
   -------
   from #Consulta_Itens ci
      
   left outer join Consulta_Item_Orcamento cio  on
                                                   cio.cd_consulta      = ci.cd_consulta and
                                                   cio.cd_item_consulta = ci.cd_item_consulta

--   left outer join #Consulta_Itens_Fechado rf on   ci.dt_item_consulta = rf.datageral
   left outer join #Consulta_Itens_Fechado rf on   ci.dt_consulta = rf.datageral

   left outer Join Consulta_Item_Orcamento_Cat cat on
   cio.cd_consulta       = cat.cd_consulta and
   cio.cd_item_consulta  = cat.cd_item_consulta and
   cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final and
--      ci.dt_item_consulta between @dt_inicial and @dt_final and
      ci.dt_consulta between @dt_inicial and @dt_final and
      ci.dt_perda_consulta_itens is null and  -- Consulta não perdida
      ci.dt_fechamento_consulta  is not null  -- Consulta fechada (Virou PV)

   Group by 
--      isnull(cio.dt_orcamento_consulta,ci.dt_item_consulta)
      isnull(cio.dt_orcamento_consulta,ci.dt_consulta)

   -- Resultado do 2 : FINAL PERÍODO

   select a.DataGeral,
          a.qtdGeral,b.qtdAberto,c.qtdPerda,d.qtdFechado,
          a.ValorTotalGeral,b.ValorTotalAberto,c.ValorTotalPerda,d.ValorTotalFechado,
          a.TotalHorasGeral,b.TotalHorasAberto,c.TotalHorasPerda,d.TotalHorasFechado
   from
      #ResumoPeriodoGeral a,#ResumoPeriodoAberto b,#ResumoPeriodoPerda c, #ResumoPeriodoFechado d
   where
       a.DataGeral *= b.DataAberto and
       a.DataGeral *= c.DataPerda and
       a.DataGeral *= d.DataFechado 

end

else

if @cd_parametro = 3 -- CLIENTES
begin

   select ci.cd_cliente,
          cast(max(cli.nm_fantasia_cliente) as varchar(15)) 
			     as nm_fantasia_cliente,
          Sum(ci.ValorTotal) as ValorTotal,
          Count(*)           as Qtd
   -------
   into #Consulta_Itens_Cliente
   -------
   from #Consulta_Itens ci,
        Cliente cli 
   where ci.cd_cliente = cli.cd_cliente 
--    and
--          exists (select 'x' from consulta_item_orcamento 
--                  where cd_consulta = ci.cd_consulta and 
--                        cd_item_consulta = ci.cd_item_consulta and
--                        year(dt_orcamento_consulta) = @cd_ano)
   group by ci.cd_cliente

   -- Liga com a query agrupada por cliente

   select ci.cd_cliente,
          max(cic.nm_fantasia_cliente)    as Cliente,
          max(ci.cd_vendedor)             as Setor,
          max(cic.Qtd)                    as Qtd,
          sum(cat.qt_hora_item_orcamento) as TotalHoras,
          max(cic.ValorTotal)		  as ValorTotal
   -------
   into #ResumoCliente
   -------
   from
     #Consulta_Itens ci      

   left outer join Consulta_Item_Orcamento cio on
   cio.cd_consulta      = ci.cd_consulta and
   cio.cd_item_consulta = ci.cd_item_consulta

   left outer join #Consulta_Itens_Cliente cic on
   ci.cd_cliente = cic.cd_cliente

   left outer Join Consulta_Item_Orcamento_Cat cat on
   cio.cd_consulta       = cat.cd_consulta and
   cio.cd_item_consulta  = cat.cd_item_consulta and
   cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final
--      ci.dt_item_consulta between @dt_inicial and @dt_final
      ci.dt_consulta between @dt_inicial and @dt_final
   Group by ci.cd_cliente

   -- Total geral de orçamentos
 
   select @vl_total_orcamento = @vl_total_orcamento + ValorTotal
   from #ResumoCliente

   -- Resultado do 3 

   select *, 
      cast(null as varchar(20))                  as Categoria,
      cast(null as varchar(20))                  as Vendedor,
      cast(null as varchar(20))                  as Mes,
     (ValorTotal / @vl_total_orcamento)*100      as Perc
   -------
   from #ResumoCliente
   -------
   order by ValorTotal desc

end

else

if @cd_parametro = 4 -- CATEGORIAS
begin

   select ci.cd_categoria_produto,
          cast(max(cp.sg_categoria_produto) as varchar(20))
			     as sg_categoria_produto,
          Sum(ci.ValorTotal) as ValorTotal,
          Count(*)           as Qtd
   -------
   into #Consulta_Itens_Categoria
   -------
   from #Consulta_Itens ci,
        Categoria_Produto cp
   where ci.cd_categoria_produto = cp.cd_categoria_produto 
-- and
--          exists (select 'x' from consulta_item_orcamento 
--                  where cd_consulta = ci.cd_consulta and 
--                        cd_item_consulta = ci.cd_item_consulta and
--                        year(dt_orcamento_consulta) = @cd_ano)

   group by ci.cd_categoria_produto

   -- Liga com a query agrupada por categoria

   select ci.cd_categoria_produto,
          max(cic.sg_categoria_produto)   as Categoria,    
          max(cic.Qtd)                    as Qtd,
          sum(cat.qt_hora_item_orcamento) as TotalHoras,
          max(cic.ValorTotal)		  as ValorTotal
   -------
   into #ResumoCategoria
   -------
   from
    #Consulta_Itens ci      

   left outer join Consulta_Item_Orcamento cio  on
   cio.cd_consulta      = ci.cd_consulta and
   cio.cd_item_consulta = ci.cd_item_consulta

   left outer join #Consulta_Itens_Categoria cic on
   ci.cd_categoria_produto = cic.cd_categoria_produto

   left outer join Vendedor v on
   ci.cd_vendedor = v.cd_vendedor
 
   left outer Join Consulta_Item_Orcamento_Cat cat on
   cio.cd_consulta       = cat.cd_consulta and
   cio.cd_item_consulta  = cat.cd_item_consulta and
   cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final and
--     ci.dt_item_consulta between @dt_inicial and @dt_final and
     ci.dt_consulta between @dt_inicial and @dt_final and
     (@cd_vendedor = 0 or ci.cd_vendedor = @cd_vendedor)

   Group by ci.cd_categoria_produto

   -- Valor total dos orçamentos

   select @vl_total_orcamento = @vl_total_orcamento + ValorTotal
   from #ResumoCategoria
 
   -- Resultado do 4

   select *,
          cast(null as varchar(15))     	 as Cliente,
          cast(null as varchar(20))     	 as Vendedor,
          cast(0 as int)               		 as Setor,
          cast(null as varchar(20))     	 as Mes,
         (ValorTotal / @vl_total_orcamento)*100  as Perc
   from
      #ResumoCategoria 
   order by ValorTotal desc

end

else

if @cd_parametro = 5 -- VENDEDORES
begin

   select ci.cd_vendedor,
          cast(max(v.nm_fantasia_vendedor) as varchar(20)) 
			     as nm_fantasia_vendedor,
          Sum(ci.ValorTotal) as ValorTotal,
          Count(*)           as Qtd
   -------
   into #Consulta_Itens_Vendedor
   -------
   from #Consulta_Itens ci,
        Vendedor v
   where ci.cd_vendedor = v.cd_vendedor 
-- and
--          exists (select 'x' from consulta_item_orcamento 
--                  where cd_consulta = ci.cd_consulta and 
--                        cd_item_consulta = ci.cd_item_consulta and
--                        year(dt_orcamento_consulta) = @cd_ano)

   group by ci.cd_vendedor

   -- Liga com a query agrupada por vendedor

   select ci.cd_vendedor,
          max(civ.nm_fantasia_vendedor)   as Vendedor, 
          max(civ.Qtd)                    as Qtd,
          sum(cat.qt_hora_item_orcamento) as TotalHoras,
          max(civ.ValorTotal)		  as ValorTotal
   -------
   into #ResumoVendedor
   -------
   from
    #Consulta_Itens ci      

   left outer join Consulta_Item_Orcamento cio on
   cio.cd_consulta      = ci.cd_consulta and
   cio.cd_item_consulta = ci.cd_item_consulta

   left outer join #Consulta_Itens_Vendedor civ on
   ci.cd_vendedor = civ.cd_vendedor

   left outer join Categoria_Produto cp on
   ci.cd_categoria_produto = cp.cd_categoria_produto

   left outer Join Consulta_Item_Orcamento_Cat cat on
   cio.cd_consulta       = cat.cd_consulta and
   cio.cd_item_consulta  = cat.cd_item_consulta and
   cio.cd_item_orcamento = cat.cd_item_orcamento

   Where
      --cio.dt_orcamento_consulta between @dt_inicial and @dt_final
--     ci.dt_item_consulta between @dt_inicial and @dt_final
     ci.dt_consulta between @dt_inicial and @dt_final

   Group by ci.cd_vendedor

   -- Valor total dos orçamentos
 
   select @vl_total_orcamento = @vl_total_orcamento + ValorTotal
   from  #ResumoVendedor

   -- Resultado do 5 

   select cast(null as varchar(20))                     as Categoria,
          cast(null as varchar(15))                     as Cliente,
          cast(0 as int)                                as Setor,
          cast(null as varchar(20))                     as Mes,
          *, 
         (ValorTotal / @vl_total_orcamento)*100 as Perc
   from
      #ResumoVendedor 
   Order by ValorTotal desc

end

