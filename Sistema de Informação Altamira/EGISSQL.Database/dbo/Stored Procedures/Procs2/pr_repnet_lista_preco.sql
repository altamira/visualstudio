



--pr_repnet_lista_preco
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta da Lista de Preço por Série ou Grupo de Produto
--Data          : 07.04.2002
--Atualizado    : 
----------------- ---------------------------------------------------------------------
create procedure pr_repnet_lista_preco
@cd_grupo_produto int,
@cd_serie_produto int
  
as


if @cd_grupo_produto > 0 
begin 
  select p.nm_fantasia_produto as 'Produto',
         p.nm_produto          as 'Descricao',
         u.sg_unidade_medida   as 'Und',
         p.vl_produto          as 'PrecoLista',
         s.qt_saldo_reserva_produto  as 'Disponivel' 

  from       
         Produto p,Unidade_Medida u, Produto_Saldo s
  where
         p.cd_grupo_produto  = @cd_grupo_produto   and
         p.cd_unidade_medida = u.cd_unidade_medida and
         p.cd_produto        = s.cd_produto        and
         s.cd_fase_produto   = 3
end

if @cd_serie_produto>0
begin
  select p.nm_fantasia_produto as 'Produto',
         p.nm_produto          as 'Descricao',
         u.sg_unidade_medida   as 'Und',
         p.vl_produto          as 'PrecoLista',
         s.qt_saldo_reserva_produto  as 'Disponivel' 

  from       
         Produto p,Unidade_Medida u, Produto_Saldo s
  where
         p.cd_grupo_produto  = @cd_grupo_produto   and
         p.cd_unidade_medida = u.cd_unidade_medida and
         p.cd_produto        = s.cd_produto        and
         s.cd_fase_produto   = 3

end     




