
--use egissql
-------------------------------------------------------------------------------
--pr_comissao_documentos_pagos
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                     2004
-------------------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Paulo Souza
--Banco de Dados      : EgisSQL
--Objetivo            : Consulta pré-calculo de comissão de documentos pagos
--Data                : 10/09/04
--                    : 28/09/2004 - Acrescentado Margem de Contribuição e Valor de Comissão
--                                   em Parâmetro 3 - ELIAS
--                    : 30/09/2004 - Acerto no cálculo da comissão - ELIAS
--                    : 17/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                    : 08.01.2005 - Verificação do Cálculo - Carlos Fernandes
--                    : 19.01.2006 - Parâmetro para Consulta Composta - Carlos Fernandes
--                    : 09.08.2007 - Mudança da Lista de Preço para R$ - Carlos Fernandes
-- 03.01.2008 - Gravação na Margem na tabela do Pedido de Venda - Carlos Fernandes
-- 04.01.2008 - Atualização / Gravação da Tabela Auxiliar de Cálculo da Comissão - Carlos Fernandes
-- 07.01.2007 - Mostrar por Vendedor - Carlos Fernandes
-- 19.01.2008 - Acerto da Custo do Produto para Buscar da data de processo da Comissão - Carlos Fernandes
-- 17.04.2008 - Ajustes e verificação Geral - Carlos Fernandes
-- 29.08.2008 - Produto modificado para o Preço em R$ - Carlos Fernandes
-- 15.12.2008 - Valor do IPI da Nota Fiscal / Parcelas - Carlos Fernandes
-- 03.11.2009 - Buscar o (%) de comissão do Pedido de Venda - Carlos Fernandes 
-- 11.05.2010 - Zerar o Cálculo conforme a tabela - Carlos Fernandes
-- 30.05.2010 - Campos - Carlos Fernandes
--              Customização para Altamira - Carlos Fernandes 
-- 08.10.2010 - Ajustes Diversos - Carlos Fernandes
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
-- 11.01.2011 - Verificação do procedimento - Carlos Fernandes
--
---------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE pr_comissao_documentos_pagos
@ic_parametro         int       = 0,
@dt_inicial           datetime  = '',
@dt_final             datetime  = '', 
@cd_vendedor          int       = '',
@cd_nota_saida        int       = 0,
@cd_documento_receber int       = 0,
@cd_item_documento    int       = 0,
@cd_usuario           int       = 0

------------------------------------------------------------------------------------------------
-- Cálculo da Margem de Contribuição
------------------------------------------------------------------------------------------------
--
--      Preço Net      * Cotação da Moeda
--    _________________________________________
--
--      Preço Unitário * Indice Markup * ICMS
--
------------------------------------------------------------------------------------------------


AS

  declare @cd_markup        int
  declare @cd_markup_bc     int
  declare @ic_deduz_parcela char(1) 

  -- Markup p/ Cálculo da Margem de Contribuição e
  -- Markup p/ Cálculo da Base da Comissão

  select @cd_markup    = cd_aplicacao_markup,
         @cd_markup_bc = cd_aplicacao_markup_base_calc
  from 
    parametro_comissao_empresa with (nolock) 

  where 
    cd_empresa = dbo.fn_empresa()


  select
    @ic_deduz_parcela = case when e.nm_fantasia_empresa = 'ALTAMIRA' then 'S' else 'N' end
  from
    egisadmin.dbo.empresa e with (nolock) 
  where
    e.cd_empresa = dbo.fn_empresa()

------------------------------------------------------------------------------------------------
--Atualiza os itens do Pedido de Venda com o Valor da Cotação
------------------------------------------------------------------------------------------------
--vl_moeda_cotacao
--select isnull(dbo.fn_vl_moeda_periodo(2,'07/01/2008'),1)   
--select * from pedido_venda_item

update
  pedido_venda_item
set
  vl_moeda_cotacao = isnull(dbo.fn_vl_moeda_periodo(2,p.dt_pedido_venda),1),
  dt_moeda_cotacao = p.dt_pedido_venda   
from
  pedido_venda_item i
  inner join pedido_venda p on p.cd_pedido_venda = i.cd_pedido_venda
where
  p.dt_pedido_venda between @dt_inicial and @dt_final
  and i.cd_moeda_cotacao<>1

------------------------------------------------------------------------------------------------
--Atualiza os itens da Nota com o Valor da Cotação
------------------------------------------------------------------------------------------------
--vl_moeda_cotacao
--select isnull(dbo.fn_vl_moeda_periodo(2,'07/01/2008'),1)   

update
  nota_saida_item
set
  vl_moeda_cotacao = isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),1)   
from
  nota_saida_item i 
  inner join nota_saida ns on ns.cd_nota_saida = i.cd_nota_saida
where
  ns.dt_nota_saida between @dt_inicial and @dt_final

