
---------------------------------------------------------------------------------------
--fn_componente_processo
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Autor
--Banco de Dados	: EGISSQL
--Objetivo		: 
--
--Data			: 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------


CREATE FUNCTION fn_componente_processo
  (@cd_processo int)
RETURNS @Composicao_Produto TABLE 
  (cd_produto_pai int, 
   cd_produto int,
   qt_produto_composicao float,
   cd_fase_produto int,
   nm_fantasia_produto varchar(30),
   qt_produto_pai float)
AS
BEGIN

  insert into
    @Composicao_Produto    
  select
     pp.cd_produto as cd_produto_pai,
     ppc.cd_produto,
     ppc.qt_comp_processo as qt_produto_composicao,
     ppc.cd_fase_produto,
     p.nm_fantasia_produto,
     pp.qt_planejada_processo as qt_produto_pai
  from
    Processo_Producao 			pp  left outer join
    Processo_Producao_Componente 	ppc on pp.cd_processo = ppc.cd_processo left outer join
    Produto				p   on ppc.cd_produto = p.cd_produto
  where
    ( pp.cd_processo = @cd_processo )

  RETURN

END

