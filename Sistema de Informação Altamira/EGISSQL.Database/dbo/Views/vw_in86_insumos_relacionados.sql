
-- vw_in86_insumos_relacionados
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Alexandre Del Soldato
-- Banco de Dados: EgisSql
-- Objetivo: Lista Regitro de Insumos de Produto utilizado nos Arquivos Magnéticos
-- Data: 02/04/2004
-- Atualizado: 
-- ---------------------------------------------------------------------------------------
-- 
create view vw_in86_insumos_relacionados
as

	Select 
	  pc.cd_produto_pai          as CODIGO,
          ump.sg_unidade_medida      as UNIDADE,
	  pc.cd_produto              as INSUMO,
	  pc.qt_produto_composicao   as QUANTIDADE,
          pc.pc_composicao_produto   as PERCENTUAL,
          um.sg_unidade_medida       as UN_INSUMO,
          NULL                       as DATAINI,
          NULL                       as DATAFIM,
	  pc.nm_produto_comp,
	  c.nm_produto,
	  p.nm_fantasia_produto as 'nm_produto_pai'
	from
	  Produto_Composicao pc
	  left outer join Produto p
	                 on p.cd_produto = pc.cd_produto_pai
	  left outer join Unidade_medida ump
	                 on ump.cd_unidade_medida = p.cd_unidade_medida
	  left outer join Produto c
	                 on c.cd_produto = pc.cd_produto
	  left outer join Unidade_medida um
	                 on um.cd_unidade_medida = c.cd_unidade_medida

