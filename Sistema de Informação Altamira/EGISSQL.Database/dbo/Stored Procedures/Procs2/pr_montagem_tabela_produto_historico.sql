
-----------------------------------------------------------------------------------
--pr_montagem_tabela_produto_historico
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004
-----------------------------------------------------------------------------------                     
--Stored Procedure      : SQL Server Microsoft 2000
--Autor (es)            : Carlos Cardoso Fernandes         
--Banco Dados           : EGISSQL
--Objetivo              : Montagem da Tabela Produto Histórico
--Data                  : 04.09.2003
--Atualizado            : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso 
--                      : 20.07.2005 - Acerto do Flag / Group by - Carlos Fernandes
-----------------------------------------------------------------------------------
create procedure pr_montagem_tabela_produto_historico
as

--Verificar de Acordo com o Cliente
--04.09.2003
--Carlos

--truncate table produto_historico

select 
 identity(int,1,1)              as cd_produto_historico,
 max(dt_item_pedido_venda)      as dt_historico_produto,
 cd_produto                     as 'cd_produto',
 0                              as cd_grupo_produto,
 isnull(vl_lista_item_pedido,0) as 'vl_historico_produto',
 1                              as cd_tipo_tabela_preco,	
 1                              as cd_tipo_reajuste,	
 1                              as cd_moeda,
 0                              as cd_usuario,	
 getdate()                      as dt_usuario,
 1                              as cd_motivo_reajuste,
 'V'                            as ic_tipo_historico_produto 
	

 into
   #tabela_preco
from 
 pedido_venda_item
where
 cd_produto>0
group by
 --dt_item_pedido_venda,
 cd_produto,
 vl_lista_item_pedido

insert into produto_historico
 (cd_produto_historico, 
  dt_historico_produto,
  cd_produto,
  cd_grupo_produto,
  vl_historico_produto,
  cd_tipo_tabela_preco,	
  cd_tipo_reajuste,	
  cd_moeda,
  cd_usuario,	
  dt_usuario,
  cd_motivo_reajuste,
  ic_tipo_historico_produto )
select * from #tabela_preco 

