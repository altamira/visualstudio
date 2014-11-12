
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_tabela_preco_categoria_cliente
-------------------------------------------------------------------------------
--pr_consulta_tabela_preco_categoria_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Consulta de Preço de Produto por tabela de Preço/Cliente
--                   Categoria
--
--Data             : 21.02.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_tabela_preco_categoria_cliente
@cd_tabela_preco int = 0,
@cd_cliente      int = 0

as

declare @cd_fase_produto int
declare @nm_fantasia_cliente varchar(15)
declare @nm_razao_social     varchar(50)

set @nm_fantasia_cliente = ''
set @nm_razao_social     = ''

select 
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  Parametro_Comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()


if @cd_cliente <> 0 
begin

  --select * from cliente

  select
    @cd_tabela_preco     = isnull(c.cd_tabela_preco,0),
    @nm_fantasia_cliente = isnull(c.nm_fantasia_cliente,''),
    @nm_razao_social     = isnull(c.nm_razao_social_cliente,'')
  from
    Cliente c
  where
    cd_cliente = @cd_cliente 

end

--select * from tabela_preco_categoria_produto
--select * from categoria_produto
  
select
  tpc.cd_tabela_preco,
  tp.nm_tabela_preco,
  tpc.cd_categoria_produto,
  cp.nm_categoria_produto,
  cp.cd_mascara_categoria,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  ps.qt_saldo_reserva_produto,
  tpc.vl_tabela_preco,
  tpc.vl_base_icms_subs_trib,
  @nm_fantasia_cliente     as 'nm_fantasia_cliente',
  @nm_razao_social         as 'nm_razao_social_cliente'  

from
  Tabela_Preco_Categoria_Produto tpc   with (nolock)
  left outer join Categoria_Produto cp with (nolock) on cp.cd_categoria_produto = tpc.cd_categoria_produto
  left outer join Produto           p  with (nolock) on p.cd_categoria_produto  = tpc.cd_categoria_produto
  left outer join Tabela_Preco     tp  with (nolock) on tp.cd_tabela_preco      = tpc.cd_tabela_preco
  left outer join Unidade_Medida   um  with (nolock) on um.cd_unidade_medida    = p.cd_unidade_medida
  left outer join Produto_Saldo    ps  with (nolock) on ps.cd_produto           = p.cd_produto and
                                                        ps.cd_fase_produto      = case when isnull(p.cd_fase_produto_baixa,0)>0 
                                                        then p.cd_fase_produto_baixa 
                                                        else @cd_fase_produto end 
  --left outer join Cliente c            with (nolock) on c.cd_cliente = @cd_cliente

where
  tpc.cd_tabela_preco = case when @cd_tabela_preco = 0 then tpc.cd_tabela_preco else @cd_tabela_preco end 

order by
  tp.nm_tabela_preco,  
  p.nm_fantasia_produto

