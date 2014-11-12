
CREATE VIEW vw_previsao_entrada_atendimento
------------------------------------------------------------------------------------
--sp_helptext vw_previsao_entrada_atendimento
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Reserva de produtos no Estoque
--Banco de Dados	: EGISSQL 
--Objetivo	        : Consulta da Previsão Geral de Entrada de Produto
--                        Somente 
--                        Pedido de Compra
--                        Pedido de Importação
--                        Ordem  de Produção
--Data                  : 06.11.2008
--Atualização           : 26.11.2008
--11.03.2009 - Filtro por Tipo de Pedido - Carlos Fernandes
-- 04.10.2009 - Ajustes diversos - Carlos Fernandes
------------------------------------------------------------------------------------
as
 
select
      p.cd_produto                       as 'CodigoProduto', 
      Case 
        When IsNull(pci.nm_fantasia_produto,'') <> '' 
          Then pci.nm_fantasia_produto
        Else p.nm_fantasia_produto
      End                                as 'Produto',
      Case 
        When IsNull(pci.nm_produto,'') <> '' 
          Then pci.nm_produto
        Else p.nm_produto 
      End                                 as 'NomeProduto',
      IsNull(pci.qt_item_pedido_compra,0) as 'Quantidade',

      --Quantidade Líquida se a empresa operacao com Alocação
      Isnull(pci.qt_item_pedido_compra,0) -
      case when isnull(pe.ic_alocacao_estoque_reserva,'N')='N' then
        0.00
      else
        isnull(( select sum(pvi.qt_atendimento)
        from pedido_venda_item pvi
        where
             pc.cd_pedido_compra       = pvi.cd_documento      and 
             pci.cd_item_pedido_compra = pvi.cd_item_documento and
             pci.cd_produto            = pvi.cd_produto        and
             pvi.dt_cancelamento_item is null                  and
             pvi.qt_saldo_pedido_venda > 0 
        ) ,0) 

      end                                        as 'QtdLiquida',

      pci.dt_entrega_item_ped_compr       as 'DataPrevisao',
      'PC'                                as 'Forma',
      IsNull(pc.cd_pedido_compra,0)       as 'Documento',
      IsNull(pci.cd_item_pedido_compra,0) as 'ItemDocumento',
      dc.nm_destino_compra                as 'Destino',
      Cast(Null as DateTime)              as 'DataInvoice',
      Cast(Null as DateTime)              as 'DataDI',
      Cast(pc.ds_pedido_compra as VarChar(8000)) as 'Observacao',
      ''                                         as Identificacao,
      pc.dt_pedido_compra                        as 'Emissao'
from 
    pedido_compra_item pci            with (nolock) 
    inner join pedido_compra pc       with (nolock) on (pc.cd_pedido_compra  = pci.cd_pedido_compra)
    inner join produto p              with (nolock) on (p.cd_produto         = pci.cd_produto)
    left outer join destino_compra dc with (nolock) on (dc.cd_destino_compra = pc.cd_destino_compra)
    left outer join parametro_estoque pe with (nolock) on pe.cd_empresa = dbo.fn_empresa()
Where 
     pci.dt_item_canc_ped_compra is null        and
     pci.dt_entrega_item_ped_compr is not null  and
     isnull(pci.qt_saldo_item_Ped_compra,0) > 0 and
     IsNull(p.cd_produto,0) <> 0                and 
     isnull(pci.cd_pedido_venda,0)=0            and

--select * from pedido_compra_item
--select * from atendimento_pedido_venda

     pci.cd_pedido_compra not in ( select cd_documento 
                                   from atendimento_pedido_venda with (nolock) 
                                   where
                                     cd_documento      = pci.cd_pedido_compra and 
                                     cd_item_documento = pci.cd_item_pedido_compra )     

union  

