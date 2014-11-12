
-------------------------------------------------------------------------------
--sp_helptext pr_gera_invoice_embarque_importacao
-------------------------------------------------------------------------------
--pr_gera_invoice_embarque_importacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Geração da Invoice Automaticamente a Partir do Embarque
--
--
--Data             : 20.02.2009
--Alteração        : 01.03.2009 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_gera_invoice_embarque_importacao
@cd_embarque_importacao int      = 0,
@dt_invoice             datetime = null,
@cd_usuario             int      = 0,
@cd_pedido_importacao   int      = 0

as

if @dt_invoice is null
begin
  set @dt_invoice = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

--Verificar o número do Embarque

--select * from embarque_importacao

if @cd_embarque_importacao>0 
begin 

  declare @cd_invoice int
  declare @Tabela     varchar(80)

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Invoice' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_invoice', @codigo = @cd_invoice output
	
  while exists(Select top 1 'x' from Invoice where cd_invoice = @cd_invoice)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_invoice', @codigo = @cd_invoice output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_invoice, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_invoice, 'D'

  print 'embarque'

  --select * from embarque_importacao
  --select * from pedido_importacao
  --invoice
  
  select
    p.cd_fornecedor,
    p.cd_importador,
    @cd_invoice            as cd_invoice,
    p.cd_tipo_frete,
    ei.nm_invoice_embarque as nm_invoice,
    @dt_invoice            as dt_invoice,
    ei.dt_embarque,
    ei.cd_porto_saida      as cd_porto_origem,
    ei.cd_porto_destino    as cd_porto_destino,
    ei.cd_condicao_pagamento,
    ei.cd_moeda,
    ei.vl_total_embarque   as vL_total_invoice,
    1                      as qt_total_volume,
   --select * from embarque_item
   ( select sum(i.qt_produto_embarque) from embarque_item i
     where
        i.cd_embarque = ei.cd_embarque
     group by
        i.cd_embarque  )        as qt_total_item,
    
    ei.qt_peso_bruto_embarque   as qt_peso_bruto,
    ei.qt_peso_liquido_embarque as qt_peso_liquido,
    cast('' as varchar)         as ds_invoice_observacao,
    @cd_usuario                 as cd_usuario,
    getdate()                   as dt_usuario,
    ei.cd_termo_comercial,
    1                            as cd_status_invoice,
--select * from status_invoice
   p.vl_taxa_cambio_fechamento   as vl_moeda,
   p.dt_moeda_ped_imp            as dt_moeda,
   ei.dt_previsao_embarque       as dt_chegada_empresa_prev,
   ei.dt_embarque                as dt_liberacao_prev,
   ei.dt_previsao_chegada        as dt_chegada_pais_prev,
   cast(null as datetime)        as dt_moeda_frete,
   0.00                          as vl_moeda_frete,
   ei.cd_moeda_frete,
   0.00                          as vl_embalagem_invoice,
   ei.vl_frete_embarque          as vl_total_frete,
   p.cd_tipo_importacao

--select * from embarque_importacao
--select * from tipo_importacao
--select cd_tipo_importacao,* from pedido_importacao

  into
    #Invoice
  from 
    Embarque_Importacao ei
    inner join Pedido_Importacao p on p.cd_pedido_importacao = ei.cd_pedido_importacao
  where
    ei.cd_embarque          = @cd_embarque_importacao and
    ei.cd_pedido_importacao = @cd_pedido_importacao 


  insert into
    #Invoice
  select
    *
  from
    Invoice  


  print 'item'

  --select * from embarque_importacao_item

  --Itens da Invoice

  --invoice_Item

  select

    @cd_invoice                  as cd_invoice,
    identity(int,1,1)            as cd_invoice_item,
    p.cd_fornecedor,
    p.cd_importador,
    ip.cd_produto,
    iei.qt_produto_embarque      as qt_invoice_item,
    iei.vl_produto_embarque      as vl_invoice_item,
    cast(null as float)          as pc_invoice_item_desconto,
    iei.qt_produto_embarque *
    iei.vl_produto_embarque      as vl_invoice_item_total,
    iei.qt_peso_bruto_embarque   as qt_peso_bruto,
    iei.qt_peso_liquido_embarque as qt_peso_liquido,
    iei.cd_pedido_importacao,
    iei.cd_item_ped_imp,
    @cd_usuario                  as cd_usuario,
    getdate()                    as dt_usuario,

    null                         as cd_origem_importacao,
    ip.nm_produto_pedido         as nm_produto_invoice,
    cast(null as varchar)        as nm_obs_invoice_item,
    null                         as sg_tipo_embalagem,
    null                         as cd_embalagem

  into
    #Invoice_Item
  from 
    Embarque_Importacao ei                  with (nolock) 
    inner join Embarque_Importacao_Item iei with (nolock) on iei.cd_embarque         = ei.cd_embarque
    inner join Pedido_Importacao p          with (nolock) on p.cd_pedido_importacao  = ei.cd_pedido_importacao
    inner join Pedido_Importacao_item ip    with (nolock) on ip.cd_pedido_importacao = iei.cd_pedido_importacao and
                                                             ip.cd_item_ped_imp      = iei.cd_item_ped_imp
--    inner join Produto prod                 with (nolock) on prod.cd_produto         = ip.cd_produto
  where
    ei.cd_embarque          = @cd_embarque_importacao and
    ei.cd_pedido_importacao = @cd_pedido_importacao 


  insert into invoice_item
   select * from #invoice_item
  

--select * from embarque_importacao_item
--select * from pedido_importacao_item
--select * from origem_importacao

  drop table #invoice
  drop table #invoice_item

end

