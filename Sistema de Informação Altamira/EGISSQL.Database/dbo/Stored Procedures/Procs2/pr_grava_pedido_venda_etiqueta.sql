
-------------------------------------------------------------------------------
--sp_helptext pr_grava_pedido_venda_etiqueta
-------------------------------------------------------------------------------
--pr_grava_pedido_venda_etiqueta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Grava a Etiqueta do Pedido de Venda
--Data             : 18.Agosto.2010
--Alteração        : 
-- 27.10.2010 - Finalização de Novos Campos - Carlos Fernandes
--
------------------------------------------------------------------------------
create procedure pr_grava_pedido_venda_etiqueta
@cd_pedido_venda      int         = 0,
@cd_item_pedido_venda int         = 0,
@qt_item_etiqueta     float       = 0,
@cd_usuario           int         = 0,
@nm_obs_etiqueta      varchar(50) = '',
@ic_parametro         int         = 0

as


declare @cd_ordem_etiqueta int

--select * from pedido_venda_item_etiqueta

if @ic_parametro = 1

begin

select
  @cd_ordem_etiqueta =  isnull(

  ( select 
      isnull( max(cd_ordem_etiqueta),0) 
   from
     pedido_venda_item_etiqueta
   where
     cd_pedido_venda      = @cd_pedido_venda      and
     cd_item_pedido_venda = @cd_item_pedido_venda  ),0)


set @cd_ordem_etiqueta = @cd_ordem_etiqueta + 1

--pedido_venda_item_etiqueta

select
  @cd_pedido_venda         as cd_pedido_venda,
  @cd_item_pedido_venda    as cd_item_pedido_venda,
  @qt_item_etiqueta        as qt_item_etiqueta,
  0.00                     as qt_peso_liquido,
  0.00                     as qt_peso_bruto,
  @cd_usuario              as cd_usuario_embalagem,
  getdate()                as dt_etiqueta,
  0.00                     as qt_numero,
  0.00                     as qt_volume,
  --cast('' as varchar)      as nm_obs_etiqueta,
  @nm_obs_etiqueta         as nm_obs_etiqueta,
  @cd_usuario              as cd_usuario,
  getdate()                as dt_usuario,
  @cd_ordem_etiqueta       as cd_ordem_etiqueta

  

into
  #pedido_venda_item_etiqueta

delete from
  pedido_venda_item_etiqueta
where
  cd_pedido_venda      = @cd_pedido_venda      and
  cd_item_pedido_venda = @cd_item_pedido_venda 


 insert into
   pedido_venda_item_etiqueta
 select
   *
 from
   #pedido_venda_item_etiqueta

 drop table #pedido_venda_item_etiqueta

 update 
   pedido_venda
 set
   ic_etiq_emb_pedido_venda = 'S'
 where
   cd_pedido_venda = @cd_pedido_venda


end

--Deleta o Item da Tabela Selecionada

if @ic_parametro = 0
begin

  delete from
    pedido_venda_item_etiqueta
  where
    cd_pedido_venda      = @cd_pedido_venda      and
    cd_item_pedido_venda = @cd_item_pedido_venda 


  update 
    pedido_venda
  set
    ic_etiq_emb_pedido_venda = 'N'
  where
    cd_pedido_venda = @cd_pedido_venda

end