select
      p.cd_produto as 'CodigoProduto', 
      Case 
        When IsNull(pii.nm_fantasia_produto,'') <> '' 
          Then pii.nm_fantasia_produto
        Else p.nm_fantasia_produto
      End as 'Produto',
      Case 
        When IsNull(pii.nm_produto_pedido,'') <> '' 
          Then pii.nm_produto_pedido
        Else p.nm_produto 
      End as 'NomeProduto',
      IsNull(pii.qt_item_ped_imp,0) as 'Quantidade',

      --Quantidade Líquida se a empresa operacao com Alocação
      Isnull(pii.qt_item_ped_imp,0) -
      case when isnull(pe.ic_alocacao_estoque_reserva,'N')='N' then
        0.00
      else
        isnull(( select sum(pvi.qt_atendimento)
        from pedido_venda_item pvi
        where
             pii.cd_pedido_importacao = pvi.cd_documento      and 
             pii.cd_item_ped_imp      = pvi.cd_item_documento and
             pii.cd_produto           = pvi.cd_produto        and
             pvi.dt_cancelamento_item is null             and
             pvi.qt_saldo_pedido_venda > 0 

         ) ,0)

      end                                        as 'QtdLiquida',
--       Case 
-- 	When chfab.dt_chegada_fabrica is not null
-- 	 Then chfab.dt_chegada_fabrica
-- 	 Else
-- 	    Case
-- 	      When chemp.dt_chegada_empresa_prev is not null
-- 	      Then chemp.dt_chegada_empresa_prev
-- 	      Else pii.dt_entrega_ped_imp 
-- 	    End 
-- 	 End as 'DataPrevisao',

      --Data de Previsão
      
      case when ei.dt_chegada is not null then
         ei.dt_chegada
      else  
         case when ei.dt_previsao_chegada is not null then
            ei.dt_previsao_chegada
         else
           Case when chfab.dt_chegada_fabrica is not null
           then chfab.dt_chegada_fabrica
	   Else
	      Case When chemp.dt_chegada_empresa_prev is not null
	        Then chemp.dt_chegada_empresa_prev
	        Else pii.dt_entrega_ped_imp 
	      End 
           end
         end   
       End                              as 'DataPrevisao',


      'PI' as 'Forma',
      IsNull(pi.cd_pedido_importacao,0) as 'Documento',
      IsNull(pii.cd_item_ped_imp,0)     as 'ItemDocumento',
      dc.nm_destino_compra              as 'Destino',


      chemp.dt_chegada_empresa_prev as 'DataInvoice',

      chfab.dt_chegada_fabrica as 'DataDi',

      ltrim(rtrim(isnull(cast(pi.ds_pedido_importacao as varchar(8000)),'')))+ 
      ltrim(rtrim(isnull(cast(pi.ds_obs_ped_imp as varchar(8000)),''))) +
      ltrim(rtrim(isnull(cast(di.ds_observacao_di as varchar(8000)),''))) as 'Observacao',
      pi.cd_identificacao_pedido                                          as Identificacao,
      pi.dt_pedido_importacao                                             as 'Emissao'

