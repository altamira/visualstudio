-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
-----------------------------------------------------------------------------------
--pr_movimentacao_lote_produto
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2005                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Paulo Santos         
--Banco Dados      : EGISSQL
--Objetivo         : Movimentação do Estoque Lote Produto
--Data             : 15.02.2005
-----------------------------------------------------------------------------------

-- Valores dos Parâmetros

-- @ic_parametro            = 1
-- @cd_lote_produto         = 123
-- @nm_lote_produto         = 'Ref CCF Lote'
-- @nm_ref_lote_produto     = 'Ref CCF Lote'
-- @ic_status_lote_produto  = 'A'
-- @dt_inicial_lote_produto = '02/15/2005'
-- @dt_final_lote_produto   = '02/15/2005'
-- @ic_estoque_lote_produto = 'N'
-- @qt_produto_lote_produto = 1000
-- @cd_produto              = 263
-- @cd_unidade_medida       = 12
-- @cd_usuario              = 153
-- @dt_usuario              = '02/15/2005'

CREATE procedure pr_movimentacao_lote_produto

@ic_parametro int,
@cd_lote_produto int,
@nm_lote_produto varchar(25),
@nm_ref_lote_produto varchar(25),
@ic_status_lote_produto char(1),
@dt_inicial_lote_produto datetime,
@dt_final_lote_produto datetime,
@ic_estoque_lote_produto char(1),
@qt_produto_lote_produto float,
@cd_produto int,
@cd_unidade_medida int,
@cd_usuario int,
@dt_usuario datetime


as

---------------------------------------
-- Consulta Lotes
---------------------------------------

if @ic_parametro = 1
 begin
		select 
		  lp.cd_lote_produto,
		  lp.nm_lote_produto,
		  lp.nm_ref_lote_produto,
		  lp.ic_status_lote_produto,
		  lp.dt_inicial_lote_produto,
		  lp.dt_final_lote_produto,
		  lp.ic_estoque_lote_produto,
		  lp.cd_usuario,
		  lp.dt_usuario,
		  
		  lpi.*
		from 
		  lote_produto lp
		left outer join lote_produto_item lpi
		  on lp.cd_lote_produto = lpi.cd_lote_produto
    where lpi.cd_produto = ( case when @cd_produto = 0 then
                               lpi.cd_produto else @cd_produto end) and
          lpi.cd_lote_produto = ( case when @cd_lote_produto = 0 then
                                    lpi.cd_lote_produto else @cd_lote_produto end) and
          lpi.ic_tipo_movimento_lote = 'E'
          
 end

---------------------------------------
-- Inclusão de Lotes
---------------------------------------

if @ic_parametro = 2
 begin
   -- Insere Lote_Produto

  insert into lote_produto
    (cd_lote_produto,
     nm_lote_produto,
     nm_ref_lote_produto,
     ic_status_lote_produto,
     dt_inicial_lote_produto,
     dt_final_lote_produto,
     ic_estoque_lote_produto)
  values
    (@cd_lote_produto,
     @nm_lote_produto,
     @nm_ref_lote_produto,
     @ic_status_lote_produto,
     @dt_inicial_lote_produto,
     @dt_final_lote_produto,
     @ic_estoque_lote_produto)

  -- Insere lote_produto_item

  insert into lote_produto_item
    (cd_lote_produto,
     qt_produto_lote_produto,
     dt_inicio_item_lote,
     dt_final_item_lote,
	   cd_produto,
     cd_unidade_medida,
	   cd_usuario,
	   dt_usuario)
  values
    (@cd_lote_produto,
     @qt_produto_lote_produto,
     @dt_inicial_lote_produto,
     @dt_final_lote_produto,
	   @cd_produto,
     @cd_unidade_medida,
	   @cd_usuario,
	   @dt_usuario)
 end

---------------------------------------
-- Inclusão de Lotes
---------------------------------------

if @ic_parametro = 3
 begin
   insert into lote_produto_item
    (cd_lote_produto,
     qt_produto_lote_produto,
     dt_inicio_item_lote,
     dt_final_item_lote,
	   cd_produto,
     cd_unidade_medida,
	   cd_usuario,
	   dt_usuario)
   values
    (@cd_lote_produto,
     @qt_produto_lote_produto,
     @dt_inicial_lote_produto,
     @dt_final_lote_produto,
	   @cd_produto,
     @cd_unidade_medida,
	   @cd_usuario,
	   @dt_usuario)
 end



