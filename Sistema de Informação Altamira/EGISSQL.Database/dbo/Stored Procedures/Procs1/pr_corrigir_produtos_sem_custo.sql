
create procedure pr_corrigir_produtos_sem_custo
as

---------------------------------------------------
--GBS - Global Business Sollution S/A          2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Eduardo Baião
--Banco de Dados: EGISSQL
--Objetivo: Preencher o valor de Custo dos Produtos
--          que não tiverem o mesmo definido
--Data: 28/11/2003
--Atualizado: 
---------------------------------------------------

-- Incluir os registros na tabela Produto_Custo 
insert into produto_custo
( cd_produto, vl_custo_produto )
select
cd_produto, 0
from
produto p
where
p.cd_produto not in ( select cd_produto from produto_custo )

-- Preencher os valores do custo baseando-se
-- nos valores encontrados nas notas de entrada

--update produto_custo set vl_custo_produto = nei.vl_item_nota_entrada
--from
--produto_custo pc
--inner join nota_entrada_item

declare @cd_produto int
declare @vl_item_nota_entrada money
declare @contador int

declare cr cursor for
  select cd_produto from produto_custo
  where isnull(vl_custo_produto,0) = 0
  order by cd_produto

open cr

FETCH NEXT FROM cr INTO @cd_produto

set @contador = 0

begin tran
print 'begin tran'

while @@FETCH_STATUS = 0 begin

  if ( @contador = 200 ) begin
    commit tran
    print 'commit'

    set @contador = 0

    begin tran
    print 'begin tran'
  end

  -- selecionar o último valor de compra
  -- para este produto
  select top 1
    @vl_item_nota_entrada = nei.vl_item_nota_entrada
  from
    nota_entrada_item nei

    inner join
    nota_entrada ne
    on ne.cd_nota_entrada = nei.cd_nota_entrada

  where
    nei.cd_produto = @cd_produto

  order by
    ne.dt_nota_entrada desc

  -- atualizar o valor de custo
  if ( @vl_item_nota_entrada > 0 ) begin

    update produto_custo
      set vl_custo_produto = @vl_item_nota_entrada
    where
      cd_produto = @cd_produto

    set @contador = @contador + 1

  end -- if

  FETCH NEXT FROM cr INTO @cd_produto

end --while

commit tran
print 'commit'


close cr
deallocate cr

