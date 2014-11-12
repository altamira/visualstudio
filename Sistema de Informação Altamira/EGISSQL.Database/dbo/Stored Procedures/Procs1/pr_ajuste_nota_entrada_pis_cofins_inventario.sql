
CREATE PROCEDURE pr_ajuste_nota_entrada_pis_cofins_inventario

------------------------------------------------------------------------------------
--pr_ajuste_nota_entrada_pis_cofins_inventario
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo	        : Ajuste do Pis / Cofins dos Itens das Notas Fiscais de Entrada
--Data                  : 18.08.2005  
--Atualização           : 06.03.2006
--                      : 22.03.2007 - Ajustes Diversos - Carlos Fernandes
--                      : 24.03.2007 - Verificação - Carlos Fernandes
--                      : 26.03.2007 - Dedução do IPI - Carlos Fernandes
--                      : 27.03.2007 - Cálculo do PIS/COFINS - Carlos Fernandes
------------------------------------------------------------------------------------
@ic_parametro int = 0,
@dt_inicial   datetime,
@dt_final     datetime,
@ic_icms      char(1) = 'N'
as

if @ic_parametro=0
begin
select 
  ne.cd_fornecedor,
  ne.cd_nota_entrada,
  ne.cd_operacao_fiscal,
  ne.cd_serie_nota_fiscal,
  ine.cd_item_nota_entrada,
  ine.cd_unidade_medida,
  ine.qt_item_nota_entrada,
  ine.vl_item_nota_entrada,
  ine.qt_pesbru_nota_entrada,
  f.nm_fantasia_fornecedor,
  um.cd_unidade_medida,
  um.ic_fator_conversao,
  ine.pc_icms_nota_entrada,
  ine.vl_icms_nota_entrada,
  ine.pc_ipi_nota_entrada,
  ine.vl_cofins_item_nota,
  ine.vl_pis_item_nota,
  ine.pc_cofins_item_nota,
  ine.pc_pis_item_nota,
  pte.pc_reducao_bc_ipi,
  cf.pc_ipi_classificacao
from 
  nota_entrada ne

  left outer join Nota_entrada_item ine            on ine.cd_fornecedor        = ne.cd_fornecedor      and
                                                      ine.cd_nota_entrada      = ne.cd_nota_entrada    and
                                                      ine.cd_operacao_fiscal   = ne.cd_operacao_fiscal and    
                                                      ine.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal 
  left outer join Operacao_Fiscal   opf            on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal  
  left outer join Fornecedor          f            on f.cd_fornecedor          = ne.cd_fornecedor
  left outer join Unidade_Medida    um             on um.cd_unidade_medida     = ine.cd_unidade_medida
  left outer join Parametro_Tributacao_entrada pte on pte.cd_tributacao = ine.cd_tributacao
  left outer join Classificacao_Fiscal cf          on cf.cd_classificacao_fiscal = ine.cd_classificacao_fiscal
where
  ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
  isnull(ic_piscofins_op_fiscal,'N')='S' --Correto 18.08.2005, porém foi criado o campo abaixo com erro
  --isnull(ic_piscofis_op_fiscal,'N')='S'   

end

--update na Tabela Nota_Entrada_Item

--select * from nota_entrada_item

if @ic_parametro=1
begin

update
  Nota_Entrada_Item 
set
  --Cofins                                            --Desconto
  vl_cofins_item_nota = (( (ine.vl_item_nota_entrada - (ine.vl_item_nota_entrada * (ine.pc_desc_nota_entrada/100))) *
      case when isnull(um.ic_fator_conversao,'P') = 'P' then isnull(qt_item_nota_entrada,0) else isnull(qt_pesbru_nota_entrada,0) end )
      --- isnull(ine.vl_ipi_nota_entrada,0) )
      * (7.6/100)
      --Verifica se Deduz o ICMS
      - case when @ic_icms = 'S' then ine.vl_icms_nota_entrada else 0.00 end ),

