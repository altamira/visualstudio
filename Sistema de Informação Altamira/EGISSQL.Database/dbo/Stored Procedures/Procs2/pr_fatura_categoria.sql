
CREATE  procedure pr_fatura_categoria
@dt_inicial      dateTime,
@dt_final        dateTime,
@cd_moeda        int = 1,
@cd_tipo_mercado int = 0 
as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )


-- Geraçao da tabela auxiliar de Faturas por Categoria

select b.cd_categoria_produto                                                      as 'categoria', 
       sum( isnull(b.qt_item_nota_saida,0) )                                       as 'qtd',
--       sum( isnull(b.qt_item_nota_saida * b.vl_unitario_item_nota * ( 1 - IsNull(b.pc_desconto_item,0) / 100)
--            / @vl_moeda,0) )       as 'venda',   

    sum( (case when isnull(b.cd_item_nota_saida,0)>0 then
      cast((case when IsNull(b.cd_servico,0)=0 and isnull(b.vl_servico,0)=0
      then
        cast(round((isnull(b.vl_unitario_item_nota,0) * ( 1 - IsNull(b.pc_desconto_item,0) / 100) * 
    		(IsNull(b.qt_item_nota_saida,0))),2)
        --Adiciona o IPI
    		+ isnull(b.vl_ipi,0) as money) 
      else
        round(IsNull(b.qt_item_nota_saida,0) * isnull(b.vl_servico,0),2) + 
        (case IsNull(b.ic_iss_servico, 'N') 
          when 'S' then
            isnull(vl_iss,0)
          else
            0.00
          end)
       end) +  --Rateio das despesas - Frete/Seguro/Outras
       IsNull(b.vl_frete_item,0.00) + 
       IsNull(b.vl_seguro_item,0.00) + 
       IsNull(b.vl_desp_acess_item,0.00) as money)
    else
       isnull(a.vl_total,0)
    end)/@vl_moeda )               as 'venda',

       max(a.dt_nota_saida)        as 'UltimaVenda', 
       count(*)                    as 'Pedidos',
       sum( isnull(a.vl_frete,0))  as 'Frete'
       
       
into #FaturaCategoria

from
   Nota_Saida a              with (nolock) inner join
   Nota_Saida_Item b         with (nolock) on b.cd_nota_saida = a.cd_nota_saida left outer join
   Pedido_Venda d            with (nolock) on d.cd_pedido_venda = b.cd_pedido_venda left outer join
   Pedido_Venda_Item c       with (nolock) on c.cd_pedido_venda = d.cd_pedido_venda and
				              c.cd_item_pedido_venda = b.cd_item_pedido_venda left outer join
   Operacao_Fiscal e         with (nolock) on  case when isnull(b.cd_operacao_fiscal,0)=0 then
                                                             a.cd_operacao_fiscal
                                                           else
                                                             b.cd_operacao_fiscal
                                                           end = e.cd_operacao_fiscal
   left outer join
   Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = e.cd_grupo_operacao_fiscal left outer join
   Cliente cli               with (nolock) on a.cd_cliente = cli.cd_cliente              

where  
  (a.dt_nota_saida between @dt_inicial and @dt_final) and  
   isnull(a.vl_total,0) > 0                              and  
   isnull(e.ic_analise_op_fiscal,'N')  = 'S'   and
   isnull(e.ic_comercial_operacao,'N') = 'S'   and     --Considerar apenas as operações fiscais de valor comercial
   gof.cd_tipo_operacao_fiscal = 2               and 
 --  e.cd_tipo_movimento_estoque=11              and  
 
   1 = (case isnull(b.cd_pedido_venda,0)  
           when 0 then 
                1
           else
              (case isnull(d.ic_consignacao_pedido,'N')
              	when 'N' then
 	               1
              	else
                 0
              end) 
		end)	and             
--   a.vl_total > 0                                          and  
   (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) > 0 and
   cli.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then cli.cd_tipo_mercado else @cd_tipo_mercado end        
   and b.cd_status_nota <> 7

Group by b.cd_categoria_produto

Order by 2 desc

-- Devoluções do Mês Corrente

select b.cd_categoria_produto             as 'categoria', 
       sum(b.qt_item_nota_saida)          as 'qtd',
