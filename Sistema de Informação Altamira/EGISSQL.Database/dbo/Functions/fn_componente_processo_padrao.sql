
---------------------------------------------------------------------------------------
--fn_componente_processo_padrao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2007
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Montagem da Composição do Processo Padrão
--
--Data			: 01.06.2007
--Atualização           : 
---------------------------------------------------------------------------------------


CREATE FUNCTION fn_componente_processo_padrao
  (@cd_processo int)
RETURNS @Composicao_Produto TABLE 
  (
   cd_produto            int,
   qt_produto_composicao float,
   cd_fase_produto       int,
   nm_fantasia_produto   varchar(30),
   cd_processo_padrao    int
  )
AS
BEGIN

  --select * from processo_padrao_produto

  insert into
    @Composicao_Produto    
  select
     ppc.cd_produto,
     ppc.qt_produto_processo     as qt_produto_composicao,
     ppc.cd_fase_produto,
     p.nm_fantasia_produto,
     ppp.cd_processo_padrao   
  from
    Processo_Padrao                          pp  with (nolock) 
    left outer join  Processo_Padrao_Produto ppc with (nolock) on pp.cd_processo_padrao = ppc.cd_processo_padrao 
    left outer join  Produto                 p   with (nolock) on ppc.cd_produto = p.cd_produto
    left outer join  Produto_Producao        ppp with (nolock) on ppp.cd_produto = ppc.cd_produto
  where
    ( pp.cd_processo_padrao = @cd_processo )

  RETURN

END

