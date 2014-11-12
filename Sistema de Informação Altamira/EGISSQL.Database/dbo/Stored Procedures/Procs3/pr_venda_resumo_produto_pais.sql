
CREATE PROCEDURE pr_venda_resumo_produto_pais
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Vendas no Período por Estado.
--Data          : 05/09/2002
--Atualizado    : 29/08/2003
-- Incluído filtro e campo de País - Daniel C. NEto.
-- 06/11/2003 - Incluído filtro por moeda - Daniel C. Neto.
-- 05/01/2004 - Mudança para usar view nova - Daniel c. Neto.
-- 27.04.2004 - Inclusão de coluna de valor líquido, utilizando função 
--              de valor líquido. Igor Gama
-- 20/09/2004 - Modificado cálculo de outra moeda, agora vai dividir em vez de multiplicar
--            - Daniel C. Neto.

---------------------------------------------------
@cd_pais    int = 1,
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int = 1
as

  declare @vl_moeda float

  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                    else dbo.fn_vl_moeda(@cd_moeda) end )


  set @cd_pais   = isnull(@cd_pais,0)
  set @cd_moeda  = isnull(@cd_moeda,1)

  -- Geração da tabela auxiliar de Vendas por Segmento
  select 
    cd_pais,
    case IsNull(a.cd_produto,0)
      when 0 then
        a.nm_categoria_produto
      else
        a.nm_fantasia_produto  
    end                                                                  as nm_fantasia_produto, --Ludinei
    a.cd_produto, 
    sum(qt_item_pedido_venda)            as 'Qtd',
    sum(qt_item_pedido_venda * vl_unitario_item_pedido / @vl_moeda)    as 'Venda',
    sum(dbo.fn_vl_liquido_venda('V',(vl_unitario_item_pedido * qt_item_pedido_venda) / @vl_moeda, 
                                 pc_icms, pc_ipi, cd_destinacao_produto, @dt_inicial)) as 'TotalLiquido',
    cast(sum((a.qt_item_pedido_venda *(a.vl_lista_item_pedido / @vl_moeda))) as decimal(25,2)) as 'TotalLista'  
  into #VendaGrupoAux
  from
     vw_venda_bi a
  where
     (dt_pedido_venda between @dt_inicial and @dt_final )  and
     isnull(cd_pais,0) = case isnull(@cd_pais,0) when 0 then isnull(cd_pais,0) else isnull(@cd_pais,0) end         
  Group by cd_pais,     a.cd_produto, 
    (case IsNull(a.cd_produto,0)
      when 0 then
        a.nm_categoria_produto
      else
        a.nm_fantasia_produto  
    end),
	 a.cd_categoria_produto  
  order  by 1 desc

  --Cria a Tabela Final de Vendas por Grupo
  select 
    dbo.fn_mascara_produto(b.cd_produto) as cd_mascara_produto,  
 	 b.nm_fantasia_produto, 
    b.nm_produto,  
    un.sg_unidade_medida,  
    a.cd_pais,
    d.nm_pais,
    a.venda,
    a.qtd,
    a.TotalLiquido,
    a.TotalLista
  Into 
  	#VendaGrupo
  from 
  	#VendaGrupoAux a left outer join 
    Pais d  on a.cd_pais = d.cd_pais left join
    Produto b on a.cd_produto = b.cd_produto   left outer join   
    Unidade_Medida un on un.cd_unidade_medida = b.cd_unidade_medida 
  order by a.Venda desc

  select * from #VendaGrupo  
  order by nm_fantasia_produto

