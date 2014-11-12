
CREATE PROCEDURE pr_nota_fiscal_devolvida
------------------------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda
------------------------------------------------------------------------------------------------------
-- Stored Procedure : SQL Server
-- Autor(es)        : Fabio
-- Banco de Dados   : EGISSQL
-- Objetivo         : Apresenta informações sobre as devoluções de Notas Fiscais
-- Data             : 03.02.2003
-- Atualização      : 24/03/2003 - Inclusão deste cabeçalho com histórico das modificaçõs - ELIAS
--                    24/03/2003 - Acerto no parâmetro 3 - Campo de Motivo - ELIAS
--                    02/02/2004 - Inclusão de Novos Campos - Fantasia,Descrição - Chico 
-- 22/04/2004 - Modificado toda a estrutura da procedure - Daniel C. Neto.
--            - Colocado parâmetro para trazer mês corrente, mês anterior e agrupar valores. - Daniel C. Neto.
-- 21/05/2004 - Acertado campos da tabela temporária para permitirem nulos (TODOS CAMPOS) - ELIAS
-- 19/08/2004 - Tirado filtro de dt_nota_saida < @dt_inicial e filtrado
-- por data emissao no faturamento de mês anterior.
-- a própria view vai tratar esses casos. - Daniel C. Neto.
--                     08.09.2004 - Faltou a verificação das quantidades devolvidas e foram feitas alterações na View
--                                  de faturamento pelo Daniel. Igor Gama
-- 16/12/2004 - Modificado filtro de data de emissão para data de devolução. - Daniel C. Neto.
-- 12/01/2005 - Acerto - Daniel C. Neto.
-- 19.02.2009 - Estado do Cliente na Consulta - Carlos Fernandes
-- 16.04.2009 - Ajuste do Veículo/Motorista - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@ic_parametro          char(1), 
@dt_inicial            datetime,
@dt_final              datetime,
@ic_mes_corrente       char(1) = 'S',
@ic_mes_anterior       char(1) = 'N',
@ic_agrupa_valores     char(1) = 'N',
@ic_comercial_operacao char(1) = 'N'

AS

  --------------------------------------------------------------
  -- Pegando Notas do Mês Anterior.
  --------------------------------------------------------------

    select
      'N' as ic_mes_corrente,
      vw.cd_status_nota,
    --vw.ic_comercial_operacao,
      case when ic_tipo_nota_saida_item = 'P' then
           vw.nm_fantasia_produto
      else
           se.sg_servico 
      end as 'Fantasia',
         case when ic_tipo_nota_saida_item = 'P' then
             p.nm_produto
         else
             se.nm_servico 
         end as 'Descrição',
        
--      vw.cd_nota_saida,

    case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
            vw.cd_identificacao_nota_saida
          else
            vw.cd_nota_saida                              
    end                   as cd_nota_saida,

      vw.cd_item_nota_saida,
      vw.dt_nota_saida,
	  case
  	    when vw.vl_produto = vw.vl_total then
	      (vw.vl_unitario_item_nota * IsNull(qt_devolucao_item_nota, 0))
	    else
		  vw.vl_ipi + (vw.vl_unitario_item_nota * IsNull(qt_devolucao_item_nota, 0))
	  end as vl_total,
--      ofi.cd_mascara_operacao as 'cd_operacao_fiscal',
      isnull (vw.cd_mascara_operacao,0) as 'cd_operacao_fiscal',
      vw.dt_restricao_item_nota as dt_cancel_item_nota_saida,
      vw.nm_motivo_restricao_item, 
      td.nm_tipo_destinatario,
      vw.nm_fantasia as nm_fantasia_cliente,
      vw.cd_pedido_venda,
      vw.cd_item_pedido_venda,
      v.nm_fantasia_vendedor as 'nm_vendedor',
	  IsNull(vw.qt_devolucao_item_nota,0) as qt_devolucao_item_nota, --Define a quantidade que foi devolvida
	  case vw.ic_dev_nota_saida	  --Define "S" quanto a nota de devolução é da empresa  e "N" quando for de um terceiro
	  when 'S' then
		'Nossa'
      else
        'Terceiro'
	  end as ic_dev_nota_saida,
	  vw.cd_nota_dev_nota_saida, --Código da nota de devolução		
      vw.cd_pais,
      vw.cd_estado,
      e.sg_estado
    into

