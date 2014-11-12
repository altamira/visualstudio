create procedure pr_valora_movimento_estoque_peps
@Data_ini DateTime,
@Data_fim DateTime,
@cd_produto_peps int,
@cd_fase_produto int = 0
as

---------------------------------------------------------------
--    Recupera Valor de Custo da nota entrada peps para 
--    o Movimento Estoque de entrada
---------------------------------------------------------------
print 'Grava no movimento de estoque o custo presente na nota entrada PEPS'
--declare @cd_movimento_estoque int
--declare @vl_custo_total_peps float

if IsNull(@cd_fase_produto,0) = 0
  select @cd_fase_produto = cd_fase_produto from parametro_comercial where cd_empresa = dbo.fn_empresa()

delete from movimento_estoque_composicao 
from movimento_estoque, movimento_estoque_composicao 
where movimento_estoque_composicao.cd_movimento_estoque = movimento_estoque.cd_movimento_estoque 
      and movimento_estoque.cd_produto = @cd_produto_peps

declare @cd_Produto_Saida float
declare @cd_movimento_Saida float
declare @qt_movimento_Saida float
declare @SaldoEntrada  float
declare @vl_custo float
declare @ch_fim int
declare @CEntrada_Row float
declare @CEntrada_Pos Int
declare @CEntrada_Sobra int
declare @ID_Entrada int
declare @cd_documento varchar(20)
declare @cd_item_documento int
declare @cd_movimento_estoque_entrada int
/******************************************************************
CODIGO IMPLEMENTADO APENAS PARA REALIZAR A VALORAÇÃO DE UM PRODUTO
*******************************************************************/

set nocount on

update movimento_estoque
set vl_custo_contabil_produto = vl_preco_entrada_peps
from
  movimento_estoque, nota_entrada_peps
where
  movimento_estoque.cd_movimento_estoque = nota_entrada_peps.cd_movimento_estoque


---------------------------------------------------------------------------------------
--  Ajusta Saldo de produto de entrada com a saida
---------------------------------------------------------------------------------------
print 'Ajusta Saldo de produto de entrada com a saida'


-- TABELA DE ENTRADAS
create Table #Entrada
    (
     ID int IDENTITY(1,1)  primary key,
     cd_produto float  null,
     qt_entrada float null, 
     vl_Movimento_entrada float null,
     qt_saida float null,
     Saldo float null, 
     Tipo char(3) null,
     Doc varchar(20) null,
     Item int null,
     CodMovimento int,
     Data_Entrada DateTime)

-- TABELA DE LOG
create table #Log
       (Movimento float,
        Produto  float,
        Mensagem VarChar(100))

-- TABELA DE SOBRA
create table #Sobra
      (produto Float,
       Movimento int,
       qt_tot_Movimento Float,
       qt_Na_Entrada Float,
       vl_Custo Float)

declare Saidas cursor for 
select me.cd_produto, 
       me.cd_movimento_estoque, 
       me.cd_documento_movimento,
       me.cd_item_documento,
       me.qt_movimento_estoque
from (movimento_estoque me
     join tipo_movimento_estoque tme
     on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
     and tme.ic_mov_tipo_movimento = 'S'
     and tme.ic_operacao_movto_estoque in ('A','R'))
where me.dt_movimento_estoque between @Data_ini and @Data_fim
and me.cd_fase_produto = @cd_fase_produto
and me.cd_produto = @cd_produto_peps
order by me.dt_movimento_estoque, me.cd_movimento_estoque

insert into #Entrada
(
     cd_produto,
     qt_entrada, 
     vl_Movimento_entrada,
     qt_saida,
     Saldo, 
     Tipo,
     Doc,
     Item,
     CodMovimento,
     Data_Entrada
)
select cd_produto,
       qt_entrada_peps, 
       vl_preco_entrada_peps, 
       0, --Quantidade de Saídas
       qt_entrada_peps, 
       'NEP',
       cd_documento_entrada_peps,
       cd_item_documento_entrada,
       cd_movimento_estoque,
       dt_documento_entrada_peps 
from 
       Nota_Entrada_Peps nep
where dt_documento_entrada_peps between @Data_ini and @Data_fim
      and cd_fase_produto = @cd_fase_produto
      and nep.cd_produto = @cd_produto_peps