--      - case when isnull(pte.pc_reducao_bc_ipi,0)>0 and isnull(ine.vl_ipi_nota_entrada,0)>0  then ine.vl_ipi_nota_entrada*(pte.pc_reducao_bc_ipi/100) else 0 end
--      - case when isnull(pte.pc_reducao_bc_ipi,0)>0 and isnull(ine.vl_ipi_nota_entrada,0)=0  then (cf.pc_ipi_classificacao/100) * ine.vl_bicms_nota_entrada else 0 end,

  --Pis

  vl_pis_item_nota    = (( (ine.vl_item_nota_entrada - (ine.vl_item_nota_entrada * (ine.pc_desc_nota_entrada/100))) *
      case when isnull(um.ic_fator_conversao,'P') = 'P' then qt_item_nota_entrada else qt_pesbru_nota_entrada end ) )
      --- isnull(ine.vl_ipi_nota_entrada,0) ) 
      * (1.65/100) 
      --Verifica se Deduz o ICMS
      - case when @ic_icms = 'S' then ine.vl_icms_nota_entrada else 0.00 end,
--    - case when isnull(pte.pc_reducao_bc_ipi,0)>0 and isnull(ine.vl_ipi_nota_entrada,0)>0  then ine.vl_ipi_nota_entrada*(pte.pc_reducao_bc_ipi/100) else 0 end
--    - case when isnull(pte.pc_reducao_bc_ipi,0)>0 and isnull(ine.vl_ipi_nota_entrada,0)=0  then
--           (cf.pc_ipi_classificacao/100) * ine.vl_bicms_nota_entrada else 0 end,

  pc_cofins_item_nota = 7.6,
  pc_pis_item_nota    = 1.65

from 
  nota_entrada_item ine

  inner join nota_entrada ne                       on ne.cd_fornecedor           = ine.cd_fornecedor      and
                                                      ne.cd_nota_entrada         = ine.cd_nota_entrada    and
                                                      ne.cd_operacao_fiscal      = ine.cd_operacao_fiscal and    
                                                      ne.cd_serie_nota_fiscal    = ine.cd_serie_nota_fiscal 

  left outer join Operacao_Fiscal   opf            on opf.cd_operacao_fiscal     = ne.cd_operacao_fiscal  
  left outer join Fornecedor          f            on f.cd_fornecedor            = ne.cd_fornecedor
  left outer join Unidade_Medida    um             on um.cd_unidade_medida       = ine.cd_unidade_medida
  left outer join Parametro_Tributacao_entrada pte on pte.cd_tributacao          = ine.cd_tributacao
  left outer join Classificacao_Fiscal cf          on cf.cd_classificacao_fiscal = ine.cd_classificacao_fiscal

where
  ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
  isnull(opf.ic_piscofins_op_fiscal,'N')='S' --Correto 18.08.2005, porém foi criado o campo abaixo com erro
  --isnull(ic_pisconfis_op_fiscal,'N')='S'   

--Atualiza o Pis Cofins na Nota de Entrada

--select * from nota_entrada

--Agrupa em uma tabela temporaria


select
  ne.cd_fornecedor,           
  ne.cd_nota_entrada, 
  ne.cd_operacao_fiscal,
  ne.cd_serie_nota_fiscal,
  vl_pis_nota_entrada    =  sum(isnull(ine.vl_pis_item_nota,0)),
  vl_cofins_nota_entrada =  sum(isnull(ine.vl_cofins_item_nota,0))
into
  #NotaEntradaTotal
from
  nota_entrada ne

  inner join nota_entrada_item ine                 on ne.cd_fornecedor           = ine.cd_fornecedor      and
                                                      ne.cd_nota_entrada         = ine.cd_nota_entrada    and
                                                      ne.cd_operacao_fiscal      = ine.cd_operacao_fiscal and    
                                                      ne.cd_serie_nota_fiscal    = ine.cd_serie_nota_fiscal 
  left outer join Operacao_Fiscal   opf            on opf.cd_operacao_fiscal     = ne.cd_operacao_fiscal  

where
  ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
  isnull(opf.ic_piscofins_op_fiscal,'N')='S' 
group by
   ne.cd_fornecedor,           
   ne.cd_nota_entrada, 
   ne.cd_operacao_fiscal,
   ne.cd_serie_nota_fiscal


update
  nota_entrada
set
  vl_pis_nota_entrada    =  net.vl_pis_nota_entrada,
  vl_cofins_nota_entrada =  net.vl_cofins_nota_entrada
from
  nota_entrada ne

  inner join #NotaEntradaTotal net                 on ne.cd_fornecedor           = net.cd_fornecedor      and
                                                   ne.cd_nota_entrada         = net.cd_nota_entrada    and
                                                   ne.cd_operacao_fiscal      = net.cd_operacao_fiscal and    
                                                   ne.cd_serie_nota_fiscal    = net.cd_serie_nota_fiscal 


end