------------------------------------------------------------------------------------------------
If @ic_parametro = 1 or @ic_parametro = 2    -- Consulta geral
------------------------------------------------------------------------------------------------

  Begin

     --Atualiza a Tabela de Cálculo
     --select * from comissao_pedido_venda

     delete from comissao_pedido_venda where isnull(ic_manutencao_calculo,'N')='N' and
                                             dt_base_calculo_comissao between @dt_inicial and @dt_final


     --Monta a Tabela Principal

    select
      drp.cd_documento_receber       as 'DocumentoReceber',
      drp.cd_item_documento_receber  as 'ItemDocumento', 
      d.cd_identificacao	     as 'Documento',
      d.dt_emissao_documento	     as 'Emissao',
      d.dt_vencimento_documento	     as 'Vencimento',
      drp.dt_pagamento_documento     as 'Pagamento',

      drp.vl_pagamento_documento     as 'Valor',

      drp.vl_pagamento_documento            - 

      isnull(drp.vl_juros_pagamento     ,0) -
      isnull(drp.vl_despesa_bancaria    ,0) -
      isnull(drp.vl_credito_pendente    ,0) -
      isnull(drp.vl_reembolso_documento ,0) +
      isnull(drp.vl_desconto_documento  ,0) +
      isnull(drp.vl_abatimento_documento,0) as 'Valor_Principal',

      dr.vl_saldo_documento	            as 'Saldo',
      drp.vl_juros_pagamento	            as 'Juros',
      drp.vl_desconto_documento	            as 'Desconto',
      drp.vl_abatimento_documento           as 'Abatimento',
      c.nm_fantasia_cliente	            as 'Fantasia',

      Case 
         When v.nm_fantasia_vendedor is null 
         Then
          'Sem Vendedor'
         Else
           v.nm_fantasia_vendedor
      End                                   as 'Vendedor',

      IsNull(v.cd_vendedor,0)               as 'CodigoVendedor',
      p.nm_portador                         as 'Portador',
      drp.nm_obs_documento	            as 'Historico',
      tl.nm_tipo_liquidacao	            as 'Liquidacao',
      b.nm_banco			    as 'Banco',
      cab.nm_conta_banco		    as 'Conta',
--      ns.cd_nota_saida,
--      ns.cd_nota_saida                      as 'NumeroNota',

      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                                   as 'NumeroNota',

      ns.vl_total                           as 'ValorNota',
      ns.dt_nota_saida                      as 'EmissaoNota',
      ns.vl_ipi                             as 'IpiNota',
      cp.sg_condicao_pagamento              as 'CondicaoPagamento',
      d.cd_pedido_venda                     as 'PedidoVenda',

      ns.cd_nota_saida,
      ns.cd_identificacao_nota_saida,

--       case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
--          ns.cd_identificacao_nota_saida
--       else
--          ns.cd_nota_saida                  
--       end                                   as cd_nota_saida,
-- 
      d.cd_documento_receber,
      drp.cd_item_documento_receber,
      isnull(cp.qt_parcela_condicao_pgto,0) as 'qtd_parcela',

      case when @ic_deduz_parcela = 'N' 
      then
        case when isnull(cp.qt_parcela_condicao_pgto,0) > 0 
        then
          ( ns.vl_total - isnull(ns.vl_ipi,0)  )
          /
          isnull(cp.qt_parcela_condicao_pgto,0)
        else
          0.00
        end
      else
        --Deduz o Valor da Parcela
        --Especial para empresa Altamira --> 28.05.2010

        case when isnull(cp.qt_parcela_condicao_pgto,0) > 0 
        then
          case when cp.qt_parcela_condicao_pgto > 1 
          then
            (( ns.vl_total - isnull(ns.vl_ipi,0)  ) - ( select top 1 x.vl_documento_receber from documento_receber x where x.cd_nota_saida = ns.cd_nota_saida order by dt_vencimento_documento ) ) 
            /
            (isnull(cp.qt_parcela_condicao_pgto,0)  -  1 )
          else
            ( ns.vl_total - isnull(ns.vl_ipi,0)  ) / isnull(cp.qt_parcela_condicao_pgto,0) 

          end

        else
          0.00
        end

       end                                    as 'Valor_Parcela_Sem_IPI',

      isnull(pv.pc_comissao_especifico,0)     as pc_comissao_especifico,



      ( isnull(pv.pc_comissao_especifico,0) / 100 ) 

      *

      case when @ic_deduz_parcela = 'N'
      then

        (drp.vl_pagamento_documento            - 

        isnull(drp.vl_juros_pagamento     ,0) -
        isnull(drp.vl_despesa_bancaria    ,0) -
        isnull(drp.vl_credito_pendente    ,0) -
        isnull(drp.vl_reembolso_documento ,0) +
        isnull(drp.vl_desconto_documento  ,0) +
        isnull(drp.vl_abatimento_documento,0)) 

    else

        case when isnull(cp.qt_parcela_condicao_pgto,0) > 0 
        then
          case when cp.qt_parcela_condicao_pgto > 1 
          then
            (( ns.vl_total - isnull(ns.vl_ipi,0)  ) - ( select top 1 x.vl_documento_receber from documento_receber x where x.cd_nota_saida = ns.cd_nota_saida order by dt_vencimento_documento ) ) 
            /
            (isnull(cp.qt_parcela_condicao_pgto,0)  -  1 )
          else
            ( ns.vl_total - isnull(ns.vl_ipi,0)  ) / isnull(cp.qt_parcela_condicao_pgto,0) 

          end

        else
          0.00
        end

    end   as 'Valor_Comissao'


    --select * from documento_receber_pagamento
    --select * from condicao_pagamento

    Into
      #TmpComissao_Documentos_Pagos

    from
      Documento_Receber_Pagamento drp         with (nolock) 
      inner join Documento_Receber d          with (nolock) on (drp.cd_documento_receber = d.cd_documento_receber)
      left outer join Cliente	c             with (nolock) on (d.cd_cliente             = c.cd_cliente) 
      left outer join Vendedor v              with (nolock) on (v.cd_vendedor            = d.cd_vendedor)
      left outer join Portador p              with (nolock) on (p.cd_portador            = d.cd_portador)
      left outer join Tipo_Liquidacao tl      with (nolock) on (drp.cd_tipo_liquidacao   = tl.cd_tipo_liquidacao)
      left outer join Banco b                 with (nolock) on (drp.cd_banco             = b.cd_banco)
      left outer join Conta_Agencia_Banco cab with (nolock) on (drp.cd_banco             = cab.cd_banco and drp.cd_conta_banco = cab.cd_conta_banco)
      left outer join Documento_Receber	dr    with (nolock) on (drp.cd_documento_receber = dr.cd_documento_receber)
      left outer join Nota_Saida ns           with (nolock) on (ns.cd_nota_saida         = dr.cd_nota_saida)
      left outer join Condicao_Pagamento cp   with (nolock) on (cp.cd_condicao_pagamento = ns.cd_condicao_pagamento)
      left outer join Pedido_Venda       pv   with (nolock) on pv.cd_pedido_venda        = d.cd_pedido_venda

    where
      (drp.dt_pagamento_documento between @dt_inicial and @dt_final) and
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final )) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento    > @dt_final )) and
      ( d.cd_vendedor = case when @cd_vendedor = 0 then d.cd_vendedor else @cd_vendedor end )

    order by
      v.nm_fantasia_vendedor,
      drp.dt_pagamento_documento

    --Tabela Principal

    Select 
      *
    From 
      #TmpComissao_Documentos_Pagos
    Order By 
      Vendedor, Fantasia, NumeroNota

    --Montagem da Tabela Auxiliar    

  Select 
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,