order by dt_documento_entrada_peps, cd_movimento_estoque

--Notas de entrada por cancelamento e devolução
insert into #Entrada
(
     cd_produto,
     qt_entrada, 
     vl_Movimento_entrada,
     qt_saida,
     Saldo, 
     Tipo,
     Doc,
     Item,
     CodMovimento,
     Data_Entrada
)
select mee.cd_produto,
       mee.qt_movimento_estoque, 
       me.vl_custo_contabil_produto,
       0, --Quantidade de Saídas
       mee.qt_movimento_estoque, 
       'C/D',
       mee.cd_documento_movimento,
       mee.cd_item_documento,
       mee.cd_movimento_estoque,
       mee.dt_movimento_estoque
from movimento_estoque mee
     inner join (movimento_estoque me
     join tipo_movimento_estoque tme
     on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
     and tme.ic_mov_tipo_movimento = 'S'
     and tme.ic_operacao_movto_estoque in ('A','R'))
     on mee.cd_documento_movimento = me.cd_documento_movimento
     and mee.cd_item_documento = me.cd_item_documento
     and mee.cd_tipo_movimento_estoque in (12, 10) -- 12 - Cancelado, 10 -Devolução
     and me.cd_tipo_movimento_estoque = 11 -- Saída
where 
      me.dt_movimento_estoque between @Data_ini and @Data_fim 
      and mee.cd_fase_produto = @cd_fase_produto
      and mee.cd_produto = @cd_produto_peps
order by me.dt_movimento_estoque, me.cd_movimento_estoque

print 'Abre o cursor das notas de saída para abater das entradas'

open Saidas

FETCH NEXT FROM Saidas into @cd_Produto_Saida, @cd_movimento_Saida, @cd_documento, @cd_item_documento, @qt_movimento_Saida

