
CREATE FUNCTION fn_verifica_permissao_item(@cd_pedido_venda int , 
                                           @cd_departamento int )
RETURNS char(1)

AS
BEGIN

  -- criar a tabela temporária na memória

  declare @Departamento table 
  ( cd_departamento int, 
    cd_finalidade int)
  
  -- tabela temporária com os processos já lidos
  declare @Produto table
  ( cd_produto int null,
    cd_grupo_produto int,
    cd_finalidade int null)

insert into @Departamento
select
  @cd_departamento as cd_departamento,
  cd_finalidade

from
  ( select top 1
      0 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento

   union all

   select
      1 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_comercial_produto = 'S' 

  union all

    select
      2 as cd_finalidade
    from
      Departamento_Finalidade 
    where
      cd_departamento = @cd_departamento and
      ic_compra_produto = 'S' 
  union all

    select
      3 as cd_finalidade
    from
      Departamento_Finalidade 
    where
      cd_departamento = @cd_departamento and
      ic_producao_produto = 'S' 
  union all

    select
      4 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_processo_produto = 'S' 
  union all

    select
      5 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_importacao_produto = 'S' 
  union all

    select
      6 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_exportacao_produto = 'S' 
  union all

    select
      7 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_beneficiamento_produto = 'S' 
  union all

    select
      8 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_amostra_produto = 'S' 
  union all

    select
      9 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_consignacao_produto = 'S' 
  union all

    select
      10 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_transferencia_produto = 'S' 
  union all

    select
      11 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_sob_encomenda_produto = 'S' 
  union all

    select
      12 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_revenda_produto = 'S' 
  union all

    select
      13 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_tecnica_produto = 'S' 
  union all

    select
      14 as cd_finalidade
    from
      Departamento_Finalidade
    where
      cd_departamento = @cd_departamento and
      ic_almox_produto = 'S' ) s

insert into @Produto
select
  p.cd_produto as cd_Produto,
  p.cd_grupo_produto,
  cd_finalidade
from
  Pedido_Venda_Item p left outer join
  ( select
      x.cd_produto,
      1 as cd_finalidade
    from
      Produto x
    where
      ic_comercial_produto = 'S' 

  union all

    select
      x.cd_produto,
      2 as cd_finalidade
    from
      Produto x
    where
      ic_compra_produto = 'S' 
  union all

    select
      x.cd_produto,
      3 as cd_finalidade
    from
      Produto x
    where
      ic_producao_produto = 'S' 
  union all

    select
      x.cd_produto,
      4 as cd_finalidade
    from
      Produto x
    where
      ic_processo_produto = 'S' 
  union all

    select
      x.cd_produto,
      5 as cd_finalidade
    from
      Produto x
    where
      ic_importacao_produto = 'S' 
  union all

    select
      x.cd_produto,
      6 as cd_finalidade
    from
      Produto x
    where
      ic_exportacao_produto = 'S' 
  union all

    select
      x.cd_produto,
      7 as cd_finalidade
    from
      Produto x
    where
      ic_beneficiamento_produto = 'S' 
  union all

    select
      x.cd_produto,
      8 as cd_finalidade
    from
      Produto x
    where
      ic_amostra_produto = 'S' 
  union all

    select
      x.cd_produto,
      9 as cd_finalidade
    from
      Produto x
    where
      ic_consignacao_produto = 'S' 
  union all

    select
      x.cd_produto,
      10 as cd_finalidade
    from
      Produto x
    where
      ic_transferencia_produto = 'S' 
  union all

    select
      x.cd_produto,
      11 as cd_finalidade
    from
      Produto x
    where
      ic_sob_encomenda_produto = 'S' 
  union all

    select
      x.cd_produto,
      12 as cd_finalidade
    from
      Produto x
    where
      ic_revenda_produto = 'S' 
  union all

    select
      x.cd_produto,
      13 as cd_finalidade
    from
      Produto x
    where
      ic_tecnica_produto = 'S' 
  union all

    select
      x.cd_produto,
      14 as cd_finalidade
    from
      Produto x
    where
      ic_almox_produto = 'S' ) s on s.cd_produto = p.cd_produto
  where
    p.cd_Pedido_venda = @cd_pedido_venda 
    and IsNull(p.cd_produto,0) > 0

  --Grava na tabela de produto os grupos dos casos especiais
  insert into @Produto
  select
    0 as cd_Produto,
    p.cd_grupo_produto,
    0 as c_finalidade
  from
    Pedido_Venda_Item p
  where
    p.cd_Pedido_venda = @cd_pedido_venda 

declare @ic_acesso_permitido char(1)

if exists( select 'x' 
           from
              @Departamento d inner join
              @Produto p on ( case when IsNull(p.cd_Produto,0) = 0 then
                               ( select x.cd_grupo_produto
                                 from Departamento_Grupo_Produto x
                                 where x.cd_departamento = @cd_departamento and
                                       x.cd_grupo_produto = p.cd_grupo_produto )
                              else IsNull(d.cd_finalidade,0) end ) = 
                            ( case when IsNull(p.cd_Produto,0) = 0 then
                                p.cd_grupo_produto 
                              else IsNull(p.cd_finalidade,0) end ) )
  set @ic_acesso_permitido = 'S'
else
  set @ic_acesso_permitido = 'N'


  RETURN @ic_acesso_permitido
END
