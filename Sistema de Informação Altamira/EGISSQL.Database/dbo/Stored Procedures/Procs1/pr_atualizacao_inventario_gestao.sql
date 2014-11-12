
-----------------------------------------------------------------------------------
--pr_atualizacao_inventario_gestao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Atualização do Inventário de Gestão
--Data             : 10.09.2003
--		   : Incluido os campos do INSERT da tabela Produto_Fechamento
-----------------------------------------------------------------------------------
create procedure pr_atualizacao_inventario_gestao
@dt_base    datetime,
@cd_usuario int
as

select
  cd_produto,                
  cd_fase_produto,           
  sum(qt_inventario_gestao) as 'quantidade'
into
  #Deleta_Fechamento
from
  Inventario_Gestao
where
  @dt_base between dt_ini_inventario_gestao  and dt_fim_inventario_gestao
group by
  cd_produto,cd_fase_produto


declare @cd_produto      int
declare @cd_fase_produto int
set @cd_produto      = 0
set @cd_fase_produto = 0

while exists ( select top 1 cd_produto from #Deleta_Fechamento )
begin

  --Busca o Produto

  select 
    top 1
    @cd_produto      = cd_produto,
    @cd_fase_produto = cd_fase_produto
  from
    #deleta_fechamento

  --Deleta o Fechamento do Produto
 
  delete from produto_fechamento 
  where 
    dt_produto_fechamento = @dt_base    and 
    cd_produto            = @cd_produto and 
    cd_fase_produto       = @cd_fase_produto

  --Deleta o Registro da Tabela Temporária
  delete from #deleta_fechamento
  where
    cd_produto      = @cd_produto and
    cd_fase_produto = @cd_fase_produto

end
  
select
  cd_produto,                
  cd_fase_produto,           
  sum(qt_inventario_gestao) as 'quantidade'
into
  #Inventario_Gestao_Auxiliar
from
  Inventario_Gestao
where
  @dt_base between dt_ini_inventario_gestao  and dt_fim_inventario_gestao
group by
  cd_produto,cd_fase_produto

insert INTO produto_fechamento 
(
cd_produto,
cd_fase_produto,
dt_produto_fechamento,
qt_atual_prod_fechamento,
qt_entra_prod_fechamento,
qt_saida_prod_fechamento,
qt_consig_prod_fechamento,
qt_terc_prod_fechamento,
cd_usuario,
dt_usuario,
vl_custo_prod_fechamento,
vl_maior_lista_produto,
vl_maior_preco_produto,
vl_maior_custo_produto

)
select
       cd_produto,
       cd_fase_produto,	
       @dt_base,
       quantidade,
       0, --qt_entra_prod_fechamento,
       0, --qt_saida_prod_fechamento,
       0, --qt_consig_prod_fechamento,
       0, --qt_terc_prod_fechamento,
       @cd_usuario,
       getdate(),
       0, -- vl_custo_prod_fechamento
       0, -- vl_maior_lista_produto
       0, -- vl_maior_preco_produto
       0 -- vl_maior_custo_produto


from
   #Inventario_Gestao_Auxiliar

