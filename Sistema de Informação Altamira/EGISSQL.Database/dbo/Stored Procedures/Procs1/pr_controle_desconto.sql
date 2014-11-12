CREATE   PROCEDURE pr_controle_desconto

-------------------------------------------------------------------------------
--pr_controle_desconto
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                           	   2004
-------------------------------------------------------------------------------
--Stored Procedure          : Microsoft SQL Server 2000
--Autor(es)                 : Daniel Carrasco Neto
--Banco de Dados            : Egissql
--Objetivo                  : Listar as Propostas com Desconto para
--                            Liberação
--Data                      : 01/04/2002
--Atualizado                : 11/07/2002 - Igor Gama
--                          : 10/05/2004 - Anderson Cunha
--                          : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                          : 14.06.2006 - Controle de Escala de (%) para Aprovação - Carlos Fernandes
--                          : 05.07.2006 - Acerto quando há escala para liberação 
--                          : 31.07.2006 - Cancelamento da Liberação Checar a Escala - Carlos Fernandes
-- 18.07.2008 - (%) de Desconto do Cadastro do Produto - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------
@ic_parametro    as int, --1 liberados, 2 não liberados, 3 Todos
@dt_inicial      as DateTime,
@dt_final        as DateTime,
@cd_pedido_venda as int = 0,
@cd_usuario      as int = 0

AS

declare @ic_controle_escala_desconto  char(1) 
declare @ic_usuario_libera_desconto   char(1)
declare @cd_tipo_assinatura           int 
declare @pc_desconto_liberacao_inicio float
declare @pc_desconto_liberacao_fim    float
declare @cd_tipo_aprovacao            int

set @ic_usuario_libera_desconto = 'S'

--Verifica se a Empresa Opera com Escala de Liberação de Desconto

select
  @ic_controle_escala_desconto = isnull(ic_controle_escala_desconto,'N')
from
  Parametro_Comercial
where
  cd_empresa = dbo.fn_empresa()

if @ic_controle_escala_desconto = 'S' 
begin

  --Tipo de Assinatura
  --select * from egisadmin.dbo.tipo_assinatura_eletronica

  set @cd_tipo_assinatura = 5 --Esta Fixo, mas futuramente será alterado

  --Verifica se o usuário pode liberar o desconto
  --select * from egisadmin.dbo.usuario_assinatura

  set @ic_usuario_libera_desconto = 'N'

  select
    @cd_tipo_aprovacao = isnull(cd_tipo_aprovacao,0)
  from
    egisadmin.dbo.usuario_assinatura
  where
    cd_usuario              = @cd_usuario          and
    cd_tipo_assinatura = @cd_tipo_assinatura

  --Verifica se o usuário realiza Aprovação

  if @cd_tipo_aprovacao>0
     set @ic_usuario_libera_desconto = 'S'

  --select * from escala_aprovacao

  --Define os (%)s de aprovação

  select
    @pc_desconto_liberacao_inicio = isnull(vl_inicio_escala,0),
    @pc_desconto_liberacao_fim    = isnull(vl_final_escala,0)
  from
    Escala_Aprovacao
  where
    cd_tipo_assinatura = @cd_tipo_assinatura and
    cd_tipo_aprovacao  = @cd_tipo_aprovacao

end

--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 -- Somente os Liberados
--------------------------------------------------------------------------------------------  

begin
  select
    'N' as ic_desconto, 
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
    pvi.cd_usuario_lib_desconto,
    u.nm_fantasia_usuario as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto
   
--select * from produto

  from
    Pedido_Venda_Item pvi       with (nolock) 
    inner join Pedido_Venda pv  with (nolock) 
      on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join 
		EgisAdmin.dbo.Usuario u
			on pvi.cd_usuario_lib_desconto = u.cd_usuario left outer join
    Cliente cli
      on pv.cd_cliente = cli.cd_cliente left outer join
    Produto p
      on p.cd_produto = pvi.cd_produto Left outer join
    Vendedor vi --vendedor interno
      on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve --vendedor externo
      on pv.cd_vendedor = ve.cd_vendedor
		
  where
    pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
    pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item is null and
    pv.dt_cancelamento_pedido is null and 
    pvi.dt_desconto_item_pedido is not null and
    pvi.pc_desconto_item_pedido > 0         and
    isnull(pvi.ic_desconto_item_pedido,'N') = case when 
                                                     @ic_controle_escala_desconto ='S'      and
                                                     isnull(pvi.ic_desconto_item_pedido,'N')='N'
                                                   then  
                                                     'N'
                                                   else                               
                                                     'S' end

  order by 
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda


end

------------------------------------------
else  -- Pedidos Aguardando Liberação.