--         nsi.cd_nota_saida                      as 'NotaFiscal',
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                                       as 'NotaFiscal',

         nsi.cd_item_nota_saida                 as 'ItemNota',
         IsNull(nsi.cd_pedido_venda,0)          as 'Pedido',
         nsi.cd_item_pedido_venda               as 'ItemPedido',
         nsi.cd_produto                         as 'ChaveProduto', 
         dbo.fn_mascara_produto(nsi.cd_produto) as 'CodigoProduto',
         nsi.nm_fantasia_produto                as 'FantasiaProduto',
         nsi.nm_produto_item_nota               as 'DescricaoProduto',
         IsNull(nsi.qt_item_nota_saida,0)       as 'QuantidadeItem',
         IsNull(nsi.vl_unitario_item_nota,0)    as 'ValorUnitario',
         un.sg_unidade_medida                   as 'UN',
         IsNull(nsi.vl_total_item,0)            as 'ValorTotal',
         IsNull(mo.sg_moeda,'')                 as 'Moeda',

         case when isnull(p.cd_moeda,1)<> 1
         then
            (IsNull(nsi.vl_total_item,0)        * IsNull(pvi.vl_moeda_cotacao,0))   
         else
            (IsNull(nsi.vl_total_item,0)        / isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),nsi.vl_moeda_cotacao))   

         end                                    as 'ValorTotalMoeda',

         case when isnull(p.cd_moeda,1)<> 1
         then
            (IsNull(pv.vl_total_pedido_venda,0) * IsNull(pv.vl_indice_pedido_venda,1)) 
         else
            (IsNull(pv.vl_total_pedido_venda,0) / isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))) 

         end                                    as 'TotalPedidoMoeda',

         -- Cálculo da Margem de Contribuição

         -- MARGEM DE CONTRIBUIÇÃO

         case when isnull(p.cd_moeda,1)<> 1
         then

           dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
--Antes         
--           (isnull(pc.vl_net_outra_moeda,0) / isnull(pvi.vl_moeda_cotacao,0) ) /

           (

--Antes de 29.08.2008

--            (case when isnull(ph.vl_historico_produto,0)>0
--             then
-- 
--              isnull(ph.vl_historico_produto,0)
--             else
--              isnull(pc.vl_custo_previsto_produto,0)
--             end ) / 
--            case when pvi.cd_moeda_cotacao<>1 and isnull(pvi.vl_moeda_cotacao,0)>0 
--            then 
--                 isnull(pvi.vl_moeda_cotacao,0)
--            else 
--                 dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda)
--                --1 
--            end )

           (case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )
            /
            case when ph.cd_moeda<>1 then 
              case when pvi.cd_moeda_cotacao<>1 and isnull(pvi.vl_moeda_cotacao,0)>0 
              then 
                isnull(pvi.vl_moeda_cotacao,0)
              else 
                dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda)
               --1 
              end
            else
               1 
            end )

           /

           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))) 

         else
           dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
         
--           (isnull(pc.vl_net_outra_moeda,0) * isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))) /
           (
           (case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )
            * 
            case when ph.cd_moeda<>1 then            
                isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))
            else
              1
            end
            ) 

            /


           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))) 

         end                                    as 'MargemContribuicao',  --(%) de comissão

         -- COMISSÃO

         case when isnull(p.cd_moeda,1)<> 1
         then

         cast((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
                dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms)) /
              isnull(cp.qt_parcela_condicao_pgto,1)) *

         -- Cálculo da Comissão
         -- Somar Produto + IPI ?

         ((dbo.fn_comissao_margem_contribuicao(

         -- NET Compra
--         (pc.vl_net_outra_moeda * isnull(pvi.vl_moeda_cotacao,1)) /
         (
         (case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )
            * 
            case when ph.cd_moeda<>1 then
              case when pvi.cd_moeda_cotacao<>1 and isnull(pvi.vl_moeda_cotacao,0)>0 
              then 
                isnull(pvi.vl_moeda_cotacao,0)
              else 
                dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda)
               --1 
              end
            else
              1
            end 
         )

         /

         -- NET Venda
         (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))))/100) as decimal(25,4)) 
         else

         cast((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
                dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms)) /
              isnull(cp.qt_parcela_condicao_pgto,1)) *

         -- Cálculo da Comissão
         -- Somar Produto + IPI ?
         ((dbo.fn_comissao_margem_contribuicao(

         -- NET Compra
--         (pc.vl_net_outra_moeda * isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1)) ) /
         (
         (case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )

            * 
            case when ph.cd_moeda<>1 then
                isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1)) 
            else
              1
            end
             ) 
            /
         -- NET Venda
         (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))))/100) as decimal(25,4)) 

         end                                    as 'Comissao',

         drp.cd_documento_receber               as 'DocumentoReceber',
         drp.cd_item_documento_receber          as 'ItemDocumento', 
         drp.vl_pagamento_documento             as 'Valor',
         (((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
         dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms))/
         isnull(cp.qt_parcela_condicao_pgto,1)) as 'BCComissao',
         nsi.pc_icms                            as 'AliqICMS',
         pv.dt_pedido_venda                     as 'DataPedido', 
