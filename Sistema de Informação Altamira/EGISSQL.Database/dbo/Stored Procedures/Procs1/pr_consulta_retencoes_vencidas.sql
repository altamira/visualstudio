
CREATE PROCEDURE pr_consulta_retencoes_vencidas
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Anderson Cunha
--Banco de Dados	: EgisSQL
--Objetivo		:  Realizar consulta para Retenções vencidas
--Data		        : 01.04.2004
--Atualizacao : 01/11/04 - Paulo
--                         Alterado a clausula WHERE pois não estava filtrando por parametro algum
-----------------------------------------------------------------------------------------------------
@ic_parametro int,
@nm_fornecedor varchar(20),
@nm_produto varchar(20),
@nm_origem varchar(10),
@dt_hj DateTime
as
  
  set @nm_fornecedor = isnull(@nm_fornecedor,'')
  set @nm_produto = isnull(@nm_produto,'')
  set @nm_origem = isnull(@nm_origem,'')

  Select 
    rt.*,
    ogr.nm_origem_retencao,
    f.nm_fantasia_fornecedor ,
    case when ogr.nm_origem_retencao = 'Amostra' then
    ap.nm_amostra_produto else p.nm_fantasia_produto end as 'nm_produto',
    case when ogr.nm_origem_retencao = 'Amostra' then
    cast(ap.ds_amostra_produto as varchar(200)) else p.nm_produto end as 'nm_fantasia_produto',
    pp.cd_processo_padrao,
    pp.nm_processo_padrao
  From 
    Retencao rt 
    left outer join Origem_retencao ogr on (rt.cd_origem_retencao = ogr.cd_origem_retencao) 
    left outer join Produto p on (rt.cd_produto = p.cd_produto) 
    left outer join Amostra a on (rt.cd_amostra = a.cd_amostra) 
    left outer join Amostra_produto ap on (a.cd_amostra = ap.cd_amostra)
    left outer join Fornecedor f on (rt.cd_fornecedor = f.cd_fornecedor)
    left outer join Processo_Producao ppd on rt.cd_processo = ppd.cd_processo
    left outer join Processo_Padrao pp on ppd.cd_processo_padrao = pp.cd_processo_padrao
  where  
    --Pesquisa por Fornecedor
    isnull(f.nm_fantasia_fornecedor,'') like @nm_fornecedor + '%' and
    --Pesquisa por Origem
    isnull(ogr.nm_origem_retencao,'') like @nm_origem + '%' and
    --Pesquisa por Produto
    isnull(p.nm_fantasia_produto,'') like @nm_produto + '%' and   
    --Para ambas os parametros 2 e 3 e 4
    isnull(rt.dt_validade,'') <= case 
                                   when @ic_parametro in(2,3,4)
                                     then @dt_hj 
                                   else isnull(rt.dt_validade,'')
                                 end
------------------------------------------------------------------------------------------------------------------------
--Testando o Procedimento
------------------------------------------------------------------------------------------------------------------------
