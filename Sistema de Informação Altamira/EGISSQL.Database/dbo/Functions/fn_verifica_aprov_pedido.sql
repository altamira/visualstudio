
CREATE FUNCTION fn_verifica_aprov_pedido
(@cd_pedido_compra int)               -- Pedido de Compra
RETURNS char(1)                         -- Está ou não aprovado.

AS
BEGIN

  declare @ic_liberado_comprador char(1)
  declare @ic_aprovado char(1)

  set @ic_liberado_comprador = ( select IsNull(ic_liberado_comprador,'N') 
                                 from Parametro_Suprimento
                                 where cd_empresa = dbo.fn_empresa())

  -- criar a tabela temporária na memória
  declare @tmpPedidoCompra table 
  ( cd_tipo_aprovacao int,
    ic_aprov_comprador_pedido char(1),
    Aprovado char(1) )

insert into @tmpPedidoCompra
select distinct
  da.cd_tipo_aprovacao,
  IsNull(pc.ic_aprov_comprador_pedido,'N') as 'ic_aprov_comprador_pedido',
  case when ((ta.ic_teto_tipo_aprovacao='S') and
             ((pc.vl_total_pedido_ipi)<=
              (select vl_pedido_compra_empresa from Parametro_suprimento where cd_empresa = dbo.fn_empresa()))) then
    'S'
 -----------------------------------------------------
  -- ESSE TRECHO FOI INSERIDO POR ELIAS EM 27/09/2005
  -----------------------------------------------------
  when exists ( select x.cd_pedido_compra
                from Pedido_Compra_Aprovacao x, Tipo_Aprovacao ta
                where x.cd_pedido_compra = pc.cd_pedido_compra and
                      x.cd_tipo_aprovacao = ta.cd_tipo_aprovacao and
                      ta.ic_auto_tipo_aprovacao = 'S') then 'S'

  -----------------------------------------------------
  -- FIM
  -----------------------------------------------------


  when exists ( select x.cd_pedido_compra 
                from Pedido_Compra_Aprovacao x
                where x.cd_pedido_compra = pc.cd_pedido_compra and
                x.cd_tipo_aprovacao = da.cd_tipo_aprovacao) then 'S'
  else 'N' end as 'Aprovado'
    
from  Departamento_Aprovacao da
left outer join Pedido_Compra pc
on da.cd_departamento = pc.cd_departamento
left outer join Tipo_Aprovacao ta on
ta.cd_tipo_aprovacao = da.cd_tipo_aprovacao
where  pc.cd_pedido_compra = @cd_pedido_compra

  set @ic_aprovado =  'S'

  if exists ( select 'x' from @tmpPedidoCOmpra where Aprovado = 'N' )
    set @ic_aprovado =  'N'
  else if (@ic_liberado_comprador = 'S') and exists
          ( select 'x' from @tmpPedidoCOmpra where ic_aprov_comprador_pedido = 'N' )
    set @ic_aprovado =  'N'

  Return @ic_aprovado
end