--         pvi.vl_moeda_cotacao                   as 'CotacaoMoeda',
         dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda) as 'CotacaoMoeda',
         isnull(ph.vl_historico_produto,0)      as vl_historico_produto,
         ph.dt_historico_produto,
         isnull(mh.nm_moeda,'')                 as nm_moeda_historico,
         ns.vl_ipi,
         isnull(cp.qt_parcela_condicao_pgto,1)  as qt_parcela_condicao_pgto

--select * from produto_historico
  into
    #CalculoAuxiliar

  From #TmpComissao_Documentos_Pagos a                 with (nolock)  
       inner join      Nota_Saida_Item nsi             with (nolock) on nsi.cd_nota_saida              = a.cd_nota_saida
       Left Outer Join Nota_Saida ns                   with (nolock) on ns.cd_nota_saida               = nsi.cd_nota_saida
       Left Outer Join Condicao_Pagamento cp           with (nolock) on cp.cd_condicao_pagamento       = ns.cd_condicao_pagamento
       Left Outer Join Unidade_Medida un               with (nolock) on (nsi.cd_unidade_medida         = un.cd_unidade_medida)
       Left Outer Join Pedido_Venda pv                 with (nolock) on (nsi.cd_pedido_venda           = pv.cd_pedido_venda)
       Left Outer Join Pedido_Venda_Item pvi           with (nolock) on (nsi.cd_pedido_venda           = pvi.cd_pedido_venda and
                                                                         nsi.cd_item_pedido_venda      = pvi.cd_item_pedido_venda)
       Left Outer Join Moeda mo                        with (nolock) on (nsi.cd_moeda_cotacao          = mo.cd_moeda)
       Left Outer Join Produto_Custo pc                with (nolock) on (pc.cd_produto                 = pvi.cd_produto)
       Left Outer Join Documento_Receber_Pagamento drp with (nolock) on (drp.cd_documento_receber      = a.cd_documento_receber and
                                                                         drp.cd_item_documento_receber = a.cd_item_documento_receber)
       left outer join Produto p                       with (nolock) on p.cd_produto                   = nsi.cd_produto


       left outer join Produto_Historico ph            with (nolock) on ph.cd_produto                  = nsi.cd_produto and
                                                                        ph.dt_historico_produto        = @dt_final      and
                                                                        isnull(ph.ic_tipo_historico_produto,'C')='C'    and
                                                                        isnull(ph.cd_moeda,1)         <> 1 
       left outer join Moeda mh                        with (nolock) on mh.cd_moeda                    = ph.cd_moeda   
--select * from produto_historico

     --Mostra tabela auxiliar
  
--      select * from #CalculoAuxiliar
--      order by
--      notafiscal,
--      itemNota


     --Monta a Tabela Auxiliar de Cálculo
     --select * from comissao_pedido_venda
    
     declare @cd_comissao_pedido int

     select top 1 
        @cd_comissao_pedido = isnull(cd_comissao_pedido,0)
     from
       comissao_pedido_venda with (nolock) 
     order by
       cd_comissao_pedido desc

     if isnull(@cd_comissao_pedido,0)=0
        set @cd_comissao_pedido = 0
  
     select
       0                                     as cd_comissao_pedido,
       @cd_usuario                           as cd_usuario,
       getdate()                             as dt_usuario,
       @dt_final                             as dt_base_calculo_comissao,
       @dt_inicial                           as dt_inicial_calculo,
       @dt_final                             as dt_final_calculo,
       Pedido                                as cd_pedido_venda,
       ItemPedido                            as cd_item_pedido_venda,
       BCComissao                            as vl_base_calculo_comissao,
       MargemContribuicao                    as pc_calculo_comissao,
       cast('' as varchar(40))               as nm_obs_calculo_comissao,
       'N'                                   as ic_manutencao_calculo,
       NotaFiscal                            as cd_nota_saida,
       ItemNota                              as cd_item_nota_saida,
       identity(int,1,1)                     as cd_controle,
       BCComissao * (MargemContribuicao/100) as vl_calculo_comissao,
       'N'                                   as ic_zera_calculo

     into
       #Comissao_Pedido_Venda

     from
       #CalculoAuxiliar
     
     update
       #Comissao_Pedido_Venda
     set
       cd_comissao_pedido = isnull(@cd_comissao_pedido,0) + cd_controle

--     select * from #Comissao_Pedido_Venda

     insert into
       Comissao_Pedido_Venda
     select
       *
     from
       #Comissao_Pedido_Venda
     
     drop table #comissao_pedido_venda


  End

