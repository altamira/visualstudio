
-------------------------------------------------------------------------------
--pr_migracao_industecnica_item_nota_entrada
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--                   Wilder Mendes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Itens da Nota de Entrada
--Data             : 25.07.2006
--Alteração        : 21/08/2006 - Acertos- Daniel Carrasco
------------------------------------------------------------------------------
create procedure pr_migracao_industecnica_item_nota_entrada
as

--select * from kin.dbo.NotaItem

--delete nota_entrada_item

select 
  NOPER01,
  ( select max(cd_operacao_fiscal) from Operacao_Fiscal where cast(replace(cd_mascara_operacao,'.','') as varchar)=cast(NOPER01 as varchar)) as cd_operacao_fiscal
into
  #AuxOpeFiscal
from
  kin.dbo.icenf
group by
  NOPER01
order by
  NOPER01


select
  f.cd_fornecedor                      as cd_fornecedor,
  i.NOTA                               as cd_nota_entrada,
  isnull(a.cd_operacao_fiscal,0)       as cd_operacao_fiscal,
  3                                    as cd_serie_nota_fiscal,
  i.SEQ                               as cd_item_nota_entrada,
  cf.cd_classificacao_fiscal,
  p.cd_produto,
  p.nm_produto                         as nm_produto_nota_entrada,
  p.cd_unidade_medida                  as cd_unidade_medida,
  i.NROPED                             as cd_pedido_compra,
  i.SEQ                                as cd_item_pedido_compra,
  pf.cd_procedencia_produto,
  pf.cd_tributacao,
  i.QTD                                as qt_item_nota_entrada,
  i.VALOR                              as vl_item_nota_entrada,
  i.DESCONTO                           as pc_desc_nota_entrada,
  p.qt_peso_liquido                    as qt_pesliq_nota_entrada,
  p.qt_peso_bruto                      as qt_pesbru_nota_entrada,
  i.ALIQICMS                           as pc_icms_nota_entrada,
  cast(0 as float )                    as vl_bicms_nota_entrada,
  cast(0 as float )                    as vl_icms_nota_entrada,
  cast(0 as float )                    as vl_icmsisen_nota_entrada,
  cast(0 as float )                    as vl_icmout_nota_entrada,
  cast(0 as float )                    as vl_icmobs_nota_entrada,
  i.IPI                                as pc_ipi_nota_entrada,
  cast(0 as float )                    as vl_bipi_nota_entrada,
  cast(0 as float )                    as vl_ipi_nota_entrada,
  cast(0 as float )                    as vl_ipiisen_nota_entrada,
  cast(0 as float )                    as vl_ipiout_nota_entrada,
  cast(0 as float )                    as vl_ipiobs_nota_entrada,
  cast(0 as float )                    as vl_custo_nota_entrada,
  cast(0 as float )                    as vl_contabil_nota_entrada,
  null                                 as cd_plano_compra,
  null                                 as ic_peps_nota_entrada,
  j.DTENTR                             as dt_item_receb_nota_entrad,
  null                                 as cd_situacao_tributaria,
  'N'                                  as ic_basered_nota_entrada,
  null                                 as cd_dispositivo_legal_ipi,
  null                                 as cd_dispositivo_legal_icm,
  null                                 as cd_contabilizacao,
  99                                   as cd_usuario,
  getdate()                            as dt_usuario,
  'P'                                  aS ic_tipo_nota_entrada_item,
  i.QTD*i.VALOR                        as vl_total_nota_entr_item,
  null                                 as cd_conta,
  'N'                                  as ic_item_inspecao_nota,
  null                                 as cd_servico,
  cast('' as varchar)                  as ds_servico,
  cast(0 as float )                    as vl_irrf_servico,
  cast(0 as float )                    as pc_irrf_servico,
  cast(0 as float )                    as vl_iss_servico,
  cast(0 as float )                    as pc_iss_servico,
  null                                 as cd_item_requisicao_compra,
  null                                 as cd_requisicao_compra,
  cf.cd_mascara_classificacao,
  cast(0 as float )                    as pc_icms_red_nota_entrada,
  'N'                                  as ic_estocado_nota_entrada,
  'N'                                  as ic_consig_nota_entrada,
  null                                 as cd_lote_produto,
  null                                 as cd_lote_item_nota_entrada,
  null                                 as cd_num_serie_item_nota_ent,
  null                                 as qt_destino_movimento,
  null                                 as qt_fator_produto_unidade,
  null                                 as cd_unidade_destino,
  cast(0 as float )                    as vl_custo_conversao,
  cast(0 as float )                    as vl_custo_net_nota_entrada,
  cast(0 as float )                    as vl_confis_item_nota,
  cast(0 as float )                    as vl_pis_item_nota,
  cast(0 as float )                    as pc_confis_item_nota,
  cast(0 as float )                    as pc_pis_item_nota,
  cast(null as datetime)               as dt_item_inspecao_nota,
  null                                 as cd_usuario_inspecao,
  'N'                                  as ic_inventario,
  null                                 as cd_bem,
  cast(0 as float )                    as vl_icms_ciap_nota_entrada,
  cast(0 as float )                    as vl_ipi_apura_nota_entrada,
  null                                 as qt_mes_apura_nota_entrada,
  cast(0 as float )                    as vl_cofins_item_nota,
  cast(0 as float )                    as pc_cofins_item_nota,
  null                                 as cd_veiculo,
  null                                 as cd_nota_saida,
  null                                 as cd_item_nota_saida,
  cast(0 as float )                    as vl_custo_produto,
  null                                 as cd_rnc,
  null                                 as cd_centro_custo,
  null                                 as qt_area_produto

