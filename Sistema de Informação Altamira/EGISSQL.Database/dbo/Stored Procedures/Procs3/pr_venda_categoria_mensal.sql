
CREATE PROCEDURE pr_venda_categoria_mensal
   @cd_ano int, --Ano Desejado
   @cd_categoria_produto int,
   @ic_parametro int     --Define qual o tipo de consulta será retornada
                         -- 1-Vendas Realizadas
                         -- 2-Média de Vendas Realizadas
                         -- 3-Quantiade de Vendas Realizadas

                         -- 4-Faturamentos Realizados
                         -- 5-Média de Faturamentos Realizados
                         -- 6-Quantiade de Faturamentos Realizados

as

-- Linha abaixo incluída para rodar no ASP
set nocount on


--Cria  a tabela com os campos que serã retornados
Create table #temp_Select
(
 cd_grupo_categoria  int,
 nm_categoria_produto varchar(40) null,
 vl_Jan Float null,
 vl_Fev Float null,
 vl_Mar Float null,
 vl_Abr Float null,
 vl_Mai Float null,
 vl_Jun Float null,
 vl_Jul Float null, 
 vl_Ago Float null,
 vl_Set Float null,
 vl_Out Float null,
 vl_Nov Float null,
 vl_Dez Float null,
 vl_total_geral Float null)


create table #VendaAnualMes
(
      NumeroMes int null,
      Grupo varchar(40) null,      
      Categoria varchar(40) null,
      Data datetime null,   
      Vendas float null, 
      VendasMedia float null, 
      Pedidos float null
)

if (@ic_parametro > 0) and (@ic_parametro < 4)
begin
    INSERT INTO #VendaAnualMes
    select 
      month(vw.dt_pedido_venda)         as 'NumeroMes',
      vw.cd_grupo_categoria             as 'Grupo',
      vw.nm_categoria_produto           as 'Categoria',
      max(vw.dt_pedido_venda)           as 'Data',   
      sum(vw.qt_item_pedido_venda * 
         vw.vl_unitario_item_pedido)    as 'Vendas', 
      sum(vw.qt_item_pedido_venda * 
          vw.vl_unitario_item_pedido)
      / count('x')                      as 'VendasMedia', 
      sum(vw.qt_item_pedido_venda)      as 'Pedidos'
    from
      vw_venda_bi vw with(nolock)
    where
      year(vw.dt_pedido_venda) = @cd_ano                    and
     (vw.qt_item_pedido_venda * 
      vw.vl_unitario_item_pedido) > 0                       and
     ((vw.cd_categoria_produto = @cd_categoria_produto) or 
       (@cd_categoria_produto = 0))                         and 
      vw.nm_categoria_produto is not null

    group by 
      month(vw.dt_pedido_venda), vw.cd_grupo_categoria, vw.nm_categoria_produto
end
else
begin
    INSERT INTO #VendaAnualMes
    select 
      month(a.dt_nota_saida)           as 'NumeroMes',
      f.cd_grupo_categoria             as 'Grupo',
      f.nm_categoria_produto           as 'Categoria',
      max(a.dt_nota_saida)             as 'Data',   
     sum(b.qt_item_nota_saida * 
         b.vl_unitario_item_nota)      as 'Vendas', 
      sum(b.qt_item_nota_saida * 
          b.vl_unitario_item_nota)
      / count('x')                     as 'VendasMedia', 
      sum(b.qt_item_nota_saida)        as 'Pedidos'
   from
      Nota_Saida a with(nolock),
      Nota_Saida_Item b with(nolock),
      Operacao_Fiscal e with(nolock),
      Categoria_Produto f with(nolock)
   WHERE
      year(a.dt_nota_saida) = @cd_ano                                   and
      a.cd_operacao_fiscal  = e.cd_operacao_fiscal                      and
      e.ic_comercial_operacao = 'S'                                     and
      a.vl_total > 0                                                    and
      a.cd_nota_saida = b.cd_nota_saida                                and     
     ((b.cd_categoria_produto = @cd_categoria_produto) or 
       (@cd_categoria_produto = 0))                         and 
      isnull(a.cd_status_nota,1) = 5                                    and
      (b.dt_restricao_item_nota is null                                 or 
       year(b.dt_restricao_item_nota) = @cd_ano)                         and
      (b.qt_item_nota_saida * b.vl_unitario_item_nota) > 0              and
      f.nm_categoria_produto is not null                                and
      f.cd_categoria_produto = b.cd_categoria_produto 

  group by 
      month(a.dt_nota_saida), f.cd_grupo_categoria, f.nm_categoria_produto

end

--Muda os registro de linha para coluna
INSERT #temp_Select
( cd_grupo_categoria,
  nm_categoria_produto,
  vl_Jan,
  vl_Fev,
  vl_Mar,
  vl_Abr,
  vl_Mai,
  vl_Jun,
  vl_Jul, 
  vl_Ago,
  vl_Set,
  vl_Out,
  vl_Nov,
  vl_Dez,
  vl_total_geral)

SELECT 
  Grupo,
  Categoria,
  case @ic_parametro
  --Janeiro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 1),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 1),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 1),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 1),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 1),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 1),0)
  end,
  --Fevereiro
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 2),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 2),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 2),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 2),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 2),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 2),0)
  end,
  --Março
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 3),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 3),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 3),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 3),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 3),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 3),0)
  end,
  --Abril
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 4),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 4),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 4),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 4),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 4),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 4),0)
  end,
  --Maio
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 5),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 5),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 5),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 5),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 5),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 5),0)
  end,
  --Junho
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 6),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 6),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 6),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 6),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 6),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 6),0)
  end,
  --Julho
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 7),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 7),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 7),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 7),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 7),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 7),0)
  end,
  --Agosto
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 8),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 8),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 8),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 8),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 8),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 8),0)
  end,
  --Setembro
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 9),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 9),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 9),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 9),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 9),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 9),0)
  end,
  --Outubro
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 10),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 10),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 10),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 10),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 10),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 10),0)
  end,
  --Novembro
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 11),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 11),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 11),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 11),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 11),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 11),0)
  end,
  --Dezembro
  case @ic_parametro
  when 1 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 12),0)
  when 2 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 12),0)
  when 3 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 12),0)
  when 4 then
    IsNull((Select top 1 Vendas from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 12),0)
  when 5 then
    IsNull((Select top 1 VendasMedia from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 12),0)
  when 6 then
    IsNull((Select top 1 Pedidos from #VendaAnualMes where Categoria = a.Categoria and NumeroMes = 12),0)
  end,
  case @ic_parametro
  when 1 then
    sum(a.Vendas)
  when 2 then
    sum(a.VendasMedia)
  when 3 then
    sum(a.Pedidos)
  when 4 then
    sum(a.Vendas)
  when 5 then
    sum(a.VendasMedia)
  when 6 then
    sum(a.Pedidos)
  end

FROM #VendaAnualMes a
where Categoria is not null
group by Grupo, Categoria

-- Guarda as Vendas Totais
declare @venda_total float
select @venda_total = sum(vl_total_geral) from #temp_select

-- Tabela FInal para o Usuário! :-)

select IDENTITY(int,1,1) as 'Posicao',
       gp.nm_grupo_categoria,
       b.*,
      (b.vl_total_geral/@venda_total)*100 as 'Perc'

Into #VendaCateg

from #temp_select b, Grupo_Categoria gp with(nolock)
where
  b.cd_grupo_categoria = gp.cd_grupo_categoria

Order by b.nm_categoria_produto desc

select * from #VendaCateg 

drop table #VendaCateg
drop table #temp_Select 

