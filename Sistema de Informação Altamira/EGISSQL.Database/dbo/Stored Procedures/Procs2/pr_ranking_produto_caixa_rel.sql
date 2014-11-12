

-----------------------------------------------------------------------------------  
--GBS - Global Business Sollution S/A                                          2003  
-----------------------------------------------------------------------------------  
--Stored Procedure : SQL Server Microsoft 7.0    
--Carlos Carodoso Fernandes
--Vendas por Produto no Caixa  
--Data       : 04.03.2006
--Atualização:
-----------------------------------------------------------------------------------  
Create procedure pr_ranking_produto_caixa_rel
@dt_inicial dateTime,  
@dt_final   dateTime,  
@cd_moeda   int = 1,
@cd_produto int
as  
  
  declare @vl_moeda float  
  
  set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1  
                    else dbo.fn_vl_moeda(@cd_moeda) end )  
  
  -- Geração da tabela auxiliar de Vendas por Produto  

  Select   
    max(l.nm_loja)                                                          as 'Loja',
    mc.dt_movimento_caixa,         
    a.cd_produto                                                            as 'Produto',   
    sum(a.qt_item_movimento_caixa)                                          as 'Qtd',  
    sum(a.qt_item_movimento_caixa*(a.vl_item_movimento_caixa / @vl_moeda))  as 'Venda'
  into #Venda
  from  
     movimento_caixa mc 
     inner join movimento_caixa_item a on a.cd_movimento_caixa = mc.cd_movimento_caixa
     left outer join loja l            on l.cd_loja            = mc.cd_loja
  where  
    (mc.dt_movimento_caixa between @dt_inicial and @dt_final )    and  
     a.dt_cancel_item is null 
     and a.cd_produto=@cd_produto
      
  group by    
     mc.dt_movimento_caixa,
     a.cd_produto
  order by 1 desc  
    
  declare @qt_total_categ int  
  declare @vl_total_categ float  
    
  -- Total de Produtos  
  set @qt_total_categ = @@rowcount  
    
  -- Total de Vendas Geral por Produto  
  set @vl_total_categ     = 0  
  select @vl_total_categ = @vl_total_categ + venda  
  from  
    #Venda
    
  select IDENTITY(int, 1,1) AS 'Posicao',  
         a.produto,  
         a.qtd,  
         a.venda,   
        (a.venda/@vl_total_categ)*100 as 'Perc',  
         a.loja,
         a.dt_movimento_caixa
         
  into #VendaProduto
  from #Venda a  
  order by a.venda desc  
    
  --Mostra tabela ao usuário  
  select   
         a.*,
         dbo.fn_mascara_produto(b.cd_produto) as cd_mascara_produto,  
         b.nm_fantasia_produto,
         b.nm_produto,  
         un.sg_unidade_medida
  
  from 
    #VendaProduto a
    left outer join  Produto b         on   a.produto = b.cd_produto 
    left outer join  Unidade_medida un on un.cd_unidade_medida = b.cd_unidade_medida  
  order by 
    dt_movimento_caixa, posicao  

