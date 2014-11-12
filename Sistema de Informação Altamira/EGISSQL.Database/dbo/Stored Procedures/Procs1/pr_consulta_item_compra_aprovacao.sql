
CREATE PROCEDURE pr_consulta_item_compra_aprovacao
------------------------------------------------------------------------------------------------------
-- GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Daniel C. Neto.
-- Banco de Dados: EgisSql
-- Objetivo: Realizar uma consulta de itens do Pedido_Compra para Aprovação 
-- Data: 18/12/2003
-- Alterado: 06/05/2003 - Acerto no Consumo Médio - Daniel c. Neto.
--           08/01/2003 - Acerto na Duração - Daniel C. Neto.
--                      - Colocado Distinct - Daniel C. Neto.
--           09/01/2004 - Inclusão de Novas Colunas - Daniel Carrasco
--           09/03/2004 - Excluído campo duplicado de 
-- peso bruto - Daniel C. Neto.
-- 17/03/2004 - Usado função de consumo médio- Daniel C. Neto.
-- 22/06/2004 - Incluído coluna tipo de placa - Daniel C. Neto.
-- 17.05.2006 - Inclusão da coluna "Dt. Entrega" - Fabio Cesar
-- 06/10/2006 - Incluído plano de compra e centro de custo - daniel c. neto.
-- 06.03.2007 - Consulta do Valor Total - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@cd_pedido_compra as int

AS

declare @cd_fase_produto int

declare @data_inicial datetime
declare @data_final   datetime 
declare @cd_ano       int
declare @cd_mes       int

  -----------------------------------------------------
  -- Calcular as Datas
  -----------------------------------------------------
  SET DATEFORMAT ymd

  -- Decompor data final
  set @cd_ano = Year( Getdate() )
  set @cd_mes = Month( Getdate() )

  -- Data Final do Período
  set @data_final = dateadd( dd , -1, Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime) )

  print 'Dt. Final'
  print @data_final

  -- Definir a data Inicial para o cálculo Trimestral
  set @data_inicial = dateadd( mm , -2, @data_final )
  set @cd_mes = Month( @data_inicial ) 
  set @cd_ano = Year( @data_inicial ) 
  set @data_inicial = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)

  print 'Dt. Inicial Calc. Trim.'
  print @data_inicial