If @ic_parametro = 2 
------------------------------------------
begin
  select
    'N'                     as ic_desconto, 
    @cd_tipo_aprovacao      as cd_tipo_aprovacao,
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
    pvi.cd_usuario_lib_desconto,
    cast('' as varchar(15) ) as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor  as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor  as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido    as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto
   

  into
    #AuxDesconto
  from
    Pedido_Venda_Item pvi       with (nolock) 
    inner join Pedido_Venda pv  with (nolock) 
      on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join
    Cliente cli
      on pv.cd_cliente = cli.cd_cliente left outer join
    Produto p
      on p.cd_produto = pvi.cd_produto Left outer join
    Vendedor vi --vendedor interno
      on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve --vendedor externo
      on pv.cd_vendedor = ve.cd_vendedor
  where
    pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
    pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item    is null and
    pvi.dt_desconto_item_pedido is null and
    pv.dt_cancelamento_pedido   is null and 
    pvi.pc_desconto_item_pedido > 0     and
    isnull(pvi.ic_desconto_item_pedido,'N') = case when 
                                                     @ic_controle_escala_desconto ='S'      and
                                                     isnull(pvi.ic_desconto_item_pedido,'N')='N'
                                                   then  
                                                     'N'
                                                   else                               
                                                     'S' end



  order by 
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda

  if ( @ic_usuario_libera_desconto = 'S' ) and ( @ic_controle_escala_desconto = 'S'  )
  begin
    select 
      *
    from
       #AuxDesconto
    where
      pc_desconto_item_pedido between @pc_desconto_liberacao_inicio and @pc_desconto_liberacao_fim 

    order by 
      dt_item_pedido_venda,
      cd_pedido_venda,
      cd_item_pedido_venda

  end
  else
  begin
    select 
      *
    from
       #AuxDesconto
    order by 
      dt_item_pedido_venda,
      cd_pedido_venda,
      cd_item_pedido_venda
  end 

end

------------------------------------------
else  -- Pedidos Aguardando Liberação. Apresenta mesmo os pedidos que foram já faturados totalmente
If @ic_parametro = 3 -- Somente os Liberados
------------------------------------------
begin
  select 
    ''                           as ic_desconto,
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
	  pvi.cd_usuario_lib_desconto,
   u.nm_fantasia_usuario as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto

  from
    Pedido_Venda_Item pvi      with (nolock) 
    inner join Pedido_Venda pv with (nolock) 
      on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join
		EgisAdmin.dbo.Usuario u
			on pvi.cd_usuario_lib_desconto = u.cd_usuario left outer join
    Cliente cli
      on pv.cd_cliente = cli.cd_cliente left outer join
    Produto p
      on p.cd_produto = pvi.cd_produto Left outer join
    Vendedor vi --vendedor interno
      on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve --vendedor externo
      on pv.cd_vendedor = ve.cd_vendedor
  where
    pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
--     pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item is null and
    pv.dt_cancelamento_pedido is null and 
    pvi.ic_desconto_item_pedido = 'S' and pvi.pc_desconto_item_pedido > 0
  order by 
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda

end

else
--------------------------------------------------------------------------------------------
  If @ic_parametro = 4 --igual ao parametro 1 só que Traz apenas o pedido selecionado sem período
--------------------------------------------------------------------------------------------  
begin
  select
    'N' as ic_desconto, 
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
    pvi.cd_usuario_lib_desconto,
    u.nm_fantasia_usuario   as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto

  from
    Pedido_Venda_Item pvi with (nolock) inner join
    Pedido_Venda pv       with (nolock) 
      on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join 
		EgisAdmin.dbo.Usuario u
			on pvi.cd_usuario_lib_desconto = u.cd_usuario left outer join
    Cliente cli
      on pv.cd_cliente = cli.cd_cliente left outer join
    Produto p
      on p.cd_produto = pvi.cd_produto Left outer join
    Vendedor vi --vendedor interno
      on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve --vendedor externo
      on pv.cd_vendedor = ve.cd_vendedor
		
  where
 --   pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
    pvi.cd_pedido_venda = @cd_pedido_venda and
    pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item is null and
    pv.dt_cancelamento_pedido is null and 
    pvi.dt_desconto_item_pedido is not null and
    pvi.ic_desconto_item_pedido = 'S' and pvi.pc_desconto_item_pedido > 0
  order by 
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda
end

else

--------------------------------------------------------------------------------------------
  If @ic_parametro = 5 --igual ao parametro 2 só que Traz apenas o pedido selecionado sem período
--------------------------------------------------------------------------------------------  
begin
  select
    'N' as ic_desconto, 
    pvi.pc_desconto_item_pedido,
    pvi.ic_desconto_item_pedido,
    pvi.dt_desconto_item_pedido,
    pvi.cd_usuario_lib_desconto,
    cast('' as varchar(15) ) as nm_usuario,
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda,    
    pvi.qt_item_pedido_venda,
    pvi.vl_lista_item_pedido,
    pvi.vl_unitario_item_pedido,
    pvi.nm_fantasia_produto,
    pvi.nm_produto_pedido as 'nm_produto',
    pvi.cd_usuario,
    pvi.dt_usuario,
    isnull(p.pc_desconto_max_produto,0) as pc_desconto_max_produto,
    isnull(p.pc_desconto_min_produto,0) as pc_desconto_min_produto

  from
    Pedido_Venda_Item pvi with (nolock) inner join
    Pedido_Venda pv       with (nolock) 
      on pv.cd_pedido_venda = pvi.cd_pedido_venda left outer join
    Cliente cli
      on pv.cd_cliente = cli.cd_cliente left outer join
    Produto p
      on p.cd_produto = pvi.cd_produto Left outer join
    Vendedor vi --vendedor interno
      on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve --vendedor externo
      on pv.cd_vendedor = ve.cd_vendedor
  where
--    pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
    pvi.cd_pedido_venda = @cd_pedido_venda and
    pvi.qt_saldo_pedido_venda > 0 and 
    pvi.dt_cancelamento_item is null and
    pvi.dt_desconto_item_pedido is null and
    pv.dt_cancelamento_pedido is null and 
    pvi.ic_desconto_item_pedido = 'S' and pvi.pc_desconto_item_pedido > 0
  order by 
    pvi.dt_item_pedido_venda,
    pvi.cd_pedido_venda,
    pvi.cd_item_pedido_venda


end

