
CREATE PROCEDURE pr_consulta_programacao_recebimento
---------------------------------------------------------
--GBS - Global Business Solution	             2002
---------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar Programação de Recebimento através da Nota
--Data			: 25/06/2002
--Alteração		: 24/07/2002
--Desc. Alteração	: Colocado um Traço no CFOP. - Daniel C. Neto.
-- 03/08/2002 - Tirado cálculo de dias quando dt_saida_nota_saida <> Nulo 
--            - Colocado Não Definido, quando não houve transportadora.
--Alteração : Igor Gama -05/08/2002- Tirei o parametro de ic_parametro 
--            inclui mais um campo na sp
--	      Rafael Santiago -13/03/2003- Coloquei o filtro para trazer
--				a nota independente do período.
--            - 24/07/2003 Colocado o Destinatario e o Tipo do destinatario
-- 31/09/2004 - Incluído campo de Cidade e Estado - Daniel C. Neto.
-- 04.07.2008 - Inclusão de Novos Campos - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
@dt_inicial    datetime,
@dt_final      datetime,
@cd_nota_saida int = 0

AS

--  sp_help Nota_saida

    SELECT
      distinct
      ns.dt_saida_nota_saida,

      case 
        when ns.dt_saida_nota_saida is null then cast(
        (ns.dt_nota_saida - (getdate()-1) ) as Int)
        else 0
      end as 'Dias',

      case 
        when ns.dt_saida_nota_saida is null then cast(
        (ns.dt_nota_saida +
           Isnull((Select qt_dia_max_nota_empresa
                   From Parametro_Logistica 
                   Where cd_empresa = dbo.fn_empresa()), 0)
         - (getdate()-1) ) as Int)
        else 0
      end as 'DiasEntregue',

--      ns.cd_nota_saida,
 
      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
      end                                                  as cd_nota_saida,

      ns.dt_nota_saida,
      td.nm_tipo_destinatario, ns.nm_fantasia_destinatario as nm_fantasia_cliente,
      ns.vl_total,
      op.cd_mascara_operacao + ' - ' + op.nm_operacao_fiscal as 'CFOP',
      v.nm_fantasia_vendedor,
      e.nm_entregador,
      ns.nm_obs_entrega_nota_saida,
      t.nm_transportadora,      
      t.cd_ddd,
      t.cd_telefone,
      IsNull(ns.ic_minuta_nota_saida, 'N') as 'ic_minuta_nota_saida',
      case 
        when Isnull(ns.cd_transportadora,0) = 0 then 'N'
        else 'S'
      end as 'Transportadora',

      case 
        when ns.dt_saida_nota_saida is null and 
        (ns.dt_nota_saida < getdate()) then 'S'
        else 'N'
      end as 'Atraso', 

      IsNull(ns.ic_sedex_nota_saida, 'N') as 'Sedex',
      IsNull(ns.ic_coleta_nota_saida, 'N') as 'ic_coleta_nota_saida',
      IsNull(ns.ic_entrega_nota_saida, 'N') as 'ic_entrega_nota_saida' ,
      case
        when isnull(pv.ic_operacao_triangular, 'N') = 'S' then 'S' else 'N'
      end as 'ic_operacao_triangular',
      case
        when isnull(pv.ic_outro_cliente, 'N') = 'S' then 'S' else 'N'
      end as 'ic_outro_cliente',
      case
        when isnull(pv.ic_outro_cliente, 'N') = 'S' then (select nm_fantasia_cliente from Cliente where cd_cliente = pv.cd_cliente_faturar)
      end as 'nm_cliente_faturar',

      ns.dt_coleta_nota_saida,
      ns.nm_coleta_nota_saida,
      ns.cd_entregador,
      ns.nm_entregador_nota_saida,
      ns.cd_itinerario,
      ns.dt_entrega_nota_saida,
      ns.cd_observacao_entrega,
      ns.nm_endereco_entrega,
      ns.cd_numero_endereco_ent,
      ns.nm_complemento_end_ent,
      ns.nm_bairro_entrega + ' - ' + ns.sg_estado_entrega as 'BairroEst',
      IsNull(ns.nm_cidade_entrega, ns.nm_cidade_nota_saida) as nm_cidade_entrega,
      IsNull(ns.sg_estado_entrega, ns.sg_estado_nota_saida) as sg_estado_entrega,
      te.nm_tipo_local_entrega,
      Case 
        when IsNull(ns.ic_coleta_nota_saida, 'N') = 'S' then 'Coletado'
        Else 'Não Coletado'
      End as 'nm_status_coleta',
      ns.cd_usuario,
      ns.dt_usuario,
      ns.qt_peso_liq_nota_saida,
      ns.qt_peso_bruto_nota_saida,
      ns.qt_volume_nota_saida,
      ns.nm_especie_nota_saida,
      ns.nm_marca_nota_saida,
      ns.nm_numero_emb_nota_saida,
      i.nm_itinerario,
      vw.cd_cep,
      vc.nm_veiculo,
      m.nm_motorista,      
      ns.cd_pedido_venda

--select cd_itinerario,* from nota_saida

    FROM
      Nota_Saida ns         with (nolock)                                          LEFT OUTER JOIN
      Cliente cli           ON ns.cd_cliente            = cli.cd_cliente           left outer join
      Operacao_fiscal op    on op.cd_operacao_fiscal    = ns.cd_operacao_fiscal    left OUTER JOIN
      Vendedor v            ON v.cd_vendedor            = ns.cd_vendedor           LEFT OUTER JOIN
      Entregador e          ON e.cd_entregador          = ns.cd_entregador         left outer join
      Transportadora t      on t.cd_transportadora      = ns.cd_transportadora     left outer join
      Pedido_Venda pv       on pv.cd_pedido_venda       = ns.cd_pedido_venda  and
                               pv.cd_cliente            = ns.cd_cliente
      left outer join
                                     
      Tipo_Local_Entrega te on te.cd_tipo_local_entrega = ns.cd_tipo_local_entrega left outer join
      Tipo_destinatario td  on td.cd_tipo_destinatario  = ns.cd_tipo_destinatario  left outer join
      Itinerario        i   on i.cd_itinerario          = ns.cd_itinerario         left outer join
      Veiculo          vc   on vc.cd_veiculo            = i.cd_veiculo             left outer join
      Motorista        m    on m.cd_motorista           = ns.cd_motorista           --left outer join

      left outer join vw_destinatario vw on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                            vw.cd_destinatario      = ns.cd_cliente

--select * from vw_destinatario

--select * from itinerario
      
    WHERE     
      (ns.dt_nota_saida BETWEEN @dt_inicial AND @dt_final) AND 
      (ns.cd_status_nota<> 7 )                             AND -- Nota Fiscal Cancelada 
      ((@cd_nota_saida = 0) OR 
       (ns.dt_cancel_nota_saida is null AND ns.cd_nota_saida =  @cd_nota_saida)) OR
	ns.cd_nota_saida =  @cd_nota_saida 


    ORDER BY 
      ns.dt_nota_saida desc, 
      ns.cd_nota_saida desc


