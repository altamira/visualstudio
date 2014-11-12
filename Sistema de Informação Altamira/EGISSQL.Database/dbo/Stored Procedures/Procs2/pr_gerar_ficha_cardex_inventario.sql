
CREATE  PROCEDURE pr_gerar_ficha_cardex_inventario
@nm_tabela_anterior varchar(100) = '',
@dt_inicial datetime,
@dt_final datetime,
@cd_produto int
AS

--pr_gerar_ficha_cardex_inventario
-------------------------------------------------------------------------------
--GBS - Global Business Solution        2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Fabio Cesar
--Banco de Dados: EgisSQL
--Objetivo      : Gera a ficha cardex com valoração PEPS, já atualizando o custo contabil da movimentação.
--Data          : 02.06.2003
-------------------------------------------------------------------------------

declare
@cd_movimento_estoque_saida int,
@qt_movimento_estoque_saida float,
@cd_movimento_estoque_entrada int,
@qt_movimento_estoque_entrada float,
@cd_documento_movimento varchar(30),
@cd_item_documento int,
@cd_movimento_estoque int,
@continua int,
@vl_custo_contabil float,
@cd_fase_produto int,
@qt_movimento_saida float,
@cd_documento_movimento_saida varchar(100),
@cd_item_documento_saida int,
@cd_documento_movimento_entrada varchar(100),
@dt_entrada_movimento datetime,
@cd_tipo_movimento_estoque_entrada int,
@cd_tipo_documento_estoque_entrada int



set @qt_movimento_estoque_saida = 0
set @cd_movimento_estoque = 0

  select 
    me.cd_produto,
    p.nm_fantasia_produto,
    me.cd_movimento_estoque, 
    me.dt_movimento_estoque,
    me.cd_documento_movimento,
    me.cd_item_documento,
    me.nm_di,
    me.nm_invoice,
    me.vl_custo_contabil_produto,
    0 as 'Saldo_Inicial',
    case when tme.ic_mov_tipo_movimento = 'E'
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Entrada',
    case 
      when ic_mov_tipo_movimento = 'S' 
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Saida',
    cast(0.00 as float) as Saldo,
    me.cd_tipo_documento_estoque,
