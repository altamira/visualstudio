
CREATE PROCEDURE pr_gera_produto_inventario_fisico

@dt_inventario   datetime,
@cd_usuario      int = 0

AS

--select * from produto_inventario

delete from produto_inventario

--produto_inventario
insert into
  produto_inventario
(cd_produto,
 qt_inventario,
 cd_fase_produto,
 cd_usuario,
 dt_usuario,
 cd_tipo_movimento_estoque,
 qt_saldo_atual_produto,
 vl_custo_inventario)
select
  cd_produto,

  --qt_atual_sistema - qt_real
  (qt_real-qt_atual_sistema)
  *
  case when (qt_real-qt_atual_sistema) > 0 then 1 else -1 end,

  cd_fase_produto,
  @cd_usuario,
  getdate(),
  case when (qt_real-qt_atual_sistema) > 0 then 1 else 11 end,
  qt_atual_sistema,
  0.00
  
from
  inventario_fisico

where
  dt_inventario = @dt_inventario
  and
  qt_real <> qt_atual_sistema
  
  

-- select
--   cd_produto,
--   qt_atual_sistema,
--   qt_real,
-- 
-- 
--   (qt_real-qt_atual_sistema)
--   *
--   case when qt_real-qt_atual_sistema > 0 then 1 else -1 end as qt_inventario,
-- 
--   cd_fase_produto,
--   4 as cd_usuario,
--   getdate(),
--   case when qt_real-qt_atual_sistema > 0 then 1 else 11 end,
--   qt_atual_sistema,
--   0.00
--   
-- from
--   inventario_fisico
-- 
-- where
--   cd_produto = 263 
--   --dt_inventario = @dt_inventario
--   and
--   qt_real <> qt_atual_sistema
--   


--select * from tipo_movimento_estoque

--select * from produto_inventario 

--inventario_fisico