while @@FETCH_STATUS = 0
begin

     declare CEntrada cursor for 
     Select 
	     ID,
	     Saldo, 
             vl_Movimento_entrada,
             CodMovimento
     from 
	     #Entrada 
     where 
	     cd_produto = @cd_Produto_Saida
             and saldo > 0
     order by Data_Entrada, ID
     
     open CEntrada     
     set @ch_fim = 0

     FETCH NEXT FROM CEntrada into @ID_Entrada, @SaldoEntrada, @vl_custo, @cd_movimento_estoque_entrada

     set @CEntrada_Sobra = 0

     while @ch_fim = 0 --Chave do Loop para sair diretamente
     begin

       if (@@FETCH_STATUS = 0)  
       begin
        if @qt_movimento_Saida <= @SaldoEntrada 
        begin      

          set @ch_fim = 1

	  --passa valor de custo da entrada p/ a saída
          update 
		movimento_estoque 
          set 
	        vl_custo_contabil_produto = @vl_custo,
		cd_movimento_estoque_origem = @cd_movimento_estoque_entrada
          where 
		cd_movimento_estoque = @cd_movimento_Saida

           --Atualiza na nota de devolução ou cancelamento com valor da saída
	   update 
		movimento_estoque
	   set
	   	vl_custo_contabil_produto = @vl_custo
           where 
		cd_documento_movimento = @cd_documento and
		cd_item_documento = @cd_item_documento and
     		cd_tipo_movimento_estoque in (12, 10) -- 12 - Cancelado, 10 -Devolução

	   update 
		#Entrada
	   set
	   	vl_Movimento_entrada = @vl_custo
           where 
		Doc = @cd_documento and
		Item = @cd_item_documento and
     		Tipo = 'C/D'

          --Atualiza tabela temporária de Controle
          update 
	    #Entrada 
          set 
            Saldo = Saldo - @qt_movimento_Saida,
            qt_saida = qt_saida + @qt_movimento_Saida
          where 
	    ID = @ID_Entrada 
            and cd_Produto = @cd_Produto_Saida

          -- grava as informaçoes na tabela #Sobras
          if (@CEntrada_Sobra = 1)
          begin
            print '@cd_movimento_estoque - A'
	    print @cd_movimento_Saida

             insert into #Sobra values
                         (@cd_Produto_Saida,
                          @cd_movimento_Saida,
                          @qt_movimento_Saida,
                          (@SaldoEntrada - @qt_movimento_Saida),
                          @vl_custo)
                          set @CEntrada_Sobra = 0

	    insert into Movimento_Estoque_Composicao
		( cd_movimento_estoque, 
		  cd_item_movimento_estoque,
		  qt_movimento_estoque_comp,
		  vl_custo_mov_estoque_comp )
		values
		( @cd_movimento_Saida, 
		  @cd_movimento_estoque_entrada,
		  @qt_movimento_Saida,
		  @vl_custo )		
          end
        end
        else
        begin
          if @SaldoEntrada > 0
          begin
            -- A Saída é maior que o saldo da entrada, provavelmente ocupando mais de uma entrada
            -- abate até zerar o movimento atual
            update 
		#Entrada 
            set 
		Saldo = 0,
                qt_saida = qt_saida + @qt_movimento_Saida
            where 
		ID = @ID_Entrada 
                and cd_Produto = @cd_Produto_Saida           

           --Atualiza na nota de devolução ou cancelamento com valor da saída
	   update 
		movimento_estoque
	   set
	   	vl_custo_contabil_produto = @vl_custo,
                cd_movimento_estoque_origem = @cd_movimento_estoque_entrada
           where 
		cd_documento_movimento = @cd_documento and
		cd_item_documento = @cd_item_documento and
     		cd_tipo_movimento_estoque in (12, 10) -- 12 - Cancelado, 10 -Devolução

	   update 
		#Entrada
	   set
	   	vl_Movimento_entrada = @vl_custo
           where 
		Doc = @cd_documento and
		Item = @cd_item_documento and
     		Tipo = 'C/D'
    	
            insert into #Sobra values
                       (@cd_Produto_Saida,
                        @cd_movimento_Saida,
                        @SaldoEntrada,
                        @SaldoEntrada,
                        @vl_custo)


		insert into Movimento_Estoque_Composicao
		( cd_movimento_estoque, 
		  cd_item_movimento_estoque,
		  qt_movimento_estoque_comp,
		  vl_custo_mov_estoque_comp )
		values
		( @cd_movimento_Saida, 
		  @cd_movimento_estoque_entrada,
		  @SaldoEntrada,
		  @vl_custo )		

             -- lê o próximo movimento
             set @CEntrada_Sobra = 1

	     set @qt_movimento_Saida = @qt_movimento_Saida - @SaldoEntrada
	     set @SaldoEntrada = 0
		 
             --FETCH NEXT FROM CEntrada into @ID_Entrada, @SaldoEntrada, @vl_custo
          end
        end
       end
       else 
       begin
         set @ch_fim = 1
         -- Movimento sem entrada
         insert into #Log values (@cd_movimento_Saida, @cd_Produto_Saida, 'Não havia entrada para este movimento de saída')
         
       end
       FETCH NEXT FROM CEntrada into @ID_Entrada, @SaldoEntrada, @vl_custo, @cd_movimento_estoque_entrada
     end   

     Close CEntrada     
     Deallocate CEntrada     
     FETCH NEXT FROM Saidas into @cd_Produto_Saida, @cd_movimento_Saida, @cd_documento, @cd_item_documento, @qt_movimento_Saida
end 

print 'Step 4'

/*-------------------*/
/*-- tratar sobras --*/
/*-------------------*/

Declare @Prod Float
Declare @Movimento int 
Declare @Media Float

declare CSobra cursor for 
Select
  produto, Movimento, (sum(vl_Custo * qt_tot_Movimento) / sum(qt_tot_Movimento)) as 'Media'
from #Sobra
group by produto, Movimento


open CSobra
fetch next from CSobra into @Prod, @Movimento, @Media

while @@FETCH_STATUS = 0
    begin 
           
           update movimento_estoque 
              set vl_custo_contabil_produto = @Media
             where cd_movimento_estoque = @Movimento
           fetch next from CSobra into @Prod, @Movimento, @Media
    end


Close CSobra
deallocate CSobra
Close Saidas
deallocate Saidas


drop table #Entrada
drop table #Sobra
select * from #Log 
drop table #Log

set nocount off

