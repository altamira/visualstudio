CREATE PROCEDURE pr_consulta_nota_fiscal_geral
--------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--------------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): ???
--Banco de Dados: EGISSQL
--Objetivo: Consultar a Nota Fiscal Geral
--Data: ????
--Atualizado: 11/04/2003 - Inclusão do Parâmetro 4 para buscar uma nota fiscal única
--                         sem considerar o status - ELIAS
--            06/06/2003 - Ordenação por Data. - Daniel C. Neto. 
--            13/06/2003 - Acréscimo de campos necessários a baixa de árvore
--                         no cancelamento de NF quando produto especial - ELIAS
--            25/08/2003 - Inclusão de flag que indicará se a NF baixará saldo de ns ou não. - ELIAS
--                         Modificado prefixo utilizado p/ identificar a tabela Nota_Fiscal de pv p/ ns - ELIAS
--            08.06.2004 - Foi implementado o retorno dos campos de Terceiro/Consignação e ordenado o retorno por data e depois no. nota
--            03/11/2004 - Incluído campo Sel, usado na tela de exclusão de movimento de nota - Daniel C. Neto.
--            25/05/2005 - Acréscimo do campo Fase Movimentada no Parâmetro 2 - ELIAS
--            07.11.2005 - Verificação da Composição/colocado isnull no PV - Carlos Fernandes
--            07.12.2006 - Acertos - Carlos Fernandes
-- 16.11.2007            - Acertos Diversos - Carlos Fernandes
-- 10.02.2009            - Conversão de Unidade do Cadastro do cliente - Carlos Fernandes
-- 19.02.2009            - Unidadade de Medida - Carlos Fernandes
-- 14.04.2009 - Complemento dos Campos - Carlos Fernandes
-- 04.05.2009 - Flag da Nota Fiscal Eletrônica - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------
  @ic_parametro   int,
  @cd_status_nota int,
  @cd_nota_saida  int,
  @dt_inicial     Datetime,
  @dt_final       Datetime,
  @cd_loja        int = 0 
as
-------------------------------------------------------------------------------
  if @ic_parametro = 1
-------------------------------------------------------------------------------
  begin 
    --select * from nota_saida 
      Select
          distinct
          0                                as Sel,
          ns.cd_cliente                    as 'CodCliente',
          ns.nm_fantasia_destinatario      as 'Cliente',
          ns.nm_razao_social_nota          as 'RazaoCliente',
          ns.cd_tipo_destinatario          as 'CodTipoDestinatario',
     	  (Select top 1 nm_tipo_destinatario from Tipo_Destinatario where cd_tipo_destinatario  = ns.cd_tipo_destinatario) as 'TipoDestinatario',
          ns.cd_nota_saida                 as 'Nota',
          ns.cd_identificacao_nota_saida,
          ns.dt_nota_saida                 as 'Emissao',
          ns.cd_vendedor                   as 'CodVendedor',  
          ns.cd_status_nota                as 'Status',  
          isnull(ns.ic_nfe_nota_saida,'N') as 'NFE',

          sn.nm_status_nota            as 'NomeStatus',
          v.nm_fantasia_vendedor       as 'Vendedor',
          v.nm_vendedor                as 'RazaoVendedor',
          ns.nm_mot_cancel_nota_saida  as 'MotivoCancelamento',
          ns.dt_cancel_nota_saida      as 'DataCancelamento',
          ns.dt_cancel_nota_saida      as 'DataCancelamento',
          ns.cd_operacao_fiscal,
          op.cd_mascara_operacao + ' - ' + op.nm_operacao_fiscal as 'CFOP',
      	  ns.vl_total,
          ns.dt_saida_nota_saida,
          ns.cd_tipo_destinatario,
          ns.dt_cancel_nota_saida,
          ns.cd_nota_dev_nota_saida,
          isnull(c.cd_unidade_medida,0) as cd_unidade_medida_cliente,
          ns.cd_cliente,
          vei.nm_veiculo,
          m.nm_motorista
