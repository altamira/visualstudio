
CREATE VIEW vw_explosao_processo_padrao_composicao
------------------------------------------------------------------------------------
--sp_helptext vw_explosao_processo_padrao_composicao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Mostra a Composição Geral de Todos os Processos Padrão
--
--Data                  : 01.01.2009
--Atualização           : 
--
------------------------------------------------------------------------------------
as
 
--select * from processo_padrao

  select
     pp.cd_processo_padrao,
     pp.nm_identificacao_processo,
     ppc.cd_produto,
     p.nm_fantasia_produto,
     p.cd_mascara_produto,
     p.nm_produto,
     um.sg_unidade_medida,
     ppc.qt_produto_processo                     as qt_produto_composicao,
     ppc.cd_fase_produto,
     fp.nm_fase_produto

--     ppp.cd_processo_padrao   
  from
    Processo_Padrao                          pp  with (nolock) 
    left outer join  Processo_Padrao_Produto ppc with (nolock) on pp.cd_processo_padrao = ppc.cd_processo_padrao 
    left outer join  Produto                 p   with (nolock) on ppc.cd_produto        = p.cd_produto
    left outer join  Produto_Producao        ppp with (nolock) on ppp.cd_produto        = ppc.cd_produto
    left outer join  Fase_Produto            fp  with (nolock) on fp.cd_fase_produto    = ppc.cd_fase_produto
    left outer join  Unidade_Medida          um  with (nolock) on um.cd_unidade_medida  = p.cd_unidade_medida
--order by
--  pp_nm_identifiacao_processo  