--select * from vw_faturamento_devolucao_mes_anterior

--drop table
      #FatMesAnterior
    from
      vw_faturamento_devolucao_mes_anterior vw
        left outer join 
      Tipo_Destinatario td
        on IsNull(vw.cd_tipo_destinatario, 7) = td.cd_tipo_destinatario
        left outer join 
      Vendedor v 
        on v.cd_vendedor = vw.cd_vendedor
        left outer join
      Servico se
        on se.cd_servico = vw.cd_servico
        left outer join 
      Produto p
        on p.cd_produto = vw.cd_produto
      left outer join Estado e on e.cd_estado = vw.cd_estado

    where
--      year(vw.dt_nota_saida) = year(@dt_inicial) and
--    	(vw.dt_nota_saida < @dt_inicial) and
    	vw.dt_restricao_item_nota between @dt_inicial and @dt_final and
      @ic_mes_anterior = 'S' and --- Aqui.
      IsNull(vw.ic_comercial_operacao,'N') = @ic_comercial_operacao
    order by
      vw.dt_nota_dev_nota_saida desc, 
      case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
            vw.cd_identificacao_nota_saida
          else
            vw.cd_nota_saida                              
      end,
   
      vw.cd_item_nota_saida

    --------------------------------------------------------------
    -- Pegando Notas do Mês Corrente.
    --------------------------------------------------------------
    select
      'S' as ic_mes_corrente,
      vw.cd_status_nota,
      --vw.ic_comercial_operacao,
      case when ic_tipo_nota_saida_item = 'P' then
           vw.nm_fantasia_produto
      else
           se.sg_servico 
      end as 'Fantasia',
         case when ic_tipo_nota_saida_item = 'P' then
             p.nm_produto
         else
             se.nm_servico 
         end as 'Descrição',
     
--      vw.cd_nota_saida,

    case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
            vw.cd_identificacao_nota_saida
          else
            vw.cd_nota_saida                              
    end                   as cd_nota_saida,


      vw.cd_item_nota_saida,
      vw.dt_nota_saida,
	  case
  	    when vw.vl_produto = vw.vl_total then
	      (vw.vl_unitario_item_nota * IsNull(qt_devolucao_item_nota, 0))
	    else
		  vw.vl_ipi + (vw.vl_unitario_item_nota * IsNull(qt_devolucao_item_nota, 0))
	  end as vl_total,
--      ofi.cd_mascara_operacao as 'cd_operacao_fiscal',
    isnull (vw.cd_mascara_operacao,0) as 'cd_operacao_fiscal',
    vw.dt_restricao_item_nota as dt_cancel_item_nota_saida,
    vw.nm_motivo_restricao_item, 
    td.nm_tipo_destinatario,
    vw.nm_fantasia as nm_fantasia_cliente,
    vw.cd_pedido_venda,
    vw.cd_item_pedido_venda,
    v.nm_fantasia_vendedor as 'nm_vendedor',
	  IsNull(vw.qt_devolucao_item_nota,0) as qt_devolucao_item_nota, --Define a quantidade que foi devolvida
	  case vw.ic_dev_nota_saida	  --Define "S" quanto a nota de devolução é da empresa  e "N" quando for de um terceiro
	  when 'S' then
		'Nossa'
      else
        'Terceiro'
	  end as ic_dev_nota_saida,
	  vw.cd_nota_dev_nota_saida, --Código da nota de devolução		
      vw.cd_pais,
      vw.cd_estado,
      e.sg_estado

    into 

  #FatMesCorrente

    from
      vw_faturamento_devolucao vw
        left outer join 
      Tipo_Destinatario td
        on IsNull(vw.cd_tipo_destinatario, 7) = td.cd_tipo_destinatario
        left outer join 
      Vendedor v 
        on v.cd_vendedor = vw.cd_vendedor
    left outer join 
      Produto p
        on p.cd_produto = vw.cd_produto
        left outer join
      Servico se
        on se.cd_servico = vw.cd_servico
      left outer join Estado e on e.cd_estado = vw.cd_estado

    where
      (vw.dt_nota_saida between @dt_inicial and @dt_final) and
      IsNull(vw.ic_comercial_operacao,'N') = @ic_comercial_operacao
    order by
      vw.dt_cancel_item_nota_saida desc, 