me.cd_tipo_movimento_estoque,
        me.cd_fase_produto
  into
    #Movimento_Estoque
  from 
    Movimento_Estoque me
      left outer join 
    Tipo_Movimento_Estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      Left Outer Join
    Tipo_documento_estoque tde
      on me.cd_tipo_documento_estoque = tde.cd_tipo_documento_estoque
      Left Outer Join
    Tipo_Destinatario td
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario
      Left Outer Join
    Produto p
      on me.cd_produto = p.cd_produto
  where 
    (me.cd_produto = @cd_produto) and 
    (tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto') and
    me.dt_movimento_estoque between @dt_inicial and @dt_final
  order by 
    me.dt_movimento_estoque, 
    me.cd_movimento_estoque

--Gera o cardex das entradas
select 
* 
into
#Movimento_Estoque_Entrada
from 
#Movimento_Estoque
where 
Entrada > 0
order by dt_movimento_estoque, cd_movimento_estoque

truncate table Kardex_Inventario_Anterior_Process

--Grava mês anterior caso tenha sido informada
    if IsNull(@nm_tabela_anterior,'') <> ''
begin
exec ('
Insert into 
Kardex_Inventario_Anterior_Process
Select * from  
' + @nm_tabela_anterior + '
where 
(Entrada - Saida)> 0
and cd_produto = ' + @cd_produto + ' 
and cd_tipo_documento_estoque <> 7')

end
Insert into
#Movimento_Estoque_Entrada
Select * from
Kardex_Inventario_Anterior_Process

--Gera a tabela de saídas
select 
* 
into
#Movimento_Estoque_Saida
from 
#Movimento_Estoque
where 
Saida > 0
order by
dt_movimento_estoque, cd_movimento_estoque

    --Realiza a valoração de todas as entradas provenientes de ajuste em função da última entrada realizada
declare cCursorEntrada cursor for   
  Select
cd_movimento_estoque,
dt_movimento_estoque,
cd_tipo_movimento_estoque,
cd_tipo_documento_estoque
  from
#Movimento_Estoque_Entrada

open cCursorEntrada

fetch next from cCursorEntrada into @cd_movimento_estoque_entrada, @dt_entrada_movimento, @cd_tipo_movimento_estoque_entrada, @cd_tipo_documento_estoque_entrada
    while (@@FETCH_STATUS =0)
begin
if (@cd_tipo_movimento_estoque_entrada  in (1,7))
and 
(@cd_tipo_documento_estoque_entrada in (1,5,8,9)) 
begin
--Atualiza o valor do custo do ajuste
  select 
    top 1 @vl_custo_contabil = cast(IsNull(me.vl_custo_contabil_produto,0) as numeric(18,4))
  from 
    Movimento_Estoque me
      left outer join 
    Tipo_Movimento_Estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      Left Outer Join
    Tipo_documento_estoque tde
      on me.cd_tipo_documento_estoque = tde.cd_tipo_documento_estoque
      Left Outer Join
    Tipo_Destinatario td
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario
      Left Outer Join
    Produto p
      on me.cd_produto = p.cd_produto
  where 
    (me.cd_produto = @cd_produto) and 
    (tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto') and
    tme.ic_mov_tipo_movimento = 'E' and
cd_movimento_estoque <> @cd_movimento_estoque_entrada and
dt_movimento_estoque <= @dt_entrada_movimento
order by dt_movimento_estoque desc, cd_movimento_estoque asc

if exists(select 
    'x'
  from 
     Movimento_Estoque me
      left outer join 
     Tipo_Movimento_Estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      Left Outer Join
     Tipo_documento_estoque tde
      on me.cd_tipo_documento_estoque = tde.cd_tipo_documento_estoque
      Left Outer Join
     Tipo_Destinatario td
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario
      Left Outer Join
     Produto p
      on me.cd_produto = p.cd_produto
     where 
     (me.cd_produto = @cd_produto) and 
     (tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto') and
     tme.ic_mov_tipo_movimento = 'E' and
cd_movimento_estoque <> @cd_movimento_estoque_entrada and
dt_movimento_estoque <= @dt_entrada_movimento)
begin
update
#Movimento_estoque_entrada
set
vl_custo_contabil_produto = @vl_custo_contabil
where
cd_movimento_estoque = @cd_movimento_estoque_entrada

update
Movimento_Estoque
set
vl_custo_contabil_produto = @vl_custo_contabil
where
cd_movimento_estoque = @cd_movimento_estoque_entrada 
end
end
fetch next from cCursorEntrada into @cd_movimento_estoque_entrada, @dt_entrada_movimento, @cd_tipo_movimento_estoque_entrada, @cd_tipo_documento_estoque_entrada
    end
close cCursorEntrada
deallocate cCursorEntrada


declare cCursor cursor for   
  Select
    cd_movimento_estoque,
      saida,
      cd_fase_produto,
cd_documento_movimento,
cd_item_documento
  From
    #Movimento_Estoque_Saida
  Order By
    dt_movimento_estoque
        
  open cCursor
  set @qt_movimento_estoque_saida = 0

  fetch next from cCursor into @cd_movimento_estoque, @qt_movimento_estoque_saida, @cd_fase_produto, @cd_documento_movimento_saida, @cd_item_documento_saida

  set @continua = 1
      set @cd_movimento_estoque_saida = @cd_movimento_estoque
      set @qt_movimento_saida = @qt_movimento_estoque_saida
       
  while (@@FETCH_STATUS =0)
  begin
  if not exists(Select 'x' from #Movimento_Estoque_Entrada where (Entrada - Saida) > 0 and cd_fase_produto = @cd_fase_produto) 
    set @continua = 0
      else
set @continua = 1

  --Caso não tiver estoque pula o processo
  if @continua <> 0 
  begin
      --Guarda a quantidade do primeiro movimento de entrada disponível          
      Select 
  top 1 @cd_movimento_estoque_entrada = cd_movimento_estoque,
  @qt_movimento_estoque_entrada = (Entrada - Saida) 
      from 
  #Movimento_Estoque_Entrada 
      where 
        (Entrada - Saida) > 0
and cd_fase_produto = @cd_fase_produto
      order by 
dt_movimento_estoque asc, cd_movimento_estoque asc

        --Verifica se a quantidade informada de saída é inferior a quantiadade de entrada remanecente
        if (@qt_movimento_estoque_saida <= @qt_movimento_estoque_entrada)
        begin
            Update 
    #Movimento_estoque_entrada
    set
          Saida = Saida + @qt_movimento_estoque_saida
        where
          cd_movimento_estoque = @cd_movimento_estoque_entrada

--Obtendo o valor do custo contábil
        set @vl_custo_contabil = 0

        select 
          top 1 @vl_custo_contabil = cast(IsNull(vl_custo_contabil_produto,0) as numeric(18,4))
        from
          #Movimento_estoque_entrada
        where
          cd_movimento_estoque = @cd_movimento_estoque_entrada 

        Update 
          #Movimento_estoque_saida
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_movimento_estoque = @cd_movimento_estoque

--Atualiza as entradas por Cancelamento e Devolução
Update 
          #Movimento_estoque_Entrada
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_saida 
and cd_item_documento = @cd_item_documento_saida
and cd_movimento_estoque <> @cd_movimento_estoque_entrada

--Atualiza o movimento de estoque para as futuras entradas que não ocorreram no mesmo mês
Update 
          Movimento_estoque
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_saida 
and cd_item_documento = @cd_item_documento_saida
and cd_movimento_estoque <> @cd_movimento_estoque_entrada


--Atualiza a Nota de Retorno com o Valor da Nota de Saída
Select @cd_documento_movimento_entrada = cd_nota_saida from Nota_Saida where cast(cd_nota_fiscal_origem as varchar(20)) = @cd_documento_movimento_saida

Update 
          #Movimento_estoque_Entrada
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_entrada
and 
cd_produto = @cd_produto
and
cd_tipo_documento_estoque = 3 --Nota de Entrada
and
IsNull(vl_custo_contabil_produto,0) = 0

Update 
          Movimento_estoque
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_entrada
and 
cd_produto = @cd_produto
and
cd_tipo_documento_estoque = 3 --Nota de Entrada
and
IsNull(vl_custo_contabil_produto,0) = 0

     --Deduz valor
            set @qt_movimento_estoque_saida = 0
         end
else
begin   
   Update 
#Movimento_estoque_entrada
   set
Saida = Entrada
   where
cd_movimento_estoque = @cd_movimento_estoque_entrada
   
   --Define o custo contábil da tabela de saída
   set @vl_custo_contabil = 0

   select 
top 1 @vl_custo_contabil = cast(IsNull(vl_custo_contabil_produto,0) as numeric(18,4))
   from
#Movimento_estoque_entrada
   where
cd_movimento_estoque = @cd_movimento_estoque_entrada 

   --Grava o custo contábil da entrada na saída
   Update 
#Movimento_estoque_saida
   set
vl_custo_contabil_produto = @vl_custo_contabil
   where
cd_movimento_estoque = @cd_movimento_estoque

--Armazena no movimento de estoque caso esse não possua já um valor
Update 
Movimento_Estoque
   set
vl_custo_contabil_produto = @vl_custo_contabil
   where
cd_movimento_estoque = @cd_movimento_estoque
and
IsNull(vl_custo_contabil_produto,0) = 0

Update 
          #Movimento_estoque_Entrada
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_saida 
and cd_item_documento = @cd_item_documento_saida
and cd_movimento_estoque <> @cd_movimento_estoque_entrada
and cd_tipo_documento_estoque <> 7 --Pedido de Venda

--Atualiza o movimento de estoque para as futuras entradas que não ocorreram no mesmo mês
Update 
          Movimento_estoque
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_saida 
and cd_item_documento = @cd_item_documento_saida
and cd_movimento_estoque <> @cd_movimento_estoque_entrada
and cd_tipo_documento_estoque <> 7 --Pedido de Venda

--Atualiza a Nota de Retorno com o Valor da Nota de Saída
Select @cd_documento_movimento_entrada = cd_nota_saida from Nota_Saida where cast(cd_nota_fiscal_origem as varchar(20)) = @cd_documento_movimento_saida

Update 
          #Movimento_estoque_Entrada
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_entrada
and 
cd_produto = @cd_produto
and
cd_tipo_documento_estoque = 3 --Nota de Entrada
and
IsNull(vl_custo_contabil_produto,0) = 0

Update 
          Movimento_estoque
        set
          vl_custo_contabil_produto = @vl_custo_contabil
    where
    cd_documento_movimento = @cd_documento_movimento_entrada
and 
cd_produto = @cd_produto
and
cd_tipo_documento_estoque = 3 --Nota de Entrada
and
IsNull(vl_custo_contabil_produto,0) = 0


       --Deduz valor
   set @qt_movimento_estoque_saida = @qt_movimento_estoque_saida - @qt_movimento_estoque_entrada
         end
end
else
    set @qt_movimento_estoque_saida = 0
   if Isnull(@qt_movimento_estoque_saida,0) <= 0
begin
   fetch next from cCursor into @cd_movimento_estoque, @qt_movimento_estoque_saida, @cd_fase_produto, @cd_documento_movimento_saida, @cd_item_documento_saida
end
end
Close cCursor
deallocate cCursor

Insert into 
Kardex_Inventario_Process
Select * from
#Movimento_estoque_entrada
where
(Entrada - Saida) > 0

