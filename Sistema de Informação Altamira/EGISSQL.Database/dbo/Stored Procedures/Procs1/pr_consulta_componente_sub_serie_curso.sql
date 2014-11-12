
CREATE PROCEDURE pr_consulta_componente_sub_serie_curso

@cd_serie_produto        int,
@cd_sub_serie            int,
@cd_tipo_serie_produto   int,
@cd_tipo_curso_extracao  int,
@ic_montagem_g_sub_serie char(1),
@cd_parametro            int,      -- 0 = Todos os componentes (Sub_Serie + Curso_Extracao)
                                   -- 1 = Somente componentes da Sub_Série
@cd_tipo_montagem        int,      -- X ou Y 
@cd_montagem             int       -- Nro. da Montagem (1..4)

as

  Select
     identity(int,1,1)              as 'Ordem',
     case when max(b.nm_fantasia_produto) like 'BI%' then 2 -- O BI6.0 por exemplo fica abaixo
                                                            -- de Anéis, portanto a 6a. posição está reservada    
     else 1 end		     	    as 'Arq',
     a.cd_produto                   as 'CodProduto',
     max(b.nm_fantasia_produto)     as 'Produto',
     cast(null as int)              as 'CodProdutoEspacador',
     sum(a.qt_sub_serie)            as 'Qtde',
     max(b.cd_categoria_produto)    as 'Categoria',
     max(b.vl_produto)              as 'Venda',
     GetDate()                      as 'DataPreco',
     max(po.vl_custo_produto_orcam) as 'Custo',
     max(po.dt_produto_orcamento)   as 'DataCusto',
     case when max(b.nm_fantasia_produto) like 'BI%' then 6 -- O BI6.0 por exemplo fica abaixo
                                                            -- de Anéis, portanto a 6a. posição está reservada    
     else min(cd_ordem_sub_serie_prod) end as 'OrdemProduto'  

  into #Sub_Serie_Produto

  from
    Sub_Serie_Produto a

  inner Join Produto b on 
  a.cd_produto = b.cd_produto

  Left Outer Join Produto_Orcamento po on
  b.cd_produto = po.cd_produto

  where a.cd_serie_produto         = @cd_serie_produto and
        a.cd_sub_serie             = @cd_sub_serie and 
        a.cd_tipo_serie_produto    = @cd_tipo_serie_produto and
        a.ic_montagem_g_sub_serie  = @ic_montagem_g_sub_serie and
        substring(b.nm_fantasia_produto,1,3) <> (case when @ic_montagem_g_sub_serie='S' then 'CF0' else '' end) and
        substring(b.nm_fantasia_produto,1,2) <> (case when @ic_montagem_g_sub_serie='N' then 'BG' else '' end) and
        a.cd_montagem             <= @cd_montagem and
        a.cd_tipo_montagem        <= @cd_tipo_montagem -- X/Y

  group by a.cd_produto
  order by min(cd_ordem_sub_serie_prod)

if @cd_parametro = 1

   select * 
   from #Sub_Serie_Produto
   order by OrdemProduto

else

if @cd_parametro = 0
begin

   select  
      identity(int,10,1)        as 'Ordem1',
      2                         as 'Arq',
      a.cd_produto              as 'CodProduto',
      b.nm_fantasia_produto     as 'Produto',
      a.cd_produto              as 'CodProdutoEspacador',
      a.qt_item_curso_extracao  as 'Qtde',
      b.cd_categoria_produto    as 'Categoria',
      b.vl_produto              as 'Venda',
      GetDate()                 as 'DataPreco',
      po.vl_custo_produto_orcam as 'Custo',
      po.dt_produto_orcamento   as 'DataCusto',
      a.cd_ordem_curso_extracao as 'OrdemProduto'
   
   into #Curso_Extracao
   
   from Curso_Extracao a
   
   Left Join Produto b on 
   a.cd_produto = b.cd_produto
   
   Left Outer Join Produto_Orcamento po on
   b.cd_produto = po.cd_produto
   
   where a.cd_serie_produto           = @cd_serie_produto and
         a.cd_tipo_serie_produto      = @cd_tipo_serie_produto and
         a.cd_tipo_curso_extracao     = @cd_tipo_curso_extracao and
         a.qt_medida_curso_extracao   > 0 and -- Para não trazer o Espaçador ... (que é placa)
         a.cd_montagem               <= @cd_montagem and
         a.ic_montagem_g_curso_extra <= @ic_montagem_g_sub_serie and
         a.cd_tipo_montagem          <= @cd_tipo_montagem and -- X/Y 
        (isnull(a.cd_produto_equivalente_Y,0) = 0 or @cd_tipo_montagem = 1)
   
   -- Junta as duas tabelas
   
   select * into #TmpFinal
   from #Sub_Serie_Produto 
   
   UNION
   
   select * from #Curso_Extracao   
   
   -- Select Final
   
   select * 
   from #TmpFinal
   order by arq,
            ordemproduto
   
end