--Carlos 04.01.2008
-- -----------------------------------------------------
-- Else If @ic_parametro = 2     -- Filtra o vendedor
-- -----------------------------------------------------
--   Begin
-- 
--     select
--       drp.cd_documento_receber          as 'DocumentoReceber',
--       drp.cd_item_documento_receber     as 'ItemDocumento', 
--       d.cd_identificacao		as 'Documento',
--       d.dt_emissao_documento            as 'Emissao',
--       d.dt_vencimento_documento 	as 'Vencimento',
--       drp.dt_pagamento_documento        as 'Pagamento',
--       drp.vl_pagamento_documento        as 'Valor',
--       drp.vl_pagamento_documento - 
--       isnull(drp.vl_juros_pagamento,0) -
--       isnull(drp.vl_despesa_bancaria,0) -
--       isnull(drp.vl_credito_pendente,0) -
--       isnull(drp.vl_reembolso_documento,0) +
--       isnull(drp.vl_desconto_documento,0) +
--       isnull(drp.vl_abatimento_documento,0) as 'Valor_Principal',
--       dr.vl_saldo_documento	            as 'Saldo',
--       drp.vl_juros_pagamento	            as 'Juros',
--       drp.vl_desconto_documento	            as 'Desconto',
--       drp.vl_abatimento_documento           as 'Abatimento',
--       c.nm_fantasia_cliente                 as 'Fantasia',
--       v.nm_fantasia_vendedor                as 'Vendedor',
--       IsNull(v.cd_vendedor,0)               as 'CodigoVendedor',
--       p.nm_portador                         as 'Portador',
--       drp.nm_obs_documento                  as 'Historico',
--       tl.nm_tipo_liquidacao                 as 'Liquidacao',
--       b.nm_banco			    as 'Banco',
--       cab.nm_conta_banco		    as 'Conta',
--       ns.cd_nota_saida                      as 'NumeroNota',
--       ns.vl_total                           as 'ValorNota',
--       ns.dt_nota_saida                      as 'EmissaoNota',
--       cp.sg_condicao_pagamento              as 'CondicaoPagamento',
--       d.cd_pedido_venda                     as 'PedidoVenda'
-- 
--     Into
--       #TmpComissaoDocumentosPagos
--     from
--       Documento_Receber_Pagamento drp         with (nolock) 
--       inner join Documento_Receber d          with (nolock) on (drp.cd_documento_receber = d.cd_documento_receber)
--       left outer join Cliente	c             with (nolock) on (d.cd_cliente = c.cd_cliente) 
--       left outer join Vendedor v              with (nolock) on (v.cd_vendedor = d.cd_vendedor)
--       left outer join Portador p              with (nolock) on (p.cd_portador = d.cd_portador)
--       left outer join Tipo_Liquidacao tl      with (nolock) on (drp.cd_tipo_liquidacao = tl.cd_tipo_liquidacao)
--       left outer join Banco b                 with (nolock) on (drp.cd_banco = b.cd_banco)
--       left outer join Conta_Agencia_Banco cab with (nolock) on (drp.cd_banco = cab.cd_banco and drp.cd_conta_banco = cab.cd_conta_banco)
--       left outer join Documento_Receber	dr    with (nolock) on (drp.cd_documento_receber = dr.cd_documento_receber)
--       left outer join Nota_Saida ns           with (nolock) on (ns.cd_nota_saida = dr.cd_nota_saida)
--       left outer join Condicao_Pagamento cp   with (nolock) on (cp.cd_condicao_pagamento = ns.cd_condicao_pagamento)
--     where
--       (drp.dt_pagamento_documento between @dt_inicial and @dt_final) and
--       ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final )) and
--       ((d.dt_devolucao_documento is null)    or (d.dt_devolucao_documento    > @dt_final )) and
--       (v.cd_vendedor = @cd_vendedor)
--     order by
--       v.nm_fantasia_vendedor,
--       drp.dt_pagamento_documento
-- 
--     Select *
--     From #TmpComissaoDocumentosPagos
--     Order By Vendedor, Fantasia, NumeroNota
-- 
--  End

-------------------------------------------------------------------------------
else if @ic_parametro = 3                                       --  Filtra a NF
-------------------------------------------------------------------------------
begin

  Select 
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,

         --nsi.cd_nota_saida                      as 'NotaFiscal',

      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                                   as 'NotaFiscal',

         nsi.cd_item_nota_saida                 as 'ItemNota',
         IsNull(nsi.cd_pedido_venda,0)          as 'Pedido',
         nsi.cd_item_pedido_venda               as 'ItemPedido',
         nsi.cd_produto                         as 'ChaveProduto', 
         dbo.fn_mascara_produto(nsi.cd_produto) as 'CodigoProduto',
         nsi.nm_fantasia_produto                as 'FantasiaProduto',
         nsi.nm_produto_item_nota               as 'DescricaoProduto',
         IsNull(nsi.qt_item_nota_saida,0)       as 'QuantidadeItem',
         IsNull(nsi.vl_unitario_item_nota,0)    as 'ValorUnitario',
         un.sg_unidade_medida                   as 'UN',
         IsNull(nsi.vl_total_item,0)            as 'ValorTotal',
         IsNull(mo.sg_moeda,'')                 as 'Moeda',

         case when isnull(p.cd_moeda,1)<> 1
         then
            (IsNull(nsi.vl_total_item,0)        * IsNull(pvi.vl_moeda_cotacao,0))   
         else
            (IsNull(nsi.vl_total_item,0)        / isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),nsi.vl_moeda_cotacao))   

         end                               as 'ValorTotalMoeda',


         case when isnull(p.cd_moeda,1)<> 1
         then
            (IsNull(pv.vl_total_pedido_venda,0) * IsNull(pv.vl_indice_pedido_venda,1)) 
         else
            (IsNull(pv.vl_total_pedido_venda,0) / isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))) 

         end                                as 'TotalPedidoMoeda',

         --select * from pedido_venda

         -- Cálculo da Margem de Contribuição

         -- MARGEM DE CONTRIBUIÇÃO
         
         case when isnull(pv.pc_comissao_especifico,0)>0 then
            pv.pc_comissao_especifico
         else   
           case when isnull(cpv.ic_manutencao_calculo,'N')='S' and ( isnull(cpv.pc_calculo_comissao,0)<>0 or isnull(cpv.ic_zera_calculo,'N')='S' ) 
           then
             isnull(cpv.pc_calculo_comissao,0)
           else
             case when isnull(p.cd_moeda,1)<> 1
               then

               dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
