
-----------------------------------------------------------------------------------
--pr_gera_nota_entrada_peps_por_nota_entrada
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Geração de Nota de Entrada Peps por Nota fiscal de Entrada
--Data             : 10.09.2003
-----------------------------------------------------------------------------------
create procedure pr_gera_nota_entrada_peps_por_nota_entrada
@cd_nota_entrada      int,
@cd_item_nota_entrada int,
@cd_fornecedor        int,
@cd_usuario           int,
@cd_grupo_produto     int

as

if @cd_grupo_produto = 0
begin
  select
    cd_produto, 
    cd_fornecedor,
    cd_nota_entrada,
    cd_item_nota_entrada,
    dt_item_receb_nota_entrad,
    qt_item_nota_entrada,
    vl_item_nota_entrada,
    pc_icms_nota_entrada,
    cd_movimento_estoque = 0
/*
    cd_movimento_estoque = ( select top 1 cd_movimento_estoque from
                             Movimento_Estoque where
                             cd_documento_movimento = cd_nota_entrada      and
                             cd_item_documento      = cd_item_nota_entrada and
                             cd_fornecedor          = cd_fornecedor        and
                             cd_produto             = cd_produto           )

*/
  into
    #Nota_Entrada_Auxiliarx
  from
    Nota_Entrada_Item
  where
    --ic_peps_nota_entrada = 'S'
    cd_nota_entrada     = @cd_nota_entrada      and
    cd_item_nota_entrada= @cd_item_nota_entrada and
    cd_fornecedor       = @cd_fornecedor        and
    cd_produto is not null
  order by
    cd_nota_entrada,cd_item_nota_entrada

end
else
begin

--Grupo de Produto

  select
    n.cd_produto, 
    n.cd_fornecedor,
    n.cd_nota_entrada,
    n.cd_item_nota_entrada,
    n.dt_item_receb_nota_entrad,
    n.qt_item_nota_entrada,
    n.vl_item_nota_entrada,
    n.pc_icms_nota_entrada,
    cd_movimento_estoque = 0
/*
    cd_movimento_estoque = ( select top 1 cd_movimento_estoque from
                             Movimento_Estoque where
                             cd_documento_movimento = n.cd_nota_entrada      and
                             cd_item_documento      = n.cd_item_nota_entrada and
                             cd_fornecedor          = n.cd_fornecedor        and
                             cd_produto             = n.cd_produto           )
  
*/                
  into
    #Nota_Entrada_Auxiliar
  from
    Nota_Entrada_Item n, 
    Produto p
  where
    n.cd_produto is not null                      and
    n.cd_produto          = p.cd_produto          and
    p.cd_grupo_produto    = @cd_grupo_produto
  order by
    n.cd_nota_entrada,n.cd_item_nota_entrada

end

/*
insert into nota_entrada_peps
select
   cd_movimento_estoque,
   cd_produto,
   cd_fornecedor,
   cd_nota_entrada,
   cd_item_nota_entrada,
   qt_item_nota_entrada,
   vl_item_nota_entrada*(100-pc_icms_nota_entrada)/100,
   qt_item_nota_entrada*((100-pc_icms_nota_entrada)/100*vl_item_nota_entrada), --vl_custo_total_peps	float
   0, --qt_valorizacao_peps	float
   0, --vl_custo_valorizacao_peps	float
   0, --vl_fob_entrada_peps	float
   @cd_usuario,
   getdate(),
   dt_item_receb_nota_entrad
from
     #Nota_Entrada_Auxiliar
*/

