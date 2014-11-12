--pr_recepcao_coleta_wap
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                   2002                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Recepcao de Coleta de Dados do Ponto de Venda
--Data          : 06.04.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
create procedure pr_recepcao_coleta_wap
@cd_usuario            int,
@cd_cliente            int,
@cd_fornecedor         int,
@cd_produto            int,
@qt_produto_coleta     float,
@vl_produto_coleta     float,
@qt_frente_coleta      int

as

begin

declare @cd_coleta  int
set     @cd_coleta  = 0

declare @cd_promotor int
set     @cd_promotor = 1

Begin Transaction

-- Busca do Codigo Sequencial

Select 
   @cd_coleta = ISNULL(MAX(cd_coleta),0) + 1 FROM Coleta TABLOCK

-- Gravacao da Tabela de Coleta do Ponto de Venda

Insert Into Coleta
       (cd_coleta,
        dt_coleta,
        cd_cliente,
        cd_promotor,
        cd_roteiro_coleta,
        qt_dia_util_coleta,
        qt_visita_coleta,
        cd_usuario,
        dt_usuario)
         
Values
       (@cd_coleta,
        getdate(),
        @cd_cliente,
        @cd_promotor,
        1,
        1,
        1,
        @cd_usuario,
        getdate() )

--Gravando o Item da Coleta

Insert Into Coleta_Item
       (cd_coleta,
        cd_item_coleta,
        qt_frente_item_coleta,
        vl_preco_item_coleta,
        qt_item_coleta, 
        cd_produto,
        cd_fornecedor,
        cd_usuario,
        dt_usuario)
         
Values
       (@cd_coleta,
        1,
        @qt_frente_coleta,        
        @vl_produto_coleta,
        @qt_produto_coleta,
        @cd_produto,
        @cd_fornecedor,       
        @cd_usuario,
        getdate() )

 if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end

end

