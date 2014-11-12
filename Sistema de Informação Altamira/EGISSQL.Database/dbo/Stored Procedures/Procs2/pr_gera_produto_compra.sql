
-------------------------------------------------------------------------------
--sp_helptext pr_gera_produto_compra
-------------------------------------------------------------------------------
--pr_gera_produto_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 01.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_produto_compra
@ic_parametro int = 0

as

declare @cd_fase_produto int

select 
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial pc with (nolock)
where
  cd_empresa = dbo.fn_empresa()


--select * from produto_compra

if @ic_parametro = 1

begin

  insert into produto_compra
  select
    p.cd_produto,
    null                    as nm_compra_produto,
    null                    as nm_marca_produto,
    null                    as cd_unidade_medida,
    null                    as qt_fatcompra_produto,
    null                    as cd_destinacao_produto,
    null                    as cd_aplicacao_produto,
    null                    as nm_obs_aplicacao_produto,
    null                    as nm_obs_producao_produto,
    null                    as qt_mes_compra_produto,
    null                    as qt_lotecompra_produto,
    4                       as cd_usuario,
    getdate()               as dt_usuario,

   case when isnull(p.cd_fase_produto_baixa,0)=0 then
    @cd_fase_produto 
   else
    p.cd_fase_produto_baixa
   end                     as cd_fase_produto,

   case when isnull(p.cd_fase_produto_baixa,0)=0 then
    @cd_fase_produto 
   else
    p.cd_fase_produto_baixa
   end                     as cd_fase_produto_entrada,
   cast('' as varchar)     as ds_produto_compra,
   null                    as nm_produto_compra,
   null                    as ic_cotacao_grupo_produt,
   'S'                     as ic_cotacao_produto,
   null                    as cd_plano_compra,
   null                    as qt_dia_validade_minima
from 
   produto p with (nolock) 
where
  p.cd_produto not in ( select cd_produto from produto_compra )

end

if @ic_parametro =2
begin
  update
    produto_compra
  set
    ic_cotacao_produto = 'S'

end

if @ic_parametro = 3
begin

  update
    produto_compra
  set
    cd_fase_produto = case when isnull(p.cd_fase_produto_baixa,0)=0 then
    @cd_fase_produto 
   else
    p.cd_fase_produto_baixa
   end,

   cd_fase_produto_entrada = case when isnull(p.cd_fase_produto_baixa,0)=0 then
    @cd_fase_produto 
   else
    p.cd_fase_produto_baixa
   end   
  
  from produto_compra pc
  inner join produto p on p.cd_produto = pc.cd_produto
  where
    p.cd_fase_produto_baixa <> 0 and
    pc.cd_fase_produto <> p.cd_fase_produto_baixa


end


