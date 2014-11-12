
CREATE PROCEDURE pr_composicao_mensal_estoque
------------------------------------------------------------------
--pr_composicao_mensal_estoque
------------------------------------------------------------------
--GBS - Global Business Solution	       2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Mapa Anual de Composição de Estoque
--Data          : 01/11/2004
-- 15.03.2005 - Inclusão da Fase - Clelson Camargo
-------------------------------------------------------------------

@ic_parametro        int, -- 0 para Qtd, 1 para Valor.
@ano_base            int

AS

--select * from nota_entrada_item
--select cd_materia_prima, * from pedido_compra_item

  declare @vl_total decimal(25,2)

  -----------------------------------------------------------------------------
  -- RECEBIDOS
  -----------------------------------------------------------------------------

    select 
       IsNull(ge.nm_grupo_estoque, gemp.nm_grupo_estoque)  as 'GrupoEstoque',
       mp.nm_mat_prima                                     as 'MatPrima',
       fp.nm_fase_produto                                  as 'Fase',
       case when month(nei.dt_item_receb_nota_entrad) = 1 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) 
              end))
       end 
        as 'Janeiro',

       case when month(nei.dt_item_receb_nota_entrad) = 2 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Fevereiro',

       case when month(nei.dt_item_receb_nota_entrad) = 3 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Marco',

       case when month(nei.dt_item_receb_nota_entrad) = 4 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Abril',

       case when month(nei.dt_item_receb_nota_entrad) = 5 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Maio',

       case when month(nei.dt_item_receb_nota_entrad) = 6 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Junho',

       case when month(nei.dt_item_receb_nota_entrad) = 7 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Julho',

       case when month(nei.dt_item_receb_nota_entrad) = 8 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Agosto',

       case when month(nei.dt_item_receb_nota_entrad) = 9 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Setembro',

       case when month(nei.dt_item_receb_nota_entrad) = 10 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Outubro',

       case when month(nei.dt_item_receb_nota_entrad) = 11 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Novembro',

       case when month(nei.dt_item_receb_nota_entrad) = 12 then
         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
       end 
        as 'Dezembro',

         sum((case when @ic_parametro = 0 then
                nei.qt_pesbru_nota_entrada
              else  
                 isnull(nei.vl_total_nota_entr_item,0)+ isnull(nei.vl_ipi_nota_entrada,0) end)) 
      as 'Total_Grupo'

    into 
      #MapaAnualRecebido
    from 
      Nota_Entrada_Item nei left outer join
      Pedido_Compra_Item pci on pci.cd_pedido_compra = nei.cd_pedido_compra and
                                pci.cd_item_pedido_compra = nei.cd_item_pedido_compra left outer join
      Produto p on p.cd_produto = nei.cd_produto left outer join
      Produto_Custo pc ON p.cd_produto = pc.cd_produto left outer join
      Materia_Prima mp ON IsNull(pc.cd_mat_prima,pci.cd_materia_prima) = mp.cd_mat_prima left outer join
      Grupo_Produto_Custo gp ON p.cd_grupo_produto = gp.cd_grupo_produto left outer join
      Grupo_Estoque ge ON IsNull(pc.cd_grupo_estoque,gp.cd_grupo_estoque) = ge.cd_grupo_estoque left outer join
      Grupo_Estoque gemp on gemp.cd_grupo_estoque = mp.cd_grupo_estoque left outer join
      produto_fechamento pf on pf.cd_produto = p.cd_produto left outer join
      Fase_Produto fp       on fp.cd_fase_produto = pf.cd_fase_produto  

    where 
      year(nei.dt_item_receb_nota_entrad) = @ano_base and
      isnull(pci.cd_materia_prima,0) > 0 
    group by 
       fp.nm_fase_produto,
       ge.nm_grupo_estoque,
       gemp.nm_grupo_estoque,
       mp.nm_mat_prima,
       nei.dt_item_receb_nota_entrad
    order by
      mp.nm_mat_prima, ge.nm_grupo_estoque, gemp.nm_grupo_estoque

  select 
    @vl_total = sum(Total_Grupo)
  from
    #MapaAnualRecebido

  select 
    GrupoEstoque,
    MatPrima,
    Fase,
    sum(Janeiro) as Janeiro,
    sum(Fevereiro) as Fevereiro,
    sum(Marco) as Marco,
    sum(Abril) as Abril,
    sum(Maio) as Maio,
    sum(Junho) as Junho,
    sum(Julho) as Julho,
    sum(Agosto) as Agosto,
    sum(Setembro) as Setembro,
    sum(Outubro) as Outubro,
    sum(Novembro) as Novembro,
    sum(Dezembro) as Dezembro,
    sum(Total_Grupo) as Total_Grupo,
    cast((isnull(sum(Total_Grupo), 1) / @vl_total ) * 100 as numeric(25,2)) as Porcent
  from
    #MapaAnualRecebido
  group by
    GrupoEstoque,
    MatPrima,
    Fase
  order by
    MatPrima, GrupoEstoque, Fase