into
  #notaentradaitem
from
  kin.dbo.NotaItem i
  inner join kin.dbo.icenf j              on j.NOTA                      = i.NOTA    and
                                             j.EMPRESA                   = i.EMPRESA
  left outer join Fornecedor f            on f.nm_fantasia_fornecedor    = i.EMPRESA
  left outer join #AuxOpeFiscal a         on a.NOPER01                   = j.NOPER01
  left outer join Operacao_Fiscal opf     on opf.cd_operacao_fiscal      = a.cd_operacao_fiscal
  left outer join Estado e                on e.cd_estado                 = f.cd_estado
  left outer join Produto p               on p.nm_fantasia_antigo        = i.MATERIA
  left outer join Produto_Fiscal pf       on pf.cd_produto               = p.cd_produto
  left outer join Classificacao_Fiscal cf on cf.cd_classificacao_fiscal  = pf.cd_classificacao_fiscal


Declare @cd_fornecedor as int
Declare @cd_nota_entrada as int
Declare @cd_serie_nota_fiscal as int
Declare @cd_operação_fiscal as int
Declare @cd_item_nota_entrada as int

Select * from #notaentradaitem

while exists (Select * from  #notaentradaitem)
begin
		Select top 1 
				@cd_fornecedor = isnull(cd_fornecedor, 0), 
				@cd_nota_entrada = isnull(cd_nota_entrada, 0), 
				@cd_operação_fiscal = isnull(cd_operação_fiscal, 0),
				@cd_item_nota_entrada = isnull(cd_item_nota_entrada, 0)  
      from #notaentradaitem
		
		insert into 
  			nota_entrada_item
		select
  			top 1 * 
		from
  			#notaentradaitem
		where 
				@cd_fornecedor = isnull(cd_fornecedor, 0) and 
				@cd_nota_entrada = isnull(cd_nota_entrada, 0) and  
				@cd_operação_fiscal = isnull(cd_operação_fiscal, 0) and 
				@cd_item_nota_entrada = isnull(cd_item_nota_entrada, 0)  

	   delete from #notaentradaitem 
		where
 				@cd_fornecedor = isnull(cd_fornecedor, 0) and 
				@cd_nota_entrada = isnull(cd_nota_entrada, 0) and  
				@cd_operação_fiscal = isnull(cd_operação_fiscal, 0) and 
				@cd_item_nota_entrada = isnull(cd_item_nota_entrada, 0) 
end

drop table #notaentradaitem

--select * from nota_entrada_item