--Antes         
--           (isnull(pc.vl_net_outra_moeda,0) / isnull(pvi.vl_moeda_cotacao,0) ) /

           (
           (case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )

            *
            case when ph.cd_moeda<>1 then isnull(pvi.vl_moeda_cotacao,0) else 1 end ) 

            /

             -- NET Venda
             (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))) 

           else
             dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
         
--           (isnull(pc.vl_net_outra_moeda,0) * isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))) /
           (
           (case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )
            * 
            case when ph.cd_moeda<> 1 then 
              isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))
            else 
             1
            end 
           ) /


           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))) 

           end

          end 

         end                                          as 'MargemContribuicao',  --(%) de comissão

         -- COMISSÃO

         case when isnull(pv.pc_comissao_especifico,0)>0 then
            (pv.pc_comissao_especifico/100) * IsNull(nsi.vl_total_item,0)
         else
                
           case when isnull(cpv.ic_manutencao_calculo,'N')='S' and ( isnull(cpv.vl_calculo_comissao,0)<>0 or isnull(cpv.ic_zera_calculo,'N')='S' )
           then
             isnull(cpv.vl_calculo_comissao,0)
           else
             case when isnull(p.cd_moeda,1)<> 1
             then

             cast((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
                  dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms)) /
                isnull(cp.qt_parcela_condicao_pgto,1)) *

           -- Cálculo da Comissão
           -- Somar Produto + IPI ?

           ((dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
--         (pc.vl_net_outra_moeda * isnull(pvi.vl_moeda_cotacao,1)) /
           ((case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end ) 

            * case when ph.cd_moeda<>1 then isnull(pvi.vl_moeda_cotacao,1) else 1 end 

            ) /

           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))))/100) as decimal(25,4)) 
           else

           cast((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
                  dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms)) /
                isnull(cp.qt_parcela_condicao_pgto,1)) *

           -- Cálculo da Comissão
           -- Somar Produto + IPI ?
           ((dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
  --         (pc.vl_net_outra_moeda * isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1)) ) /
             ((case when isnull(ph.vl_historico_produto,0)>0
            then
              isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )
        
            * case when ph.cd_moeda<>1 then
              isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))
              else 1 end

            ) /

           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))))/100) as decimal(25,4)) 

            end
           end
         end                                    as 'Comissao',

         drp.cd_documento_receber               as 'DocumentoReceber',

         drp.cd_item_documento_receber          as 'ItemDocumento', 

         drp.vl_pagamento_documento             as 'Valor',

         --Base de Cálculo-------------------------------------------------------------------------------------

         case when isnull(pv.pc_comissao_especifico,0)>0 then
            (pv.pc_comissao_especifico/100) * IsNull(nsi.vl_total_item,0)
         else
           case when isnull(cpv.ic_manutencao_calculo,'N')='S' and ( isnull(cpv.vl_base_calculo_comissao,0)<>0 or isnull(cpv.ic_zera_calculo,'N')='S' ) 
           then
             isnull(cpv.vl_base_calculo_comissao,0)
           else
             (((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
             dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms))/
             isnull(cp.qt_parcela_condicao_pgto,1))
           end 
         end
                                                as 'BCComissao',

         nsi.pc_icms                            as 'AliqICMS',

         pv.dt_pedido_venda                     as 'DataPedido', 

--         pvi.vl_moeda_cotacao                   as 'CotacaoMoeda',

         dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda) as 'CotacaoMoeda',

         c.nm_fantasia_cliente,

         v.nm_fantasia_vendedor,
         isnull(ph.vl_historico_produto,0)      as vl_historico_produto,
         ph.dt_historico_produto,
         @dt_final                              as dt_final,
         isnull(mh.nm_moeda,'')                 as nm_moeda_historico,
         ns.vl_ipi,
         isnull(cp.qt_parcela_condicao_pgto,1)                as qt_parcela_condicao_pgto,
         dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms) as 'mkp1',
         cast( (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))/100 as decimal(25,4)) as 'NetVenda',
         p.cd_moeda

  
  From 
       Nota_Saida_Item nsi                             with (nolock) 
       Left Outer Join Nota_Saida ns                   with (nolock) on ns.cd_nota_saida                      = nsi.cd_nota_saida
       Left Outer Join Condicao_Pagamento cp           with (nolock) on cp.cd_condicao_pagamento              = ns.cd_condicao_pagamento
       Left Outer Join Unidade_Medida un               with (nolock) on (nsi.cd_unidade_medida                = un.cd_unidade_medida)
       Left Outer Join Pedido_Venda pv                 with (nolock) on (nsi.cd_pedido_venda                  = pv.cd_pedido_venda)
       Left Outer Join Pedido_Venda_Item pvi           with (nolock) on (nsi.cd_pedido_venda                  = pvi.cd_pedido_venda and
                                                                         nsi.cd_item_pedido_venda             = pvi.cd_item_pedido_venda)
       Left Outer Join Moeda mo                        with (nolock) on (nsi.cd_moeda_cotacao                 = mo.cd_moeda)
       Left Outer Join Produto_Custo pc                with (nolock) on (pc.cd_produto                        = pvi.cd_produto)
       Left Outer Join Documento_Receber_Pagamento drp with (nolock) on (drp.cd_documento_receber             = @cd_documento_receber and
                                                                        drp.cd_item_documento_receber         = @cd_item_documento)
       left outer join Produto p                       with (nolock) on p.cd_produto                          = nsi.cd_produto
       left outer join Cliente c                       with (nolock) on c.cd_cliente                          = ns.cd_cliente
       left outer join Vendedor v                      with (nolock) on v.cd_vendedor                         = ns.cd_vendedor

       left outer join Comissao_Pedido_Venda cpv       with (nolock) on cpv.cd_nota_saida                     = nsi.cd_nota_saida        and
                                                                        cpv.cd_item_nota_saida                = nsi.cd_item_nota_saida   and
                                                                        cpv.cd_pedido_venda                   = nsi.cd_pedido_venda      and
                                                                        cpv.cd_item_pedido_venda              = nsi.cd_item_pedido_venda and
                                                                        isnull(cpv.ic_manutencao_calculo,'N') = 'S'

       left outer join Produto_Historico ph            with (nolock) on ph.cd_produto                  = nsi.cd_produto and
                                                                        ph.dt_historico_produto        = @dt_final      and
                                                                        isnull(ph.ic_tipo_historico_produto,'C')='C'    and
                                                                        isnull(ph.cd_moeda,1)         <> 1 

       left outer join Moeda mh                        with (nolock) on mh.cd_moeda = ph.cd_moeda

  Where
     nsi.cd_nota_saida = @cd_nota_saida 

  order by
     nsi.cd_nota_saida,
     nsi.cd_item_nota_saida
     
