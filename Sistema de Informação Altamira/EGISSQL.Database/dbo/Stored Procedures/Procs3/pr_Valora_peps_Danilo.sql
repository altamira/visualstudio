create procedure pr_Valora_peps_Danilo
@Data_ini DateTime,
@Data_fim DateTime
as
set @Data_ini = '11/01/2003'
set @Data_fim = '11/01/2003' 

---------------------------------------------------------------
--    Recupera Valor de Custo da nota entrada peps para 
--    o Movimento Estoque de entrada
---------------------------------------------------------------

declare @cd_movimento_estoque int
declare @vl_custo_total_peps float

declare Notas cursor for
select nep.cd_movimento_estoque, nep.vl_custo_total_peps
from (movimento_estoque me
     join tipo_movimento_estoque tme
     on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
     and ic_mov_movimento = 'E')
     join nota_entrada_peps nep
     on nep.cd_movimento_estoque = me.cd_movimento_estoque
where me.dt_movimento_estoque between @Data_ini and @Data_fim


open Notas
FETCH NEXT FROM Notas into @cd_movimento_estoque, @vl_custo_total_peps

while @@FETCH_STATUS = 0
begin
      update movimento_estoque set vl_custo_contabil_produto = @vl_custo_total_peps
      where cd_movimento_estoque = @cd_movimento_estoque
      FETCH NEXT FROM Notas into @cd_movimento_estoque, @vl_custo_total_peps
end

Close Notas
Deallocate Notas

---------------------------------------------------------------------------------------
--  Ajusta Saldo de produto de entrada com a saida
---------------------------------------------------------------------------------------

declare @cd_Produto_Saida float
declare @cd_movimento_Saida float
declare @qt_movimento_Saida float
declare @Saldo  float
declare @vl_custo float
declare @ch_fim char(1)

create Table #Entrada
    (cd_produto int  null,
     Movinmento_entrada int primary key,
     qt_entrada float null, 
     vl_Movimento_entrada float null,
     qt_saida float null,
     Saldo float null)

declare Saidas cursor for 
select nep.cd_produto, 
       me.cd_movimento_estoque, 
       me.qt_movimento_estoque
from (movimento_estoque me
     join tipo_movimento_estoque tme
     on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
     and ic_mov_movimento = 'S')
     join nota_entrada_peps nep
     on nep.cd_movimento_estoque = me.cd_movimento_estoque
where me.dt_movimento_estoque between @Data_ini and @Data_fim


insert into #Entrada
select nep.cd_produto,
       me.cd_movimento_estoque, 
       me.qt_movimento_estoque, 
       vl_custo_contabil_produto, 
       0, 
       me.qt_movimento_estoque
from (movimento_estoque me
     join tipo_movimento_estoque tme
     on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
     and ic_mov_movimento = 'E')
     join nota_entrada_peps nep
     on nep.cd_movimento_estoque = me.cd_movimento_estoque
where me.dt_movimento_estoque between @Data_ini and @Data_fim

open Saidas

  FETCH NEXT FROM Saidas into @cd_Produto_Saida, @cd_movimento_Saida, @qt_movimento_Saida

while @@FETCH_STATUS = 0
begin
     declare CEntrada cursor for 
      Select Saldo, 
             vl_Movimento_entrada  
      from #Entrada 
      where cd_produto = @cd_Produto_Saida
     open CEntrada     


     set @ch_fim ='N'

     FETCH NEXT FROM CEntrada into @Saldo, @vl_custo
     while @ch_fim <> 'S' 
       begin
       if (@@FETCH_STATUS <> 0)  
          begin
                if @qt_movimento_Saida <= @Saldo 
                  begin
                          --passa valor de custo da entrada p/ a saída
                          update movimento_estoque 
                           set vl_custo_contabil_produto = @vl_custo
                         where cd_movimento_estoque = @cd_movimento_estoque
                          --Atualiza tabela temporária de Controle
                        update #Entrada 
                           set Saldo = Saldo - @qt_movimento_Saida,
                               qt_saida = qt_saida + @qt_movimento_Saida
                         where Movinmento_entrada = @cd_movimento_estoque 
                           and cd_Produto = @cd_Produto_Saida
                         set @ch_fim ='S'
                  end
                else
                 begin
                   if @Saldo = 0
                     begin
                        FETCH NEXT FROM CEntrada into @Saldo, @vl_custo
                     end
                   else  
                     begin
                         -- A Saída é maior que o saldo da entrada, provavelmente ocupando 
                         -- mais de uma entrada
                         -- esta situação não está definida
                         FETCH NEXT FROM CEntrada into @Saldo, @vl_custo
                     end
                 end
          end
        else 
          begin
              -- não foi encontrado o movimento de entrada 
              -- para esse caso ainda não foi definido um procedimento
              set @ch_fim ='S'  
          end
     end   
     Close CEntrada     
     Deallocate CEntrada     

     FETCH NEXT FROM Saidas into @cd_Produto_Saida, @cd_movimento_Saida, @vl_custo, @qt_movimento_Saida
end 
Select * from #Entrada

Close Saidas
deallocate Saidas

drop table #Entrada




