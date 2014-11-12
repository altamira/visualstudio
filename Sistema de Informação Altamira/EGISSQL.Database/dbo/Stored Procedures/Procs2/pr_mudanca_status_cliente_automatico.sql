
-------------------------------------------------------------------------------
--pr_mudanca_status_cliente_automatico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 11.03.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_mudanca_status_cliente_automatico
--1 : Acerta o status dos clientes
--2 : Consulta
--3 : Modifica o status por data
--4 : Modifica o status por ano

@ic_parametro            int     = 0,
@cd_status_cliente       int     = 1,
@cd_status_cliente_atual int     = 0,
@cd_status_cliente_novo  int     = 0,
@dt_base                 datetime,
@qt_mes                  int     = 0,     ----@dt_ultima_venda         datetime,
@qt_ano                  int     = 0,
@ic_gera_historico       char(1) = 'N',
@cd_usuario              int     = 0

as


--Verifica se existe cliente sem status e coloca o status ativo

if @ic_parametro = 1
begin

  update
    Cliente
  set
    cd_status_cliente = @cd_status_cliente
  where
    isnull(cd_status_cliente,0) = 0 
end

else
begin     

  --Modifica o status do Cliente conforma a data da ultima compra

  set @dt_base = @dt_base - ( @qt_mes * 30 )

  --select * from pedido_venda

  --Gera uma tabela auxiliar com a data da última compra do cliente
 
  select
    cd_cliente,
    max(dt_pedido_venda)                 as dt_pedido_venda,
    sum(isnull(vl_total_pedido_venda,0)) as Total
  into #AuxUltimaCompra
  from
    pedido_venda
  where
    dt_cancelamento_pedido is null    
  group by
    cd_cliente

  if @ic_parametro = 2
  begin  
    select 
      a.*,
      c.nm_fantasia_cliente,
      c.cd_status_cliente,
      sc.nm_status_cliente,
      v.nm_fantasia_vendedor,
      Dias      = cast( @dt_base - a.dt_pedido_venda as int ),
      Base      = @dt_base,
      AnoCompra = year(a.dt_pedido_venda), 
      Ano       = @qt_ano
    from 
      #AuxUltimaCompra a
      left outer join cliente  c        on c.cd_cliente                = a.cd_cliente 
      left outer join vendedor v        on v.cd_vendedor               = c.cd_vendedor
      left outer join status_cliente sc on sc.cd_status_cliente        = c.cd_status_cliente
    where
       a.dt_pedido_venda <= @dt_base and
       isnull(c.cd_status_cliente,0) = (case when @cd_status_cliente_atual = 0 then isnull(c.cd_status_cliente,0) else @cd_status_cliente_atual end)
    order by 
       a.dt_pedido_venda desc, a.total desc
   end

  --Modifica o status por Data

end

