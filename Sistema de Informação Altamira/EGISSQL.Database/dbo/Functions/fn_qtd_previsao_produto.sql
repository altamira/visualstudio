


--------------------------------------------------------------------------------------
--GBS - GLobal Business Solution - 200@cd_fase_produto
--Stored Procedure : SQL Server Microsoft 7.0  
--Daniel C. Neto.
--Função para retornar a quantidade de previsão de entrada de um produto.
--Data         : 16/02/2005
-- 09/05/2005 - Mudança na lógica de retorno de previsão de entrada - Daniel C. Neto.
-- 11/05/2005 - Como a previsão de entrega só está sendo usada na POLIMOLD
-- e a POLIMOLD não usa previsão de compras, será usado somente os campos de previsão de importação.
-- - Daniel C. NEto.
-- 19/05/2005 - Foi necessário reescrever toda a rotina pois não estava funcionando conforme o especificado 
--              Fabio Cesar - POLIMOLD
--------------------------------------------------------------------------------------
CREATE  FUNCTION fn_qtd_previsao_produto(@cd_produto int, @cd_fase_produto int, @qtd_requisitada float)
RETURNS Float
AS
BEGIN

   declare 
           @qt_reservada float, --Quantidade que deverá na chegada
           @dt_resultado datetime,
           @cd_id int,
           @qt_prevista float


   select 
        @qtd_requisitada = @qtd_requisitada - IsNull(qt_saldo_atual_produto,0)
   from 
       Produto_Saldo 
   where 
       cd_produto = @cd_produto and
       cd_fase_produto = @cd_fase_produto 


   --Verifica se existe alguma previsão para não realizar processamento desnecessário
   Select 
     @qt_prevista = 
     IsNull(
      (
       case
         when ( dt_ped_comp_imp1 is null ) then
             0
         else
             IsNull(qt_ped_comp_imp1,0)   
       end +
       case
         when ( dt_ped_comp_imp2 is null ) then
             0
         else
             IsNull(qt_ped_comp_imp2,0)   
       end +
       case
         when ( dt_ped_comp_imp3 is null ) then
             0
         else
             IsNull(qt_ped_comp_imp3,0)   
       end),0)
   from 
       Produto_Saldo 
   where 
       cd_produto = @cd_produto and
       cd_fase_produto = @cd_fase_produto 


   --Verifica se a quantidade prevista atende a quantidade requisitada
   if @qt_prevista >=  @qtd_requisitada 
   begin

           --A criação da tabela foi necessária devido a questão da ordenação por data         
           declare @tmpPrevisao table 
          ( 
           cd_id int,
           qt_previsao float,
           dt_previsao datetime )
        

          --Carrega com os dados da previsao 1 de importação
          insert into @tmpPrevisao
          select
               1,
               IsNull(qt_ped_comp_imp1,0),
               dt_ped_comp_imp1
          from 
               Produto_Saldo 
          where 
               cd_produto = @cd_produto and
               cd_fase_produto = @cd_fase_produto and
               IsNull(qt_ped_comp_imp1,0) > 0 and
               dt_ped_comp_imp1 is not null 
        
          --Carrega com os dados da previsao 2 de importação
          insert into @tmpPrevisao
          select 
               2,
               IsNull(qt_ped_comp_imp2,0),
               dt_ped_comp_imp2
          from 
               Produto_Saldo 
          where 
               cd_produto = @cd_produto and
               cd_fase_produto = @cd_fase_produto and
               IsNull(qt_ped_comp_imp2,0) > 0 and
               dt_ped_comp_imp2 is not null 
        
        
          --Carrega com os dados da previsao 3 de importação
          insert into @tmpPrevisao
          select 
               3,
               IsNull(qt_ped_comp_imp3,0),
               dt_ped_comp_imp3
          from 
               Produto_Saldo 
          where 
               cd_produto = @cd_produto and
               cd_fase_produto = @cd_fase_produto and
               IsNull(qt_ped_comp_imp3,0) > 0 and
               dt_ped_comp_imp3 is not null 
        
         set @qt_reservada = 0

         --Realiza as deduções afim de chegar na quantidade recebida até a menor data 
         --prevista que atenda a quantidade requisitada
         while ( @qtd_requisitada > 0 )
         begin
            Select top 1 
                @qtd_requisitada = @qtd_requisitada - qt_previsao,
                @cd_id = cd_id,
                @qt_reservada = @qt_reservada + qt_previsao
            from 
                @tmpPrevisao 
            where
                qt_previsao > 0
            order by 
                dt_previsao asc

            if ( @qtd_requisitada > 0 ) 
            begin
              
              update @tmpPrevisao 
              set
                 qt_previsao = 0
              where
                cd_id = @cd_id
            end
         end
        set @qtd_requisitada = @qt_reservada
   end
   else
     set @qtd_requisitada = 0

   RETURN(@qtd_requisitada)
END

