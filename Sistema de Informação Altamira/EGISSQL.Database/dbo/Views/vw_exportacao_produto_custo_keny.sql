
CREATE VIEW vw_exportacao_produto_custo_keny
--Sp_helptext vw_exportacao_produto_custo_keny
------------------------------------------------------------------------------------
--vw_exportacao_produto_custo_keny
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração de um arquivo texto para exportação do produto
--Data                  : 09.08.2007
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from produto
--select * from produto_custo

select
  p.cd_grupo_produto,
  p.cd_produto,
  cast(p.cd_mascara_produto as char(18))   as CODIGO,
  'M'                                      as TIPO,
  p.nm_fantasia_produto,
  cast(p.nm_produto         as char(50))   as DESCRICAO,
  cast(um.sg_unidade_medida as char(4))    as Unidade,
  '   0'                                   as Moeda,
  pc.vl_custo_produto                      as Custo,          
  pc.dt_custo_produto                      as Alteracao,
  cast(gp.cd_grupo_produto as char(18))    as Grupo,
  gp.nm_grupo_produto                          

from
  Produto p
  left outer join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join Produto_Custo pc on pc.cd_produto       = p.cd_produto
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
 