--       sum(b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda) as 'venda',   

    sum( (case when isnull(b.cd_item_nota_saida,0)>0 then
      cast((case when IsNull(b.cd_servico,0)=0 and isnull(b.vl_servico,0)=0
      then
        cast(round((isnull(b.vl_unitario_item_nota,0) * ( 1 - IsNull(b.pc_desconto_item,0) / 100) * 
    		(IsNull(b.qt_item_nota_saida,0))),2)
        --Adiciona o IPI
    		+ isnull(b.vl_ipi,0) as money) 
      else
        round(IsNull(b.qt_item_nota_saida,0) * isnull(b.vl_servico,0),2) + 
        (case IsNull(b.ic_iss_servico, 'N') 
          when 'S' then
            isnull(vl_iss,0)
          else
            0.00
          end)
       end) +  --Rateio das despesas - Frete/Seguro/Outras
       IsNull(b.vl_frete_item,0.00) + 
       IsNull(b.vl_seguro_item,0.00) + 
       IsNull(b.vl_desp_acess_item,0.00) as money)
    else
       isnull(a.vl_total,0)
    end)/@vl_moeda )               as 'venda',

       sum((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_unitario_item_nota ) as 'fatdevolucao'

into #FaturaCategoriaDev
from
   Nota_Saida a        inner join
   Nota_Saida_Item b   on b.cd_nota_saida = a.cd_nota_saida left outer join
   Pedido_Venda d      on d.cd_pedido_venda = b.cd_pedido_venda left outer join
   Pedido_Venda_Item c on c.cd_pedido_venda = d.cd_pedido_venda and
				  c.cd_item_pedido_venda = b.cd_item_pedido_venda left outer join
   Operacao_Fiscal e         with (nolock) on  case when isnull(b.cd_operacao_fiscal,0)=0 then
                                                             a.cd_operacao_fiscal
                                                           else
                                                             b.cd_operacao_fiscal
                                                           end = e.cd_operacao_fiscal left outer join

   Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = e.cd_grupo_operacao_fiscal left outer join
   Cliente cli   on a.cd_cliente = cli.cd_cliente         

where
  (a.dt_cancel_nota_saida between @dt_inicial and @dt_final)  and  
   isnull(e.ic_analise_op_fiscal,'N')='S'      and
   isnull(e.ic_comercial_operacao,'N') = 'S'   and     --Considerar apenas as operações fiscais de valor comercial
   gof.cd_tipo_operacao_fiscal = 2               and 

  e.cd_tipo_movimento_estoque=11                              and  
   1 = (case isnull(b.cd_pedido_venda,0)  
           when 0 then 
                1
           else
              (case isnull(d.ic_consignacao_pedido,'N')
              	when 'N' then
 	               1
              	else
                 0
              end) 
		end)	and
  a.vl_total > 0                                              and  
  (b.qt_item_nota_saida*b.vl_unitario_item_nota/ @vl_moeda) > 0          and  
--  c.ic_smo_item_pedido_venda = 'N'                            and  
  (b.cd_status_nota >= 3                        and --Somente as devolvidas ou parcialmente devolvidas  
   b.cd_status_nota <= 4)      and
	cli.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then cli.cd_tipo_mercado else @cd_tipo_mercado end        
   and b.cd_status_nota <> 7


Group by b.cd_categoria_produto
Order by 2 desc


----------------------------------------------------  
-- Cancelamento do Mês Corrente  
----------------------------------------------------  
select b.cd_categoria_produto           as 'categoria', 
       sum(b.qt_item_nota_saida)          as 'qtd',
--       sum(b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda) as 'venda',   

    sum( (case when isnull(b.cd_item_nota_saida,0)>0 then
      cast((case when IsNull(b.cd_servico,0)=0 and isnull(b.vl_servico,0)=0
      then
        cast(round((isnull(b.vl_unitario_item_nota,0) * ( 1 - IsNull(b.pc_desconto_item,0) / 100) * 
    		(IsNull(b.qt_item_nota_saida,0))),2)
        --Adiciona o IPI
    		+ isnull(b.vl_ipi,0) as money) 
      else
        round(IsNull(b.qt_item_nota_saida,0) * isnull(b.vl_servico,0),2) + 
        (case IsNull(b.ic_iss_servico, 'N') 
          when 'S' then
            isnull(vl_iss,0)
          else
            0.00
          end)
       end) +  --Rateio das despesas - Frete/Seguro/Outras
       IsNull(b.vl_frete_item,0.00) + 
       IsNull(b.vl_seguro_item,0.00) + 
       IsNull(b.vl_desp_acess_item,0.00) as money)
    else
       isnull(a.vl_total,0)
    end)/@vl_moeda )               as 'venda',

       sum((case when isnull(b.qt_devolucao_item_nota,0)>0 then
          b.qt_devolucao_item_nota else b.qt_item_nota_saida end ) * b.vl_unitario_item_nota ) as 'fatdevolucao'

into   
  #FaturaCategoriaAnt

from  
  Nota_Saida a   inner join   
  Nota_Saida_Item b on a.cd_nota_saida = b.cd_nota_saida inner join   

   Operacao_Fiscal e         with (nolock) on  case when isnull(b.cd_operacao_fiscal,0)=0 then
                                                             a.cd_operacao_fiscal
                                                           else
                                                             b.cd_operacao_fiscal
                                                           end = e.cd_operacao_fiscal left outer join

   Grupo_Operacao_Fiscal gof with (nolock) on gof.cd_grupo_operacao_fiscal = e.cd_grupo_operacao_fiscal left outer join
  Pedido_Venda pv on pv.cd_pedido_venda = b.cd_pedido_venda left outer join  
  Pedido_Venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda and b.cd_item_pedido_venda = pvi.cd_item_pedido_venda left outer join  
  Produto_Saldo ps on ps.cd_produto = b.cd_produto and  ps.cd_fase_produto = dbo.fn_fase_produto(0,0)  left outer join
   Cliente cli   on a.cd_cliente = cli.cd_cliente         

WHERE  
   b.cd_status_nota = 7 and                    --Somente as canceladas  
  (a.dt_cancel_nota_saida between @dt_inicial and @dt_final) and  
   isnull(e.ic_analise_op_fiscal,'N')='S'      and
   isnull(e.ic_comercial_operacao,'N') = 'S'   and     --Considerar apenas as operações fiscais de valor comercial
   gof.cd_tipo_operacao_fiscal = 2               and 

   1 = (case isnull(b.cd_pedido_venda,0)  
           when 0 then 
                1
           else
              (case isnull(pv.ic_consignacao_pedido,'N')
              	when 'N' then
 	               1
              	else
                 0
              end) 
 	end)	and
  --Especifica Nota de Saída  
  e.cd_tipo_movimento_estoque=11  and
  cli.cd_tipo_mercado = case when isnull(@cd_tipo_mercado,0) = 0 then cli.cd_tipo_mercado else @cd_tipo_mercado end        
  and b.cd_status_nota <> 7

Group by b.cd_categoria_produto  
Order by 2 desc  



select a.Categoria,
       a.UltimaVenda, 
       a.Pedidos,
       qtd   = (IsNull(a.qtd,0) - ( IsNull(b.qtd,0) + IsNull(c.qtd,0))),  
       venda = (isnull(a.venda,0) - ( isnull(b.venda,0) + isnull(c.venda,0))),
       a.Frete

into #FaturaCategoria1
from #FaturaCategoria a, #FaturaCategoriaDev b, #FaturaCategoriaAnt c

where a.categoria *= b.categoria and
      a.categoria *= c.categoria

declare @qt_total_categ int
declare @vl_total_categ float

-- Total de Categorias
set @qt_total_categ = @@rowcount

-- Total de Vendas Geral por Categoria
set @vl_total_categ     = 0
select @vl_total_categ = @vl_total_categ + venda
from
  #FaturaCategoria1

--Cria a Tabela Final de Vendas por Setor

select IDENTITY(int, 1,1) AS 'Posicao',
       b.nm_categoria_produto,
       b.cd_mascara_categoria,
       a.qtd,
       a.venda, 
      (a.venda/@vl_total_categ)*100 as 'Perc', 
       a.UltimaVenda, 
       a.pedidos,
       a.Frete
Into #FaturaCategoriaAux
from #FaturaCategoria1 a, Categoria_Produto b
Where
       a.categoria = b.cd_categoria_produto
Order by a.venda desc

--Mostra tabela ao usuário

select * from #FaturaCategoriaAux
order by posicao

