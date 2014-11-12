
CREATE PROCEDURE pr_produto_localizacao_estoque_fase
@cd_produto int, -- Código do Produto
@cd_fase_produto int

As

declare @cd_grupo_localizacao int,
	@cd_count int

Select 
	pgl.cd_grupo_localizacao, 
	pgl.nm_grupo_localizacao,	
	cast(null as varchar(15)) as qt_posicao_localizacao,
	@cd_produto as cd_produto,
	@cd_fase_produto as cd_fase_produto,
	0 as cd_item_localizacao,
	0 as cd_usuario,
	getdate() as dt_usuario,
  ps.qt_saldo_atual_produto as 'Atual',
  ps.qt_saldo_reserva_produto as 'Disponivel'
Into
	#Produto_Grupo_Localizacao
from 
	Produto_Grupo_Localizacao pgl
  left outer join produto_saldo ps on ps.cd_produto = @cd_produto and
                                      ps.cd_fase_produto = @cd_fase_produto


set @cd_count = 1

DECLARE Cursor_Produto_Grupo_Localizacao CURSOR FOR
SELECT cd_grupo_localizacao FROM #Produto_Grupo_Localizacao

OPEN Cursor_Produto_Grupo_Localizacao 
FETCH NEXT FROM Cursor_Produto_Grupo_Localizacao into @cd_grupo_localizacao
WHILE @@FETCH_STATUS = 0
BEGIN
   update #Produto_Grupo_Localizacao
   set
	#Produto_Grupo_Localizacao.qt_posicao_localizacao = pl.qt_posicao_localizacao,
	#Produto_Grupo_Localizacao.cd_item_localizacao = @cd_count,
--	#Produto_Grupo_Localizacao.cd_usuario = pl.cd_usuario,
--	#Produto_Grupo_Localizacao.dt_usuario = pl.dt_usuario
	#Produto_Grupo_Localizacao.cd_usuario = Isnull(pl.cd_usuario,0),
	#Produto_Grupo_Localizacao.dt_usuario = Isnull(pl.dt_usuario,GetDate())
   From
	#Produto_Grupo_Localizacao, Produto_Localizacao pl
   where
	pl.cd_grupo_localizacao = @cd_grupo_localizacao and
	pl.cd_fase_produto      = @cd_fase_produto and
	#Produto_Grupo_Localizacao.cd_grupo_localizacao = @cd_grupo_localizacao and
	#Produto_Grupo_Localizacao.cd_produto = pl.cd_produto

   set @cd_count = @cd_count + 1
   FETCH NEXT FROM Cursor_Produto_Grupo_Localizacao into @cd_grupo_localizacao
END
CLOSE Cursor_Produto_Grupo_Localizacao
DEALLOCATE Cursor_Produto_Grupo_Localizacao

select * from #Produto_Grupo_Localizacao

drop table #Produto_Grupo_Localizacao