--select * from cliente
      from 
          Nota_Saida ns           with (nolock) 
          Left Join 
          Cliente c               with (nolock)       
              On ns.cd_cliente     = c.cd_cliente left outer join
          Status_Nota sn          with (nolock) 
              on sn.cd_status_nota = ns.cd_status_nota Left Join 
          Vendedor v              with (nolock) 
              On ns.cd_vendedor    = v.cd_vendedor Left Join 
          Operacao_Fiscal op      with (nolock) 
              on op.cd_operacao_fiscal = ns.cd_operacao_fiscal
          left outer Join Veiculo vei   on vei.cd_veiculo = ns.cd_veiculo
          left outer Join Motorista m   on m.cd_motorista = ns.cd_motorista      

--sele
--          left outer Join Nota_Saida_Recibo on nsr on nsr.cd_nota_saida = ns.cd_nota_saida

--select * from nota_saida_recibo

      where 
          (ns.dt_nota_saida between @dt_inicial and @dt_final) and
          IsNull(ns.cd_status_nota,0) = ( case when IsNull(@cd_status_nota,0) = 0 then
                                            IsNull(ns.cd_status_nota,0) else
                                            @cd_status_nota end )  and 
          ns.cd_nota_saida = ( case when IsNull(@cd_nota_saida,0) = 0 then                                  
                                 ns.cd_nota_saida else
                                @cd_nota_saida end ) and
          IsNull(ns.cd_loja,0) = ( case when @cd_loja = 0 then
                                  IsNull(ns.cd_loja,0) else @cd_loja end )                          
      order by ns.dt_nota_saida desc, ns.cd_nota_saida desc
  end
-----------------------------------------------------------------------------------------
  else if @ic_parametro = 2 -- Consulta somente pedidos do Pcp
-----------------------------------------------------------------------------------------
  begin
      Select 
          distinct 
          ns.cd_identificacao_nota_saida,
          nsi.cd_nota_saida             as 'Nota',
          nsi.nm_fantasia_produto       as 'CodigoProduto',
          -- ELIAS 01/07/2003
          'CodigoProdutoBaixa' =
              case 
                  when isnull(p.cd_produto_baixa_estoque,0) = 0 then p.cd_produto
                  else p.cd_produto_baixa_estoque
              end,
          nsi.nm_produto_item_nota      as 'DescricaoProduto',
          nsi.cd_item_nota_saida        as 'Item',
          nsi.qt_item_nota_saida        as 'Qtde',
          nsi.vl_unitario_item_nota     as 'Unitario',
          (nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota)    as 'Venda',
          nsi.pc_desconto_item          as 'PercDesconto',
          nsi.qt_liquido_item_nota      as 'QtdLiquida',
          nsi.qt_devolucao_item_nota    as 'QtdDevolvida',
          nsi.dt_cancel_item_nota_saida as 'DataCancelamento',
          nsi.cd_pedido_venda           as 'PedidoVenda',
          nsi.cd_item_pedido_venda      as 'ItemPedido',
          nsi.vl_total_item             as 'Total',
          nsi.pc_icms                   as 'ICMS',
          nsi.pc_ipi                    as 'IPI',
          nsi.qt_bruto_item_nota_saida  as 'Bruto',
          ProdCusto.ic_peps_produto     As 'Peps',
      	  IsNull(nsi.ic_movimento_estoque,'N') as ic_movimento_estoque,
          case when (isnull(pv.ic_operacao_triangular,'N') = 'S') and 
                    (isnull(op.ic_comercial_operacao,'S') = 'N') then 'N'
               else 'S'
          end as 'ic_baixar_saldo_pedido_venda',            
          nsi.cd_status_nota,
          nsi.cd_produto,
          nsi.cd_grupo_produto,
          gpc.ic_estoque_grupo_prod,
					case isnull(nsi.cd_pedido_venda ,0)
 					  when 0 then 'N'
				    else 
                  Case IsNull((Select top 1 ic_montagem_item_pedido 
						             from Pedido_Venda_Item
                               where cd_pedido_venda = nsi.cd_pedido_venda 
                                     and cd_item_pedido_venda = nsi.cd_item_pedido_venda),'N')
                  When 'N' then
                       IsNull((Select top 1 ic_kit_grupo_produto 
						             from Pedido_Venda_Item
                               where cd_pedido_venda = nsi.cd_pedido_venda 
                                     and cd_item_pedido_venda = nsi.cd_item_pedido_venda),'N')
                  else
                     'S'
                  end
					 end as ic_composicao_especial,
					 IsNull(op.ic_estoque_op_fiscal ,'S') as ic_estoque_op_fiscal,
           IsNull(op.ic_terceiro_op_fiscal, 'N' ) as ic_terceiro_op_fiscal,
           IsNull(op.ic_consignacao_op_fiscal, 'N' ) as ic_consignacao_op_fiscal,
           nsi.cd_operacao_fiscal,
           nsi.cd_fase_produto,
           nsi.cd_pedido_importacao,
           nsi.cd_item_ped_imp,
           nsi.cd_fase_produto as 'FaseMovimentada',
           nsi.cd_lote_item_nota_saida,
           nsil.nm_lote,
           p.cd_versao_produto,
