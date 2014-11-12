
CREATE PROCEDURE pr_retencoes
-----------------------------------------------------------------------
--pr_retencoes
-----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                              2004
-----------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Anderson Cunha
--Banco de Dados	: EgisSQL
--Objetivo		: Realizar consulta para Retenções
--Data		        : 09.03.2004
--Atualização           : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 21.05.2006
---------------------------------------------------------------------------
@ic_parametro int,
@cd_amostra   int         = 0,
@cd_lote      varchar(30) = '',
@nm_produto   varchar(30) = '',
@cd_op        int         = 0

as

  Set @cd_amostra = isnull(@cd_amostra,0)
  Set @nm_produto = isnull(@nm_produto,'')
  Set @cd_op      = isnull(@cd_op,0)

  Select 
    rt.*,
    ogr.nm_origem_retencao,
    p.nm_produto,
    p.nm_fantasia_produto,
    f.nm_fantasia_fornecedor,
    pp.cd_processo_padrao, 
    pp.nm_processo_padrao
  From 
    Retencao rt 
      left outer join
    Origem_retencao ogr 
      on(rt.cd_origem_retencao = ogr.cd_origem_retencao) 
      left outer join
    Produto p 
      on (rt.cd_produto = p.cd_produto) 
      left outer join
    Amostra a 
      on (rt.cd_amostra = a.cd_amostra) 
      left outer join
    Fornecedor f 
      on (rt.cd_fornecedor = f.cd_fornecedor)
      left outer join
    (select ppd.cd_processo, pp.cd_processo_padrao, pp.nm_processo_padrao
     from processo_producao ppd left outer join processo_padrao pp
          on ppd.cd_processo_padrao = pp.cd_processo_padrao) pp
      on rt.cd_processo = pp.cd_processo 
  where    
    --Pesquisa por Amostra
    isnull(rt.cd_amostra,0) = 
      case when @ic_parametro = 1 then @cd_amostra else isnull(rt.cd_amostra,0) end and
    --Pesquisa por LOTE
    isnull(rt.cd_lote,'') like 
      case when @ic_parametro = 2 then @cd_lote + '%' else isnull(rt.cd_lote,'') end and
    --Pesquisa por Produto
    isnull(p.nm_fantasia_produto,'') like 
      case when @ic_parametro = 3 then @nm_produto + '%' else isnull(p.nm_fantasia_produto,'') end and
    --Pesquisa por OP
    isnull(rt.cd_processo,0) = 
      case when @ic_parametro = 4 then @cd_op else isnull(rt.cd_processo,0) end and
    --Parametros 5 e 6
    1 = case @ic_parametro 
          --Pesquisa Geral
          when 5 then 1
          --Não traz nada
          when 6 then 2
          else 1 
        end
-------------------------------------------------------------------------------------------
--Testando Procedimento
-------------------------------------------------------------------------------------------
