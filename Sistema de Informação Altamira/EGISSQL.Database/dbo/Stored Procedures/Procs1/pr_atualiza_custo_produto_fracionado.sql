
CREATE PROCEDURE pr_atualiza_custo_produto_fracionado
AS

declare @pc_pis    decimal(25,4)
declare @pc_cofins decimal(25,4)

set @pc_pis    = (1.65/100)
set @pc_cofins = (7.6/100)

--Todos os Produtos

select
  p.cd_produto            as Codigo,
  p.nm_fantasia_produto   as Fantasia,
  0                       as cd_produto_fracionado,
  cast('' as varchar(25)) as fantasiafracionado,
  0                       as cd_produto_embalagem,
  cast(0.00 as float )    as qt_produto_embalagem
into #AuxProduto
from 
  Produto p with (nolock)


--Produtos Fracionados

select
  p.cd_produto          as Codigo,
  p.nm_fantasia_produto as Fantasia,
  pf.cd_produto_fracionado,
  case when px.nm_fantasia_produto is null then p.nm_fantasia_produto else px.nm_fantasia_produto end as fantasiafracionado,
  isnull(te.cd_produto,0)            as cd_produto_embalagem,
  isnull(pf.qt_produto_fracionado,0) as qt_produto_embalagem
into #ProdutoFracionado
from 
  Produto p                            with (nolock) 
  inner join Produto_Fracionamento pf  with (nolock) on pf.cd_produto           = p.cd_produto
  left outer join Produto px           with (nolock) on px.cd_produto           = pf.cd_produto_fracionado
  left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = p.cd_categoria_produto
  left outer join Tipo_Embalagem    te with (nolock) on te.cd_tipo_embalagem    = pf.cd_tipo_embalagem
where
  isnull(cp.ic_cpv_categoria,'N')='S'
order by
  p.cd_produto 


--select * from #ProdutoFracionado

--Junção das Tabelas Produto

insert into #AuxProduto 
 select * from #Produtofracionado

select 
  *,
  cd_produto = case when isnull(cd_produto_fracionado,0) = 0 then Codigo else cd_produto_fracionado end
into #Produto  
from 
  #AuxProduto 
order by Codigo


select 
 p.*,
 --Último Custo da Entrada do Produto na Nota Fiscal
 p.qt_produto_embalagem * isnull(

          (select top 1 
             --IsNull(nei.vl_item_nota_entrada,0) --> 30.06.2010
               round((nei.vl_item_nota_entrada
               -

               case when isnull(ic_ipi_base_icm_dest_prod,'N')='S' then
               (nei.vl_ipi_nota_entrada/nei.qt_item_nota_entrada)
               else 
                0.00
               end

               -

               (nei.vl_icms_nota_entrada/nei.qt_item_nota_entrada)

               -

               --Cofins
               case when isnull(opf.ic_cofins_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_cofins_item_nota,0)>0
                 then
                    nei.vl_cofins_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada*@pc_cofins
                 end
               else
                 0.00
               end                                      

               -

               --PIS
               case when isnull(opf.ic_pis_operacao_fiscal,'N')='S' 
               then
                 case when isnull(nei.vl_pis_item_nota,0)>0 
                 then
                    nei.vl_pis_item_nota/nei.qt_item_nota_entrada  
                 else
                    nei.vl_item_nota_entrada*@pc_pis
                 end
               else
                 0.00
               end),2)


          from nota_entrada_item nei    
          inner join nota_entrada ne     with (nolock) on ne.cd_nota_entrada        = nei.cd_nota_entrada    and
                                                          ne.cd_fornecedor          = nei.cd_fornecedor      and
                                                          ne.cd_serie_nota_fiscal   = nei.cd_serie_nota_fiscal and
                                                          ne.cd_operacao_fiscal     = nei.cd_operacao_fiscal 
          inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal =  ne.cd_operacao_fiscal 
          left outer join Destinacao_Produto dp with (nolock) on dp.cd_destinacao_produto = ne.cd_destinacao_produto

          where nei.cd_produto = p.codigo
                and isnull(opf.ic_comercial_operacao,'N')='S'
          order by nei.dt_item_receb_nota_entrad desc ),0) as vl_custo_produto
 
 --isnull(pc.vl_custo_produto,0)*p.qt_produto_embalagem  as vl_custo_produto 
into
  #AuxCusto

from 
  #Produto p
  left outer join Produto_Custo pc on pc.cd_produto = p.codigo
order by 
  p.Codigo


--select * from #AuxCusto order by Fantasia

-----------------------------------------------------------------------------------------------------------------
--Atualização do Preço de Custo do Produto
-----------------------------------------------------------------------------------------------------------------
update
  produto_custo
set
  vl_custo_produto = isnull(p.vl_custo_produto,0)
from
  produto_custo pc, #AuxCusto p
where
  pc.cd_produto = p.cd_produto_fracionado

--select * from #AuxCusto order by fantasia