end
-------------------------------------------------------------------------------
else if @ic_parametro = 4                                -- Filtro por Vendedor
-------------------------------------------------------------------------------
begin
  --PRINT
  --print @ic_parametro

  Select 
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,

         --nsi.cd_nota_saida                      as 'NotaFiscal',
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                                   as 'NotaFiscal',

         nsi.cd_item_nota_saida                 as 'ItemNota',
         IsNull(nsi.cd_pedido_venda,0)          as 'Pedido',
         nsi.cd_item_pedido_venda               as 'ItemPedido',
         nsi.cd_produto                         as 'ChaveProduto', 
         dbo.fn_mascara_produto(nsi.cd_produto) as 'CodigoProduto',
         nsi.nm_fantasia_produto                as 'FantasiaProduto',
         nsi.nm_produto_item_nota               as 'DescricaoProduto',
         IsNull(nsi.qt_item_nota_saida,0)       as 'QuantidadeItem',
         IsNull(nsi.vl_unitario_item_nota,0)    as 'ValorUnitario',
         un.sg_unidade_medida                   as 'UN',
         IsNull(nsi.vl_total_item,0)            as 'ValorTotal',
         IsNull(mo.sg_moeda,'')                 as 'Moeda',
         case when isnull(p.cd_moeda,1)<> 1
         then
            (IsNull(nsi.vl_total_item,0)        * IsNull(pvi.vl_moeda_cotacao,0))   
         else
            (IsNull(nsi.vl_total_item,0)        / isnull(dbo.fn_vl_moeda_periodo(2,ns.dt_nota_saida),nsi.vl_moeda_cotacao))   

         end                                    as 'ValorTotalMoeda',


         case when isnull(p.cd_moeda,1)<> 1
         then
            (IsNull(pv.vl_total_pedido_venda,0) * IsNull(pv.vl_indice_pedido_venda,1)) 
         else
            (IsNull(pv.vl_total_pedido_venda,0) / isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))) 

         end                                as 'TotalPedidoMoeda',

         -- Cálculo da Margem de Contribuição

         -- MARGEM DE CONTRIBUIÇÃO
         
         case when isnull(cpv.ic_manutencao_calculo,'N')='S' and ( isnull(cpv.pc_calculo_comissao,0)<>0 or isnull(cpv.ic_zera_calculo,'N')='S' ) 
         then
           isnull(cpv.pc_calculo_comissao,0)
         else
           case when isnull(p.cd_moeda,1)<> 1
             then

               dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
--Antes         
--           (isnull(pc.vl_net_outra_moeda,0) / isnull(pvi.vl_moeda_cotacao,0) ) /

            ((case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end ) 

            / 

            case when ph.cd_moeda<> 1 then isnull(pvi.vl_moeda_cotacao,0) else 1 end )

            /

             -- NET Venda
             (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))) 

           else
             dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
         
--           (isnull(pc.vl_net_outra_moeda,0) * isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))) /
           ((case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end ) 
           
            * case when ph.cd_moeda<>1 then
              isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1))
              else 1 end

            ) /

           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))) 

           end

         end                                           as 'MargemContribuicao',  --(%) de comissão

         -- COMISSÃO

         case when isnull(cpv.ic_manutencao_calculo,'N')='S' and ( isnull(cpv.vl_calculo_comissao,0)<>0 or isnull(cpv.ic_zera_calculo,'N')='S' ) 
         then
           isnull(cpv.vl_calculo_comissao,0)
         else
           case when isnull(p.cd_moeda,1)<> 1
           then

           cast((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
                  dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms)) /
                isnull(cp.qt_parcela_condicao_pgto,1)) *

           -- Cálculo da Comissão
           -- Somar Produto + IPI ?

           ((dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
--         (pc.vl_net_outra_moeda * isnull(pvi.vl_moeda_cotacao,1)) /
           ((case when isnull(ph.vl_historico_produto,0)>0
            then
             isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )

            * case when ph.cd_moeda<>1 then isnull(pvi.vl_moeda_cotacao,1) else 1 end ) 
            /

           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))))/100) as decimal(25,4)) 
           else

           cast((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
                  dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms)) /
                isnull(cp.qt_parcela_condicao_pgto,1)) *

           -- Cálculo da Comissão
           -- Somar Produto + IPI ?
           ((dbo.fn_comissao_margem_contribuicao(

           -- NET Compra
  --         (pc.vl_net_outra_moeda * isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1)) ) /
             ((case when isnull(ph.vl_historico_produto,0)>0
            then
              isnull(ph.vl_historico_produto,0)
            else
             isnull(pc.vl_custo_previsto_produto,0)
            end )
            * case when ph.cd_moeda<>1 then 
               isnull(dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda),IsNull(pvi.vl_moeda_cotacao,1)) 
              else 1 end

            ) /

           -- NET Venda
           (pvi.vl_unitario_item_pedido * dbo.fn_indice_markup_icms(@cd_markup,nsi.pc_icms))))/100) as decimal(25,4)) 

           end

         end                                    as 'Comissao',

         drp.cd_documento_receber               as 'DocumentoReceber',

         drp.cd_item_documento_receber          as 'ItemDocumento', 

         drp.vl_pagamento_documento             as 'Valor',

         --Base de Cálculo
         --select * from comissao_pedido_venda

         case when isnull(cpv.ic_manutencao_calculo,'N')='S' and ( isnull(cpv.vl_base_calculo_comissao,0)<>0 or isnull(cpv.ic_zera_calculo,'N')='S' ) 
         then
           isnull(cpv.vl_base_calculo_comissao,0)
         else
           (((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) *
           dbo.fn_indice_markup_icms(@cd_markup_bc,nsi.pc_icms))/
           isnull(cp.qt_parcela_condicao_pgto,1))
         end
                                                as 'BCComissao',

         nsi.pc_icms                            as 'AliqICMS',

         pv.dt_pedido_venda                     as 'DataPedido', 

