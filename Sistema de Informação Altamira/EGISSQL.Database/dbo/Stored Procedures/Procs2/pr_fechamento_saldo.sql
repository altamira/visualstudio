

/****** Object:  Stored Procedure dbo.pr_fechamento_saldo    Script Date: 13/12/2002 15:08:31 ******/

CREATE  PROCEDURE pr_fechamento_saldo
@ic_parametro     int, 
@dt_inicial       datetime,
@dt_final         datetime,        
@cd_produto       int,
@cd_grupo_produto int

AS

declare
@data as datetime,
@ano as char(4),
@mes as char(2)

Set @ano = (Select year(getdate()))
Set @mes = (Select month(getdate())+1)
  if len(@mes) < 2 
    set @mes = '0' + @mes
Set @data =  @ano + '-' + @mes+ '-01'
set @data = EGISSql.dbo.fn_dia_util(@data,'S','U')

-----------------------------------------------------------------
--Verificando se o mês ja foi fechado
-----------------------------------------------------------------
if exists
  (select dt_produto_fechamento from produto_fechamento
   where dt_produto_fechamento between @dt_inicial and @dt_final)
     print('Atenção, fechamento referente a esse período já efetuado')
else

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Recomposição de Saldos para Grupo Padrão
-------------------------------------------------------------------------------
  begin
-----------------------------------------------------------------
--Deletando todas as reservas dos pedidos que já foram faturados
-----------------------------------------------------------------
    delete from Movimento_Estoque
    where 
     cd_movimento_estoque in
    (select me.cd_movimento_estoque from Movimento_Estoque me
    left outer join Pedido_Venda_Item pvi on
      (pvi.cd_pedido_venda=me.cd_documento_movimento) and 
      (pvi.cd_item_pedido_venda=me.cd_item_documento)
    where 
      me.dt_movimento_estoque between @dt_inicial and @dt_final and
      me.cd_tipo_movimento_estoque=2 and
      pvi.qt_saldo_pedido_venda=0)

-----------------------------------------------------------------
--Reserva todos os pedidos em aberto com a data do primeiro dia útil do próximo
--mês, conforme a agenda de dias últeis
-----------------------------------------------------------------
    update Pedido_Venda_Item
    set dt_item_pedido_venda=@data
    where 
      dt_item_pedido_venda between @dt_inicial and @dt_final and
      qt_saldo_pedido_venda>0 and
      ic_reserva_item_pedido='S'

/*  declare cComposicao_Pedido_Venda_Item cursor for
  select 
    cd_item_pedido_venda 

  from Pedido_Venda_Item
     where
       dt_item_pedido_venda between @dt_inicial and @dt_final and
       qt_saldo_pedido_venda>0) and
       ic_reserva_item_pedido='S')

     print('Atençãoo, fechamento referente a esse per¡odo j  efetuado')*/

  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Recomposição de Saldos para Grupo Individual
-------------------------------------------------------------------------------
  begin
    --Deletando todas as reservas dos pedidos que já foram faturados
    delete from Movimento_Estoque
    where 
     cd_movimento_estoque in
    (select me.cd_movimento_estoque from Movimento_Estoque me
    left outer join Pedido_Venda_Item pvi on
      (pvi.cd_pedido_venda=me.cd_documento_movimento) and 
      (pvi.cd_item_pedido_venda=me.cd_item_documento)
    where 
      me.dt_movimento_estoque between @dt_inicial and @dt_final and
      me.cd_tipo_movimento_estoque=2 and
      pvi.qt_saldo_pedido_venda=0 and
      pvi.cd_grupo_produto=@cd_grupo_produto)

-----------------------------------------------------------------
--Reserva todos os pedidos em aberto com a data do primeiro dia útil do próximo
--mês, conforme a agenda de dias últeis
-----------------------------------------------------------------
    update Pedido_Venda_Item
    set dt_item_pedido_venda=@data
    where 
      dt_item_pedido_venda between @dt_inicial and @dt_final and
      qt_saldo_pedido_venda>0 and
      ic_reserva_item_pedido='S'and
      cd_grupo_produto=@cd_grupo_produto
  end