--select * from nota_saida_item
           isnull(nsi.qt_multiplo_embalagem,0) as qt_multiplo_embalagem
      from 
          Nota_Saida_item nsi with (nolock)
          Left Join Nota_Saida ns
              On ns.cd_nota_saida = nsi.cd_nota_saida
          Left Join Pedido_Venda pv
              On pv.cd_pedido_venda = nsi.cd_pedido_venda left outer join
          Operacao_fiscal op
              On op.cd_operacao_fiscal = nsi.cd_operacao_fiscal left outer join
          Produto P
              On P.cd_Produto = nsi.cd_Produto Left Join 
          Produto_Custo ProdCusto
              On ProdCusto.cd_Produto = nsi.cd_Produto left outer join
          Grupo_Produto gp
              On gp.cd_grupo_produto = nsi.cd_grupo_produto left outer join
          Grupo_Produto_Custo gpc
              on gpc.cd_grupo_produto = gp.cd_grupo_produto left outer join
          Nota_saida_item_lote nsil
              On nsi.cd_nota_saida      = nsil.cd_nota_saida and
                 nsi.cd_item_nota_saida = nsil.cd_item_nota_saida
      where 
          (nsi.cd_nota_saida = @cd_nota_saida)                           

      order by 
          nsi.cd_item_nota_saida
  end
-------------------------------------------------------------------------------
  else if @ic_parametro = 3
-------------------------------------------------------------------------------
  begin 
      Select
          distinct
          ns.cd_cliente                    as 'CodCliente',
          ns.nm_fantasia_destinatario      as 'Cliente',
          ns.nm_razao_social_nota          as 'RazaoCliente',
          ns.cd_tipo_destinatario          as 'CodTipoDestinatario',
	        (Select top 1 nm_tipo_destinatario from Tipo_Destinatario where cd_tipo_destinatario  = ns.cd_tipo_destinatario)      as 'TipoDestinatario',
          ns.cd_nota_saida                 as 'Nota',
          ns.cd_identificacao_nota_saida,
          ns.dt_nota_saida                 as 'Emissao',
          ns.cd_vendedor                   as 'CodVendedor',  
          ns.cd_status_nota                as 'Status',  
          isnull(ns.ic_nfe_nota_saida,'N') as 'NFE',
          sn.nm_status_nota            as 'NomeStatus',
          v.nm_fantasia_vendedor       as 'Vendedor',
          v.nm_vendedor                as 'RazaoVendedor',
          ns.nm_mot_cancel_nota_saida  as 'MotivoCancelamento',
          ns.dt_cancel_nota_saida      as 'DataCancelamento',
          ns.cd_operacao_fiscal,
          op.cd_mascara_operacao + ' - ' + op.nm_operacao_fiscal as 'CFOP',
          ns.vl_total,
          ns.dt_saida_nota_saida,
          ns.cd_tipo_destinatario,
          ns.dt_cancel_nota_saida,
          ns.cd_nota_dev_nota_saida,
          isnull(c.cd_unidade_medida,0) as cd_unidade_medida_cliente,
          ns.cd_cliente,
          vei.nm_veiculo,
          m.nm_motorista


      from 
          Nota_Saida ns with (nolock) Left Join 
         Cliente c      
             On ns.cd_cliente = c.cd_cliente left outer join
          Status_Nota sn 
              on sn.cd_status_nota = ns.cd_status_nota Left Join 
          Vendedor v     
              On ns.cd_vendedor = v.cd_vendedor Left Join 
         	Operacao_Fiscal op 
              on op.cd_operacao_fiscal = ns.cd_operacao_fiscal
          left outer Join Veiculo vei   on vei.cd_veiculo = ns.cd_veiculo
          left outer Join Motorista m   on m.cd_motorista = ns.cd_motorista      
      where 
          IsNull(ns.cd_status_nota,0) = ( case when IsNull(@cd_status_nota,0) = 0 then
                                            IsNull(ns.cd_status_nota,0) else
                                            @cd_status_nota end )  and 
          ns.cd_nota_saida = ( case when IsNull(@cd_nota_saida,0) = 0 then                                  
                                 ns.cd_nota_saida else
                                @cd_nota_saida end ) and
          IsNull(ns.cd_loja,0) = ( case when @cd_loja = 0 then
                                  IsNull(ns.cd_loja,0) else @cd_loja end )                          

      order by 
          ns.dt_nota_saida desc, ns.cd_nota_saida desc

  end