--         pvi.vl_moeda_cotacao                   as 'CotacaoMoeda',
         dbo.fn_vl_moeda_periodo(2,pv.dt_pedido_venda) as 'CotacaoMoeda',

         c.nm_fantasia_cliente,

         v.nm_fantasia_vendedor,
         isnull(ph.vl_historico_produto,0)      as vl_historico_produto,
         dt_historico_produto,
         isnull(mh.nm_moeda,'')                 as nm_moeda_historico,
         ns.vl_ipi      


  From 
      Documento_Receber_Pagamento drp         with (nolock) 
      inner join Documento_Receber d          with (nolock) on (drp.cd_documento_receber = d.cd_documento_receber)
      left outer join Cliente	c             with (nolock) on (d.cd_cliente             = c.cd_cliente) 
      left outer join Vendedor v              with (nolock) on (v.cd_vendedor            = d.cd_vendedor)
      left outer join Tipo_Liquidacao tl      with (nolock) on (drp.cd_tipo_liquidacao   = tl.cd_tipo_liquidacao)
      left outer join Banco b                 with (nolock) on (drp.cd_banco             = b.cd_banco)
      left outer join Conta_Agencia_Banco cab with (nolock) on (drp.cd_banco             = cab.cd_banco and drp.cd_conta_banco = cab.cd_conta_banco)
      left outer join Documento_Receber	dr    with (nolock) on (drp.cd_documento_receber = dr.cd_documento_receber)
      left outer join Nota_Saida ns           with (nolock) on (ns.cd_nota_saida         = dr.cd_nota_saida)
      left outer join Condicao_Pagamento cp   with (nolock) on (cp.cd_condicao_pagamento = ns.cd_condicao_pagamento)
      inner join Nota_Saida_Item nsi                  with (nolock) on nsi.cd_nota_saida                     = ns.cd_nota_saida 
      Left Outer Join Pedido_Venda pv                 with (nolock) on (nsi.cd_pedido_venda                  = pv.cd_pedido_venda)
      Left Outer Join Pedido_Venda_Item pvi           with (nolock) on (nsi.cd_pedido_venda                  = pvi.cd_pedido_venda and
                                                                         nsi.cd_item_pedido_venda             = pvi.cd_item_pedido_venda)
      Left Outer Join Moeda mo                        with (nolock) on (nsi.cd_moeda_cotacao                 = mo.cd_moeda)
      Left Outer Join Produto_Custo pc                with (nolock) on (pc.cd_produto                        = pvi.cd_produto)
      left outer join Produto p                       with (nolock) on p.cd_produto                          = nsi.cd_produto
      left outer join Unidade_Medida un               with (nolock) on un.cd_unidade_medida                  = p.cd_unidade_medida

      left outer join Comissao_Pedido_Venda cpv       with (nolock) on cpv.cd_nota_saida                     = nsi.cd_nota_saida        and
                                                                       cpv.cd_item_nota_saida                = nsi.cd_item_nota_saida   and
                                                                       cpv.cd_pedido_venda                   = nsi.cd_pedido_venda      and
                                                                       cpv.cd_item_pedido_venda              = nsi.cd_item_pedido_venda and
                                                                       isnull(cpv.ic_manutencao_calculo,'N') = 'S'

       left outer join Produto_Historico ph            with (nolock) on ph.cd_produto                  = nsi.cd_produto and
                                                                        ph.dt_historico_produto        = @dt_final      and
                                                                        isnull(ph.ic_tipo_historico_produto,'C')='C'    and
                                                                        isnull(ph.cd_moeda,1)         <> 1 

       left outer join Moeda mh                       with (nolock)   on mh.cd_moeda = ph.cd_moeda

  Where
      (drp.dt_pagamento_documento between @dt_inicial and @dt_final) and
      ((d.dt_cancelamento_documento is null) or (d.dt_cancelamento_documento > @dt_final )) and
      ((d.dt_devolucao_documento    is null) or (d.dt_devolucao_documento    > @dt_final )) and
      ( d.cd_vendedor = case when @cd_vendedor = 0 then d.cd_vendedor else @cd_vendedor end )

  order by
     nsi.cd_nota_saida,
     nsi.cd_item_nota_saida
     

end