set @cd_fase_produto = ( select cd_fase_produto from Parametro_Suprimento where cd_empresa = dbo.fn_empresa() )


    SELECT  distinct
      pci.cd_pedido_compra,
      pc.vl_total_pedido_compra, 
      pci.cd_cotacao,
      pci.cd_item_cotacao,
      pci.dt_item_nec_ped_compra,
      pci.qt_item_pesliq_ped_compra, 
      pci.qt_item_pesbr_ped_compra, 
      pci.cd_item_pedido_compra, 
      pci.qt_item_pedido_compra, 
      pci.qt_saldo_item_ped_compra, 
      pci.vl_item_unitario_ped_comp, 
      cast(pci.ds_item_pedido_compra as varchar(2000)) as ds_item_pedido_compra,
      case when isnull(pci.vl_total_item_pedido_comp,0)>0 
         then pci.vl_total_item_pedido_comp
         else 
              pci.qt_saldo_item_ped_compra*pci.vl_item_unitario_ped_comp
         end                      as 'Total_Compra_Item', 
      dbo.fn_mascara_produto(pci.cd_produto) as cd_mascara_produto,
      pci.cd_produto,
      IsNull(pci.nm_fantasia_produto, s.nm_servico) as nm_fantasia_produto,
      IsNull(pci.nm_produto, s.nm_servico) as nm_produto,
      case when pci.cd_materia_prima is null then null else
        mp.nm_mat_prima end as 'Materia_Prima',
      pci.nm_medbruta_mat_prima,
      pci.nm_medacab_mat_prima,
      ne.cd_nota_entrada,
      ne.dt_nota_entrada,
      (nei.vl_item_nota_entrada * nei.qt_item_nota_entrada) as 'qt_Qtdade',
      nei.cd_item_nota_entrada,
      nei.qt_item_nota_entrada,
      pci.cd_requisicao_compra,
      pci.cd_requisicao_compra_item,
      IsNull(tp.ic_pedido_mat_prima, 'N') as ic_pedido_mat_prima,
      case IsNull(pci.cd_pedido_venda,0) 
        when 0 then cast('' as varchar(15))
        else (Select top 1 c.nm_fantasia_cliente 
              from Pedido_Venda pv with (nolock)
              inner join Cliente c with (nolock)
                on c.cd_cliente = pv.cd_cliente
              where pv.cd_pedido_venda = pci.cd_pedido_venda)
      end as nm_fantasia_cliente,
      pci.cd_pedido_venda,
      pci.cd_item_pedido_venda,
       dbo.fn_consumo_medio
         ( @cd_fase_produto, pci.cd_produto, @data_inicial, @data_final) as total,
       ps.qt_consig_produto         as Saldo_Estoque_Consignacao,
      isnull(ps.qt_saldo_atual_produto,0.00)                    as 'Atual',
      isnull(ps.qt_saldo_reserva_produto,0.00)                  as 'Reserva',
      isnull(ps.qt_pd_compra_produto,0.00)                      as 'Compra',
      isnull(ps.qt_req_compra_produto,0.00)                     as 'Requisicao',
      isnull(ps.qt_consumo_produto,0.00)                        as 'Consumo',
      isnull(ps.qt_minimo_produto,0.00)                         as 'Minimo',
      isnull(((ps.qt_saldo_reserva_produto/
--               cast(replace(Cast(ps.qt_consumo_produto as varchar(20)),'0','1') as int))*30),0.00)  as 'Duracao'
        Cast(ps.qt_consumo_produto as int))*30),0.00)  as 'Duracao',

      case IsNull(pci.cd_produto,0) 
        when 0 then cast('' as char(1))
        else (Select top 1 gp.ic_especial_grupo_produto 
              from Produto p with (nolock)
              inner join Grupo_produto gp with (nolock)
                on gp.cd_grupo_produto = p.cd_grupo_produto
              where p.cd_produto = pci.cd_produto)
      end as ic_especial_grupo_produto,
      pci.nm_placa,
      pci.dt_entrega_item_ped_compr,
      cc.nm_centro_custo,
      plc.nm_plano_compra

    FROM
      Pedido_Compra_Item pci with (nolock)
    inner join Pedido_Compra pc with (nolock)      on pc.cd_pedido_compra = pci.cd_pedido_compra
    left outer join Tipo_Pedido tp with (nolock)   on tp.cd_tipo_pedido = pc.cd_tipo_pedido
    left outer join Materia_Prima mp with (nolock) on mp.cd_mat_prima=pci.cd_materia_prima
    Left Outer Join Nota_Entrada_Item nei with (nolock) on 
       nei.cd_pedido_compra = pci.cd_pedido_compra and
       nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
    Left Outer Join Nota_Entrada ne with (nolock) on 
      ne.cd_fornecedor = nei.cd_fornecedor and
      ne.cd_nota_entrada = nei.cd_nota_entrada 
    left outer join Servico s with (nolock) on  s.cd_servico = pci.cd_servico
    left outer join Produto_Saldo ps with (nolock) on
      ps.cd_produto = pci.cd_produto and
      ps.cd_fase_produto = @cd_fase_produto 
    left outer join Centro_Custo cc with (nolock)  on cc.cd_Centro_Custo = pci.cd_Centro_Custo
    left outer join Plano_Compra plc with (nolock) on plc.cd_plano_compra = pci.cd_plano_compra
    WHERE     
      pc.cd_pedido_compra = @cd_pedido_compra

    ORDER BY
      pci.cd_pedido_compra, pci.cd_item_pedido_compra


