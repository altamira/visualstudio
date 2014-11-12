
CREATE PROCEDURE pr_ordem_producao
-----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
-----------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Anderson Cunha
--Banco de Dados	: EgisSQL
--Objetivo		:  Realizar consulta para controle de ordem de produção
--Data		        : 07.04.2004
--            22.06.2004 - Reestruturação da Procedure, pois existiam vários scripts
--                       - com os campos de select e From igual, apenas mudando os filtros da consulta.
--                       - Unifiquei todos para uma possível alteração na sp não ocorrer de esquecer de alterar
--                       - as demais query. Igor Gama.
--            05.08.2004 - Inclusão do descritivo da alteração do dia 22.06, mais inclusão das funcionalidades
--                       - dos parâmentros. Igor Gama.
-- 25.10.2008 - Ajuste dos Campos das Tabelas - Carlos Fernandes
-- 31.07.2010 - Unidade do Processo Padrão - Carlos Fernandes / Márcio Martins
-- 14.08.2010 - Lote - Carlos Fernandes/Márcio M.
-----------------------------------------------------------------------------------------------------
@ic_parametro as int,
@dt_inicial   as DateTime,
@dt_final     as DateTime,
@nm_formula   as varchar(50),
@cd_op        as int,
@sg_status    as varchar (15)
as

  set @dt_inicial  = isnull(@dt_inicial,'')
  set @dt_final    = isnull(@dt_final,'')
  set @nm_formula  = isnull(@nm_formula,'')
  set @cd_op       = isnull(@cd_op,'')
  set @sg_status   = isnull(@sg_status,'')    

  select
    pp.cd_processo,
    pp.dt_processo,
    pp.cd_identifica_processo,
    pp.cd_usuario,
    pp.dt_usuario,
    pp.cd_fase_produto,
    pp.cd_status_processo,
    pp.qt_planejada_processo,
    pp.dt_entrega_processo,
    pp.cd_produto,
    pp.cd_pedido_venda,
    pp.cd_item_pedido_venda,
    cast(pp.ds_processo as varchar(2000))as 'ds_processo',
    pp.dt_liberacao_processo,
    pp.cd_processo_padrao,
    pp2.nm_identificacao_processo,
    pp2.nm_processo_padrao,
    pp2.qt_densidade_processo,
    sp.sg_status_processo,
    sp.nm_status_processo,
    fp.sg_fase_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    pc.cd_localizacao_padrao,
    um.sg_unidade_medida,
    pp.cd_lote_produto_processo

  --select * from processo_padrao 
  --select * from processo_producao

  from
    Processo_Producao pp with (nolock)  
      left outer join
    Processo_Padrao pp2  with (nolock)  
      on (pp.cd_processo_padrao = pp2.cd_processo_padrao) 
      left outer join
    Status_Processo sp   with (nolock)  
      on (pp.cd_status_processo = sp.cd_status_processo)
      left outer join
    Fase_produto fp      with (nolock)  
      on (pp.cd_fase_produto = fp.cd_fase_produto)
      left outer join
    Produto p            with (nolock)  
      on (pp.cd_produto = p.cd_produto)
      left outer join
    Padrao_cor pc        with (nolock)  
      on (pp2.cd_padrao_cor = pc.cd_padrao_cor)

    left outer join unidade_medida um on um.cd_unidade_medida = pp2.cd_unidade_producao
  where 
    pp2.nm_identificacao_processo like 
      --Parametro 1 - Pesquisa por Fórmula
      case when @ic_parametro = 1 then  @nm_formula + '%' 
           else '%' end and
    isnull(pp.cd_processo,0) = 
      --Parametro 2 - Pesquisa por Ordem Produção
      case when @ic_parametro = 2 then @cd_op 
           else isnull(pp.cd_processo,0) end and    
    isnull(sp.sg_status_processo,'') like 
      --Paramentro 3 - Pesquisa por Status
      case when @ic_parametro = 3 then @sg_status + '%'
           else  '%' end and
      --Parametro 4 - Pesquisa pelo período selecionado
    dt_processo between case when @ic_parametro = 4 then @dt_inicial else dt_processo end and
                        case when @ic_parametro = 4 then @dt_final   else dt_processo end and
    --Esta verificação é para retornar somente a estrutura da procedure para habilitar 
    --o botão de incluir novo registro, ou para zerar a stored procedure
    1 = case when @ic_parametro = 5 then 2 else 1 end