-------------------------------------------------------------------------------
  else if @ic_parametro = 4   -- Traz uma única Nota sem Considerar o Status
-------------------------------------------------------------------------------
  begin 
      Select
          distinct
          ns.cd_identificacao_nota_saida,
          ns.cd_cliente                as 'CodCliente',
          ns.nm_fantasia_destinatario  as 'Cliente',
          ns.nm_razao_social_nota      as 'RazaoCliente',
          ns.cd_tipo_destinatario      as 'CodTipoDestinatario',
	        (Select top 1 nm_tipo_destinatario from Tipo_Destinatario where cd_tipo_destinatario  = ns.cd_tipo_destinatario)      as 'TipoDestinatario',
          ns.cd_nota_saida             as 'Nota',
          ns.dt_nota_saida             as 'Emissao',
          ns.cd_vendedor               as 'CodVendedor',  
          ns.cd_status_nota            as 'Status',  
          sn.nm_status_nota            as 'NomeStatus',
          v.nm_fantasia_vendedor       as 'Vendedor',
          v.nm_vendedor                as 'RazaoVendedor',
          ns.nm_mot_cancel_nota_saida  as 'MotivoCancelamento',
          ns.dt_cancel_nota_saida      as 'DataCancelamento',
          ns.cd_operacao_fiscal,
          op.cd_mascara_operacao + ' - ' + op.nm_operacao_fiscal as 'CFOP',
          ns.vl_total,
          ns.dt_saida_nota_saida,
          ns.cd_tipo_destinatario,
          ns.dt_cancel_nota_saida,
          ns.cd_nota_dev_nota_saida,
          isnull(c.cd_unidade_medida,0) as cd_unidade_medida_cliente,
          ns.cd_cliente,
          vei.nm_veiculo,
          m.nm_motorista

      from 
          Nota_Saida ns with (nolock) Left Join 
         Cliente c      
             On ns.cd_cliente = c.cd_cliente left outer join
          Status_Nota sn 
              on sn.cd_status_nota = ns.cd_status_nota Left Join 
          Vendedor v     
              On ns.cd_vendedor = v.cd_vendedor Left Join 
          Operacao_Fiscal op 
              on op.cd_operacao_fiscal = ns.cd_operacao_fiscal
          left outer Join Veiculo vei   on vei.cd_veiculo = ns.cd_veiculo
          left outer Join Motorista m   on m.cd_motorista = ns.cd_motorista      
      where 
          ns.cd_nota_saida = @cd_nota_saida and
           IsNull(ns.cd_loja,0) = ( case when @cd_loja = 0 then
                                   IsNull(ns.cd_loja,0) else @cd_loja end )                          

  end