--      vw.cd_nota_saida, 

    case when isnull(vw.cd_identificacao_nota_saida,0)<>0 then
            vw.cd_identificacao_nota_saida
          else
            vw.cd_nota_saida                              
    end,

    vw.cd_item_nota_saida

  create table #TabelaFinal (
     ic_mes_corrente char(1) null,
     cd_status_nota int Null,
     Fantasia varchar(60) Null,
     Descrição varchar(80) Null,
     cd_nota_saida int null,
     cd_item_nota_saida int null,
     dt_nota_saida datetime null,
  	 vl_total float null,
     cd_operacao_fiscal varchar(60) null,
     dt_restricao_item_nota datetime null ,
     nm_motivo_restricao_item varchar(255) null, 
     nm_tipo_destinatario varchar(80) null,
     nm_fantasia_cliente varchar(80) null,
     cd_pedido_venda int null,
     cd_item_pedido_venda int null,
     nm_vendedor varchar(60) null,
	   qt_devolucao_item_nota float null, 
     ic_dev_nota_saida char(10) null,
     cd_nota_dev_nota_saida varchar(40) null,
     cd_pais   int null,
     cd_estado int null,
     sg_estado char(2) null )

  if (@ic_mes_anterior = 'S') or (@ic_agrupa_valores = 'S' )
    insert into #TabelaFinal
      select * from #FatMesAnterior

  if (@ic_mes_corrente = 'S'   )  or
     (@ic_agrupa_valores = 'S' )
  begin
    if @ic_parametro = 1
      insert into #TabelaFinal
        select * from #FatMesCorrente where cd_status_nota = 3
    else if @ic_parametro = 2
      insert into #TabelaFinal
        select * from #FatMesCorrente where cd_status_nota = 4
    else 
      insert into #TabelaFinal
        select * from #FatMesCorrente
  end

  if (@ic_agrupa_valores = 'S' )
  begin

    declare @vl_final float
 
    set @vl_final =
      ( select sum(vl_total) from #TabelaFinal where ic_mes_corrente = 'S' )

    create table #TabelaAgrupada (
       cd_cod_mes int null,
       nm_mes     varchar(60) null,
       vl_final   float null )

    -- Fazendo somatória do Mês Corrente.
    insert into 
      #TabelaAgrupada values
    ( 1, 'Mês Corrente', IsNull(@vl_final,0) )

    -- Fazendo somatória do Mês Anterior.
    set @vl_final =
      ( select sum(vl_total) from #TabelaFinal where ic_mes_corrente = 'N' )

    insert into 
      #TabelaAgrupada values
    ( 2, 'Mês Anterior', IsNull(@vl_final,0))


    --Mostra a Tabela Agrupada

    select 
      t.*,
      v.nm_veiculo,
      m.nm_motorista

    from 
      #TabelaAgrupada t
      left outer join nota_saida ns with (nolock) on ns.cd_nota_saida = t.cd_nota_saida
      left outer join veiculo    v  with (nolock) on v.cd_veiculo     = ns.cd_veiculo
      left outer join motorista  m  with (nolock) on m.cd_motorista   = ns.cd_motorista

  end
  else
    begin

      select
        t.*,
        v.nm_veiculo,
        m.nm_motorista
      from
        #TabelaFinal t
        left outer join nota_saida ns with (nolock) on ns.cd_nota_saida = t.cd_nota_saida
        left outer join veiculo    v  with (nolock) on v.cd_veiculo     = ns.cd_veiculo
        left outer join motorista  m  with (nolock) on m.cd_motorista   = ns.cd_motorista

    end


