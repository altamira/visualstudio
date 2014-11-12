
CREATE PROCEDURE pr_previsao_entrega_produto

@ic_previsao_entrega_atraso Char(1), 
@nm_fantasia_produto        VarChar(30),
@nm_fantasia_cliente        VarChar(15),
@cd_pedido_venda            Int,
@cd_pdcompra_pedido_venda   VarChar(40), 
@nm_fantasia_vendedor       VarChar(15),
@cd_usuario                 int = 0,
@cd_pedido_importacao       int = 0

AS


--select * from parametro_estoque


declare @Sql                         varchar(8000)
declare @ic_alocacao_estoque_reserva char(1) 

select
  @ic_alocacao_estoque_reserva = isnull(ic_alocacao_estoque_reserva,'N')  
from
  Parametro_Estoque with (nolock)
where
  cd_empresa = dbo.fn_empresa()


--select * from vw_previsao_entrega_produto

set @sql = ''

if @ic_alocacao_estoque_reserva = 'N'
begin

Set @Sql = ' select
               0 as cd_controle,
               Case 
                 When GetDate() > IsNull(vw.DataComercial, vw.DataPrevisao)
                   Then ''S''
                 Else ''N''
               End as ''FlagAtrasado'',
               Case 
                 When IsNull(vw.PedidoVenda,0) <> 0 
                   Then ''S''
                 Else ''N''
               End as ''FlagPedidoVenda'',
               Case 
                 When IsNull(vw.Documento,0) <> 0 and vw.Forma = ''PC''
                   Then ''S''
                 Else ''N''
               End as ''FlagCompraNacional'',
               Case 
                 When IsNull(vw.Documento,0) <> 0 and vw.Forma = ''OP''
                   Then ''S''
                 Else ''N''
               End as ''FlagProducao'',
               Case 
                 When IsNull(vw.Documento,0) <> 0 and vw.Forma = ''PI''
                   Then ''S''
                 Else ''N''
               End as ''FlagImportacao'',
               Case 
                 When ((vw.DataComercial is not null) and (vw.DataComercial < vw.DataPrevisao))
                   Then ''S''
                 Else ''N''
               End as ''FlagPrevisaEntregaAtraso'',
               Case 
                 When IsNull(vw.PedidoVenda,0) = 0
                   Then ''S''
                 Else ''N''
               End as ''FlagDestinoEstoque'',
               vw.Cliente, vw.PedidoVenda, vw.ItemPedidoVenda, vw.Produto, vw.NomeProduto, '+
               'vw.SaldoPedidoVenda, vw.Quantidade, vw.DataComercial, vw.DataPrevisao, vw.Forma, '+
               ' Case
                 When vw.Forma = ''PI''
                   Then Cast(vw.Documento as VarChar) + '' / '' + vw.Identificacao
                 Else Cast(vw.Documento as VarChar) 
               End as Documento,
               vw.ItemDocumento,
               vw.Destino,
               vw.PedidoCliente,
               vw.Vendedor,
               vw.Observacao, vw.Emissao, '         +

               ' case when isnull(epv.qt_estoque,0)>0 then '+QuoteName('Estoque','''')+
               ' else case when isnull(apv.cd_documento,0)>0 then '+QuoteName('Previsto','''')+
               ' else '+QuoteName('Não Atendido','''')+' end end as nm_atendimento, ' +
               ' pvi.vl_unitario_item_pedido, pvi.dt_reprog_item_pedido, '+
               ' pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido as vl_total_item_pedido, '+
               ' pvi.cd_moeda_cotacao, m.sg_moeda, pvi.dt_moeda_cotacao, pvi.vl_moeda_cotacao, '+
               ' ltrim(rtrim(c.cd_ddd)) '+QuoteName('-','''')+' ltrim(rtrim(c.cd_telefone)) as cd_telefone_cliente, '+
               ' cc.nm_contato_cliente '+

         --Forma de Atendimento----------------------------------------------------------------------------               
         --select * from vw_previsao_entrega_produto

         '  from vw_previsao_entrega_produto vw '+
         '  left outer join pedido_venda_item pvi on pvi.cd_pedido_venda = vw.PedidoVenda and pvi.cd_item_pedido_venda = vw.ItemPedidoVenda '+
         '  left outer join pedido_venda pv       on pv.cd_pedido_venda  = pvi.cd_pedido_venda '+
         '  left outer join moeda m               on m.cd_moeda          = pvi.cd_moeda_cotacao '+
         '  left outer join Cliente c             on c.cd_cliente        = pv.cd_cliente '+
         '             left outer join Cliente_Contato cc with (nolock) on cc.cd_cliente      = pv.cd_cliente and cc.cd_contato      = pv.cd_contato '+

    	 ' where '+
			  
         '   dbo.fn_vendedor_produto_internet('+ cast(@cd_usuario as varchar) + ', vw.CodigoProduto ) = ''S'' and
 			 dbo.fn_vendedor_pedido_internet('+ cast(@cd_usuario as varchar) + ', vw.PedidoVenda ) = ''S'' and
			 (('+ QuoteName(@ic_previsao_entrega_atraso,'''')+'=''N'') or
             ((vw.DataComercial is not null) and (vw.DataComercial < vw.DataPrevisao))) '

----------------------------------------------------------------------------------------
--Filtros
----------------------------------------------------------------------------------------

If @nm_fantasia_produto <> ''
  Set @Sql = @Sql + ' and Produto like ' + QuoteName(@nm_fantasia_produto + '%','''')

If @nm_fantasia_cliente <> ''
  Set @Sql = @Sql + ' and Cliente like ' + QuoteName(@nm_fantasia_Cliente + '%','''')


If @cd_pedido_venda <> 0
  Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda,'''')
--  Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda + '%','''')

If @cd_pdcompra_pedido_venda <> ''
  Set @Sql = @Sql + ' and PedidoCliente like ' + QuoteName(@cd_pdcompra_pedido_venda + '%','''')

IF @nm_fantasia_vendedor <> ''
  Set @Sql = @Sql + ' and Vendedor like ' + QuoteName(@nm_fantasia_vendedor + '%','''')

if @cd_pedido_importacao <> 0
   set @sql = @sql + 'and Forma = '+'''PI'''+' and Documento = '+QuoteName(@cd_pedido_importacao,'''')

end
else
begin

  set @sql = ''

   select 
               identity(int,1,1) as cd_controle,
               p.cd_produto,
               Case 
                 When GetDate() > IsNull(pvi.dt_entrega_vendas_pedido, apv.dt_atendimento)
                   Then 'S'
                 Else 'N'
               End as 'FlagAtrasado',
              Case 
                 When IsNull(pvi.cd_pedido_venda,0) <> 0 
                   Then 'S'
                 Else 'N'
               End as 'FlagPedidoVenda',
               Case 
                 When IsNull(apv.cd_documento,0) <> 0 and apv.nm_forma = 'PC'
                   Then 'S'
                 Else 'N'
               End as 'FlagCompraNacional', 
               Case 
                 When IsNull(apv.cd_documento,0) <> 0 and apv.nm_forma = 'OP'
                   Then 'S'
                 Else 'N'
               End as 'FlagProducao', 
               Case 
                 When IsNull(apv.cd_documento,0) <> 0 and apv.nm_forma = 'PI'
                   Then 'S'
                 Else 'N'
               End as 'FlagImportacao',
               Case 
                 When ((pvi.dt_entrega_vendas_pedido is not null) and (pvi.dt_entrega_vendas_pedido < apv.dt_atendimento))
                   Then 'S'
                 Else 'N'
               End as 'FlagPrevisaEntregaAtraso', 
               Case 
                 When IsNull(pvi.cd_pedido_Venda,0) = 0
                   Then 'S'
                 Else 'N'
               End as 'FlagDestinoEstoque', 
               c.nm_fantasia_cliente        as Cliente, 
               pvi.cd_pedido_venda          as PedidoVenda, 
               pvi.cd_item_pedido_venda     as ItemPedidoVenda, 
               isnull(pvi.nm_fantasia_produto,p.nm_fantasia_produto) as Produto, 
               isnull(pvi.nm_produto_pedido,p.nm_produto)            as NomeProduto, 
               pvi.qt_saldo_pedido_venda    as SaldoPedidoVenda, 
               pvi.qt_item_pedido_venda     as Quantidade, 
               pvi.dt_entrega_vendas_pedido as DataComercial, 
               apv.dt_atendimento           as DataPrevisao, 
               apv.nm_forma                 as Forma, 
               Case
                 When apv.nm_forma = 'PI'
                   Then Cast(apv.cd_documento as VarChar)
                 Else Cast(apv.cd_documento as VarChar) 
               End                          as Documento, 

                apv.cd_item_documento        as ItemDocumento, 
                pvi.cd_pdcompra_item_pedido  as PedidoCliente, 
                v.nm_fantasia_vendedor       as Vendedor, 
                ltrim(rtrim(isnull(cast(pvi.ds_produto_pedido_venda as varchar(8000)),''))) as Observacao, 
                pv.dt_pedido_venda           as Emissao, 

--                 case when isnull(epv.qt_estoque,0)>0        then 'Estoque'
--                 else 
--                   case when isnull(apv.cd_documento,0)>0    then 'Previsto'
--                 else 
--                   case when 
--                      isnull(pvi.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )>0
--                   then
--                     'Parcial'
--                   else
--                     'Não Atendido'
--                   end
--                 end
--                 end                            as nm_atendimento, 

         case when isnull(pv.ic_fechado_pedido,'N')<>'S'   
         then 
           'Pedido Não Fechado'
         else
           case when pvi.qt_saldo_pedido_venda = 0 
         then 
           'Faturado' 
         else
          case when isnull(epv.qt_estoque,0)>0        then 'Estoque'
          else 
            case when isnull(apv.cd_documento,0)>0    then 'Previsto'
            else 
            case when 
              isnull(pvi.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )>0
            then
              'Parcial'
            else
              'Não Atendido' end
         end
        end
       end
       end                           as nm_atendimento,


         case when isnull(pv.ic_fechado_pedido,'N')<>'S'   
         then 
           'Pedido Não Fechado'
         else
           case when pvi.qt_saldo_pedido_venda = 0 
         then 
           'Faturado' 
         else
          case when isnull(epv.qt_estoque,0)>0 and epv.qt_estoque=pvi.qt_saldo_pedido_venda           then 'Estoque'
          else 
            case when isnull(apv.cd_documento,0)>0 and apv.qt_atendimento=pvi.qt_saldo_pedido_venda   then 'Previsto'
            else 
            case when 
              isnull(pvi.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )>0
            then
              'Parcial'
            else
              case when  isnull(pvi.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )=0 
              then
                'Estoque/Previsto'
              else     
              'Não Atendido' end
            end
         end
        end
       end
       end                           as Destino,

--                 case when isnull(epv.qt_estoque,0)>0        then 'Estoque'
--                 else 
--                   case when isnull(apv.cd_documento,0)>0    then 'Previsto'
--                 else 
--                   case when 
--                      isnull(pvi.qt_saldo_pedido_venda,0) - ( isnull(epv.qt_estoque,0) + isnull(apv.qt_atendimento,0) )>0
--                   then
--                     'Parcial'
--                   else
--                     'Não Atendido'
--                   end
--                 end
--                 end                                         as Destino,

                pvi.vl_unitario_item_pedido,
                pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido as vl_total_item_pedido,
                pvi.cd_moeda_cotacao,
                m.sg_moeda,                
                pvi.dt_moeda_cotacao,
                pvi.vl_moeda_cotacao,
                isnull(pvi.dt_reprog_item_pedido,dt_entrega_vendas_pedido) as dt_reprog_item_pedido,
                '('+ltrim(rtrim(c.cd_ddd))+')-'+ltrim(rtrim(c.cd_telefone))     as cd_telefone_cliente,
                cc.nm_contato_cliente
                        

         --select * from cliente
         --select * from cliente_contato
         --Forma de Atendimento----------------------------------------------------------------------------               
         --select * from vw_previsao_entrega_produto
         --select * from pedido_venda_item
 
           into 
             #PrevisaoEntregaProduto

           from pedido_venda_item pvi         with (nolock) 
           left outer join pedido_venda pv    with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda 
           left outer join Cliente c          with (nolock) on c.cd_cliente       = pv.cd_cliente 
           left outer join Produto p          with (nolock) on p.cd_produto       = pvi.cd_produto 
           left outer join Vendedor v         with (nolock) on v.cd_vendedor      = pv.cd_vendedor 
           left outer join Moeda m            with (nolock) on m.cd_moeda         = pvi.cd_moeda_cotacao
           left outer join Cliente_Contato cc with (nolock) on cc.cd_cliente      = pv.cd_cliente and
                                                               cc.cd_contato      = pv.cd_contato
            --Atendimento

          left outer join atendimento_pedido_venda apv with (nolock) on apv.cd_produto             = pvi.cd_produto      and 
                                                                        apv.cd_pedido_venda        = pvi.cd_pedido_venda and 
                                                                        apv.cd_item_pedido_venda   = pvi.cd_item_pedido_venda 

           --Estoque

          left outer join estoque_pedido_venda epv     with (nolock) on epv.cd_produto             = pvi.cd_produto and
                                                                        epv.cd_pedido_venda        = pvi.cd_pedido_venda and
                                                                        epv.cd_item_pedido_venda   = pvi.cd_item_pedido_venda 

    	  where
             isnull(pvi.qt_saldo_pedido_venda,0)>0 and pvi.dt_cancelamento_item is null and 
             isnull(pv.ic_fechado_pedido,'N')='S' and 
             dbo.fn_vendedor_produto_internet(cast(@cd_usuario as varchar) , pvi.cd_produto      ) = 'S' and 
             dbo.fn_vendedor_pedido_internet( cast(@cd_usuario as varchar) , pvi.cd_pedido_venda ) = 'S' and 
             ((@ic_previsao_entrega_atraso = 'N') or ((pvi.dt_entrega_vendas_pedido is not null)))


set @sql = @sql + 'select * from #PrevisaoEntregaProduto where 1=1 '

----------------------------------------------------------------------------------------
--Filtros
----------------------------------------------------------------------------------------

If @nm_fantasia_produto <> ''
  Set @Sql = @Sql + ' and Produto like ' + QuoteName(@nm_fantasia_produto + '%','''')

If @nm_fantasia_cliente <> ''
  Set @Sql = @Sql + ' and Cliente like ' + QuoteName(@nm_fantasia_Cliente + '%','''')


If @cd_pedido_venda <> 0
  Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda,'''')
--  Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda + '%','''')

If @cd_pdcompra_pedido_venda <> ''
  Set @Sql = @Sql + ' and PedidoCliente like ' + QuoteName(@cd_pdcompra_pedido_venda + '%','''')

IF @nm_fantasia_vendedor <> ''
  Set @Sql = @Sql + ' and Vendedor like ' + QuoteName(@nm_fantasia_vendedor + '%','''')

if @cd_pedido_importacao <> 0
   set @sql = @sql + 'and Forma = '+'''PI'''+' and Documento = '+QuoteName(@cd_pedido_importacao,'''')



end

-- ----------------------------------------------------------------------------------------
-- --Filtros
-- ----------------------------------------------------------------------------------------
-- 
-- If @nm_fantasia_produto <> ''
--   Set @Sql = @Sql + ' and Produto like ' + QuoteName(@nm_fantasia_produto + '%','''')
-- 
-- If @nm_fantasia_cliente <> ''
--   Set @Sql = @Sql + ' and Cliente like ' + QuoteName(@nm_fantasia_Cliente + '%','''')
-- 
-- 
-- If @cd_pedido_venda <> 0
--   Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda,'''')
-- --  Set @Sql = @Sql + ' and PedidoVenda = ' + QuoteName(@cd_pedido_venda + '%','''')
-- 
-- If @cd_pdcompra_pedido_venda <> ''
--   Set @Sql = @Sql + ' and PedidoCliente like ' + QuoteName(@cd_pdcompra_pedido_venda + '%','''')
-- 
-- IF @nm_fantasia_vendedor <> ''
--   Set @Sql = @Sql + ' and Vendedor like ' + QuoteName(@nm_fantasia_vendedor + '%','''')
-- 
-- if @cd_pedido_importacao <> 0
--    set @sql = @sql + 'and Forma = '+'''PI'''+' and Documento = '+QuoteName(@cd_pedido_importacao,'''')
-- 

--print @sql

exec (@sql)