from
     pedido_importacao_item pii      with (nolock) 
     inner join pedido_importacao pi with (nolock) on (pi.cd_pedido_importacao = pii.cd_pedido_importacao)
     left outer join (select dii.cd_item_ped_imp,
                             dii.cd_pedido_importacao,
                             max(di.dt_chegada_fabrica) as dt_chegada_fabrica
                      from di_item dii with (nolock) 
	              inner join di    with (nolock) on (di.cd_di = dii.cd_di)
                      group by dii.cd_item_ped_imp, dii.cd_pedido_importacao) chfab on chfab.cd_item_ped_imp = pii.cd_item_ped_imp and
                                             	                                       chfab.cd_pedido_importacao = pii.cd_pedido_importacao
     left outer join (select ii.cd_item_ped_imp,
                             ii.cd_pedido_importacao,
                             Max(i.dt_chegada_empresa_prev) as dt_chegada_empresa_prev
                      from invoice_item ii
	              inner join invoice i on (i.cd_invoice = ii.cd_invoice)
                      group by ii.cd_item_ped_imp, ii.cd_pedido_importacao) chemp on chemp.cd_item_ped_imp = pii.cd_item_ped_imp and
                                             	                                     chemp.cd_pedido_importacao = pii.cd_pedido_importacao

     inner join produto p                on (p.cd_produto = pii.cd_produto)
     left outer join destino_compra dc   on (dc.cd_destino_compra = pi.cd_destino_compra)
     left outer join di_item dii         on (pii.cd_pedido_importacao = dii.cd_pedido_importacao and
                                           pii.cd_item_ped_imp = dii.cd_item_ped_imp)
     left outer join di                  on (dii.cd_di = di.cd_di)
     left outer join nota_saida_item nsi on pii.cd_pedido_importacao = nsi.cd_pedido_importacao
                                            and pii.cd_item_ped_imp = nsi.cd_item_ped_imp
                                            and isnull(nsi.ic_movimento_estoque,'N') = 'N'
     left outer join tipo_pedido tp      on tp.cd_tipo_pedido = pi.cd_tipo_pedido
     left outer join embarque_importacao ei on ei.cd_pedido_importacao = pi.cd_pedido_importacao and
                                               ei.cd_embarque = 1
    left outer join parametro_estoque pe with (nolock) on pe.cd_empresa = dbo.fn_empresa()

where pii.dt_cancel_item_ped_imp is null and
      pii.qt_saldo_item_ped_imp + isnull(nsi.qt_item_nota_saida,0) > 0 and
      IsNull(p.cd_produto,0) <> 0        and
      isnull(pii.cd_pedido_venda,0)=0    and
--      pii.cd_pedido_importacao not in ( select cd_documento from atendimento_pedido_venda )     
      isnull(tp.ic_previsao_tipo_pedido,'S')='S' 

--select * from pedido_importacao_item

     and pii.cd_pedido_importacao not in ( select cd_documento 
                                       from atendimento_pedido_venda with (nolock) 
                                       where
                                         cd_documento      = pii.cd_pedido_importacao and 
                                         cd_item_documento = pii.cd_item_ped_imp      and
                                         cd_produto        = pii.cd_produto  )     

union

select 
      p.cd_produto                        as 'CodigoProduto', 
      p.nm_fantasia_produto               as 'Produto',
      p.nm_produto                        as 'NomeProduto',
      IsNull(pp.qt_planejada_processo,0)  as 'Quantidade',
      0.00                                as 'QtdLiquida',
      isnull(pp.dt_entrega_processo,pp.dt_processo) as 'DataPrevisao',
      'OP'                                as 'Forma',
      Cast(isnull(pp.cd_processo,0) as VarChar(40)) as 'Documento',
      '' as 'ItemDocumento',
      tp.nm_tipo_processo    as 'Destino',
      Cast(Null as DateTime) as 'DataInvoice',
      Cast(Null as DateTime) as 'DataDI',
      Cast(pp.ds_processo_fabrica as VarChar(8000)) as 'Observacao',
      '' as Identificacao,
      pp.dt_processo                                as 'Emissao'
from Processo_Producao pp             with (nolock) 
     left outer join produto p        with (nolock) on (p.cd_produto = pp.cd_produto)
     left outer join tipo_processo tp with (nolock) on (tp.cd_tipo_processo = pp.cd_tipo_processo)

where 
      pp.cd_status_processo not in (5,6) and
      pp.qt_planejada_processo > 0       and
      IsNull(p.cd_produto,0) <> 0        and 
      isnull(pp.cd_pedido_venda,0)=0     and
--      pp.cd_processo not in ( select cd_documento from atendimento_pedido_venda )     
--select * from processo_producao

     pp.cd_processo not in ( select cd_documento 
                                   from atendimento_pedido_venda with (nolock) 
                                   where
                                     cd_documento      = pp.cd_processo 
                                     --and cd_item_documento = pci.cd_item_pedido_compra
                                 )     


--select * from atendimento_pedido_venda

