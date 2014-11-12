
-------------------------------------------------------------------------------  
--sp_helptext pr_gera_movimento_pedido_nextel
-------------------------------------------------------------------------------  
--pr_gera_movimento_pedido_nextel
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2008  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Cardoso Fernandes / Douglas Lopes  
--Banco de Dados   : Egissql  
--Objetivo         : Importação de pedidos de Venda NEXTEL.  
--  
--Data             : 26.07.2008  
--Alteração        : 11.08.2008
--                 : 03.09.2008 - Deixei a procedure mais rápida.  
-- 20.09.2008      : Ajustes Diversos - Douglas / Carlos
-- 23.09.2008      : Flag de Geração do Pedido - Carlos Fernandes
-- 24.09.2008      : Acerto do Código do Produto - Carlos Fernandes
-- 30.09.2008      : Ajustes Diversos - Carlos Fernandes
--                   Não Permitir Duplicidade de Pedidos - Carlos Fernandes
-- 18.11.2008 - Ajustes Diversos - Carlos Fernandes
-- 25.11.2008 - Quantidade / Unidade - Carlos Fernandes
-- 02.12.2008 - Ajustes Diversos - Carlos Fernandes
-- 06.01.2009 - Unidade/Caixa - Unidade de Medida - Ajustes - Carlos Fernandes
-- 22.01.2009 - Permite Pedido de Venda Cancelado - Carlos Fernandes
-- 10.02.2009 - Complemento dos Campos - Carlos Fernandes
-- 05.03.2009 - Ajuste da Condição de Pagamento - Carlos Fernandes
-- 22.03.2009 - Ajuste da Quantidade do Item do Pedido de Venda - Carlos Fernandes
-- 02.04.2009 - Unidade de Medida - Carlos Fernandes
-- 25.04.2009 - Checagem para não permitir duplicidade - Carlos Fernandes
-- 05.05.2009 - Condição de Pagamento - Carlos Fernandes
-- 26.03.2010 - Novos Campos do Pedido - Carlos Fernandes
------------------------------------------------------------------------------  
create procedure pr_gera_movimento_pedido_nextel
@cd_pedido_venda_entrada      varchar(8)  = '',  
@cd_cliente_entrada           varchar(8)  = '',  
@cd_vendedor_entrada          varchar(8)  = '',  
@cd_nota_saida                varchar(20) = '',  
@dt_pedido_venda_nextel       varchar(8)  = '',  
@qt_dia_pagamento             varchar(2)  = '',  
@cd_status_pedido_nextel      varchar(1)  = '',  
@cd_produto_entrada           varchar(8)  = '',  
@qt_item_pedido_entrada       varchar(8)  = '',  
@vl_item_total_pedido_entrada varchar(8)  = '',  
@cd_tabela_preco              varchar(1)  = '',  
@qt_itens_pedido_venda        varchar(8)  = ''  
  
as  

--Mostra os Dados de Entrada

-- select
--   @cd_pedido_venda_entrada,
--   @cd_cliente_entrada,
--   @cd_vendedor_entrada,
--   @cd_nota_saida,
--   @dt_pedido_venda_nextel,
--   @qt_dia_pagamento,
--   @cd_status_pedido_nextel,
--   @cd_produto_entrada,
--   @qt_item_pedido_entrada,
--   @vl_item_total_pedido_entrada,
--   @cd_tabela_preco,
--   @qt_itens_pedido_venda        


declare @cd_pedido_venda              int
declare @cd_cliente                   int
declare @cd_vendedor                  int
declare @cd_produto                   int
declare @qt_item_pedido_venda_nextel  float
declare @vl_item_total_pedido         float
declare @cd_vendedor_interno          int
declare @cd_condicao_pagamento        int
declare @cd_destinacao_produto        int
declare @cd_tabela                    int
declare @ic_cliente                   char(1) 
declare @ic_condicao_pagamento        char(1)
declare @cd_fase_produto              char(1)
declare @cd_mascara_produto           varchar(20)

set @cd_pedido_venda                  = cast(@cd_pedido_venda_entrada      as int )
set @cd_cliente                       = cast(@cd_cliente_entrada           as int )
set @cd_vendedor                      = cast(@cd_vendedor_entrada          as int )
set @cd_produto                       = cast(@cd_produto_entrada           as int )
set @qt_item_pedido_venda_nextel      = cast(@qt_item_pedido_entrada       as float )
set @vl_item_total_pedido             = cast(@vl_item_total_pedido_entrada as float )
set @ic_cliente                       = 'N'
set @ic_condicao_pagamento            = 'N'

--select @cd_produto

select
  @cd_produto         = isnull(p.cd_produto,0),
  @cd_mascara_produto = isnull(p.cd_mascara_produto,'')
from 
  Produto p                         with (nolock) 
  left outer join Status_Produto sp with (nolock) on sp.cd_status_produto = p.cd_status_produto

where
  isnull(sp.ic_bloqueia_uso_produto,'N')='N' and
  (cast(replace(isnull(p.cd_mascara_produto,'0'),'.','') as int) = @cd_produto ) 

--select @cd_produto,@cd_mascara_produto
--select @cd_pedido_venda

--Ajusta a Tabela de Preço

--Busca da Tabela de Preço Correto

-- select top 1
--   @cd_tabela = isnull(cd_tabela_preco,0) 
-- from
--   Tabela_Preco with (nolock) 
-- where
--   cast(cd_identificacao_tabela as varchar(1)) = @cd_tabela_preco 
-- 
-- --Tabela Correta
-- 
-- if @cd_tabela > 0 
-- begin
--   set @cd_tabela_preco = cast( @cd_tabela as varchar(1)) 
-- end

--select @cd_pedido_venda

--Atualiza dados do cadastro do Cliente

select
  @cd_vendedor_interno   = isnull(c.cd_vendedor_interno,0),
  @cd_condicao_pagamento = isnull(c.cd_condicao_pagamento,0),
  @cd_destinacao_produto = isnull(c.cd_destinacao_produto,0),
  @ic_cliente            = case when isnull(c.cd_cliente,0)>0 then 'S' else 'N' end 
from
  Cliente c with (nolock) 
where
  c.cd_cliente = @cd_cliente   

-- select
--   @cd_vendedor_interno,
--   @cd_condicao_pagamento,
--   @cd_destinacao_produto,
--   @ic_cliente
-- 

--Cliente não cadastrado

if @ic_cliente = 'N' 
begin
  set @cd_status_pedido_nextel = 2 --Cliente não Cadastrado !
end

declare @dt_entrega_pedido            datetime
declare @Tabela		              varchar(80)
declare @cd_controle                  int

set @cd_controle       = 0

--set @dt_entrega_pedido = getdate()

set @dt_entrega_pedido = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--   -- Nome da Tabela usada na geração e liberação de códigos
--   set @Tabela          = cast(DB_NAME()+'.dbo.Pedido_Venda_Nextel' as varchar(80))
-- 
--   exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda', @codigo = @cd_controle output
-- 	
--   while exists(Select top 1 'x' from pedido_venda_nextel where cd_controle = @cd_controle)
--   begin
--     exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_controle', @codigo = @cd_controle output
--     -- limpeza da tabela de código
--     exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle, 'D'
--   end

--Localiza a Condição de Pagamento Correta
--select * from condicao_pagamento

select
  @cd_condicao_pagamento = isnull(cp.cd_condicao_pagamento,@cd_condicao_pagamento),
  @ic_condicao_pagamento = case when isnull(cp.cd_condicao_pagamento,0)>0 then 'S' else 'N' end

from
  condicao_pagamento cp                     with (nolock) 
  inner join condicao_pagamento_parcela cpp with (nolock) on cpp.cd_condicao_pagamento = cp.cd_condicao_pagamento
where
  qt_dia_cond_parcela_pgto =  cast( isnull(@qt_dia_pagamento,0) as int) and
  qt_parcela_condicao_pgto = 1 --Somente Condições de 1 parcela

order by
  cp.cd_condicao_pagamento

-- select
--   @cd_condicao_pagamento,
--   @ic_condicao_pagamento


--Buscar do parâmetro futuramento

if @cd_condicao_pagamento = 0
begin
  set @cd_condicao_pagamento = 1 --A Vista
end

--select * from condicao_pagamento

if @ic_condicao_pagamento='N'
begin
  set @cd_status_pedido_nextel = 4 --Condição não Cadastrado !
end

--select * from condicao_pagamento_parcela

-- pedido_venda_nextel
 
select  
  @cd_pedido_venda                                   as cd_pedido_venda,  
  @cd_cliente                                        as cd_cliente,  
  @cd_vendedor                                       as cd_vendedor,  
  @cd_nota_saida                                     as cd_nota_saida,  
  cast(@dt_pedido_venda_nextel as datetime)          as dt_pedido_venda_nextel,  
  cast(isnull(@qt_dia_pagamento,'0') as int )        as qt_dia_pagamento,  
  cast(isnull(@cd_status_pedido_nextel,'0') as int ) as cd_status_pedido_nextel,  

--  cast(@cd_produto as int )                         as cd_produto,  

--   ( select top 1 isnull(p.cd_produto,0) from Produto p 
--     where
--      cast(replace(p.cd_mascara_produto,'.','') as int) = @cd_produto ) 

  p.cd_produto                                      as cd_produto,

  --Quantidade do Produto
  --Quantidade do Pedido de Venda
  -- 02.04.2009

  case when isnull(p.qt_multiplo_embalagem,0)>0 and
    @qt_item_pedido_venda_nextel>=p.qt_multiplo_embalagem 
  then
    cast( cast(@qt_item_pedido_venda_nextel/p.qt_multiplo_embalagem as int) as float)
  else
    @qt_item_pedido_venda_nextel
  end                                               as qt_item_pedido_venda_nextel,  

   --Valor Unitário do Item

  (@vl_item_total_pedido/100)

  *

  case when isnull(p.qt_multiplo_embalagem,0)>0 and @qt_item_pedido_venda_nextel>=p.qt_multiplo_embalagem
  then  
    isnull(p.qt_multiplo_embalagem,0)
  else
    1
  end                                               as vl_item_total_pedido,  

  cast(isnull(@cd_tabela_preco,'1') as int )        as cd_tabela_preco,  

  --select * from tabela_preco

  cast(@qt_itens_pedido_venda  as float)            as qt_itens_pedido_venda,  

  1                                                 as cd_usuario,  
  getdate()                                         as dt_usuario,  
  1                                                 as cd_item_pedido_venda,
  'N'                                               as ic_gerado_pedido_venda,
  @cd_condicao_pagamento                            as cd_condicao_pagamento,
  @cd_controle                                      as cd_controle,
  @cd_vendedor_interno                              as cd_vendedor_interno,
  @dt_entrega_pedido                                as dt_entrega_pedido, 
  @cd_destinacao_produto                            as cd_destinacao_produto,
  0.00                                              as qt_saldo_produto,
  null                                              as cd_tabela_preco_padrao,
  null                                              as vl_saldo_cliente,
  @cd_condicao_pagamento                            as cd_condicao_pedido,
  null                                              as qt_estoque_produto,

  --Unidade de Medida 
  --Modificar através de tabela de parâmetros
  --Carlos 02.04.2009 ** Temporário **

  case when isnull(p.qt_multiplo_embalagem,0)>0 and
    @qt_item_pedido_venda_nextel >= p.qt_multiplo_embalagem 
  then
    2                                               --Caixa
  else
    --p.cd_unidade_medida                             --Unidade de Medida
    15
  end                                               as cd_unidade_medida
 
into  
  #Pedido_venda_nextel  

from 
  Produto p                         with (nolock) 
  left outer join Status_Produto sp with (nolock) on sp.cd_status_produto = p.cd_status_produto

where
  isnull(sp.ic_bloqueia_uso_produto,'N')='N' and
  p.cd_mascara_produto = @cd_mascara_produto

  --(cast(replace(isnull(p.cd_mascara_produto,'0'),'.','') as int) = @cd_produto ) 

-- select
--   *
-- from
--   Produto p
-- where
--   (cast(replace(isnull(p.cd_mascara_produto,'0'),'.','') as int) = @cd_produto ) 
  
--select @cd_produto
--select * from status_produto  
--select * from produto order by cd_mascara_produto

--select qt_multiplo_embalagem,* from produto where cd_mascara_produto = '1731'

--select * from #pedido_venda_nextel

----------------------------------------------------------------------------------------------------------------------------------  

if not exists( select top 1 cd_pedido_venda 
               from
                 pedido_venda_nextel with (nolock) 
               where 
                 cd_pedido_venda             = @cd_pedido_venda and
                 cd_cliente                  = @cd_cliente      and
                 cd_vendedor                 = @cd_vendedor     and
                 cd_produto                  = @cd_produto      and
                 qt_item_pedido_venda_nextel = @qt_item_pedido_venda_nextel
             ) 
begin

-- select
--   @cd_pedido_venda,@cd_cliente,@cd_vendedor,@cd_produto,@qt_item_pedido_venda_nextel
-- 
-- select
--   *
-- from 
--   pedido_venda_nextel
--                where 
--                  cd_pedido_venda             = @cd_pedido_venda and
--                  cd_cliente                  = @cd_cliente      and
--                  cd_vendedor                 = @cd_vendedor     and
--                  cd_produto                  = @cd_produto      and
--                  qt_item_pedido_venda_nextel = @qt_item_pedido_venda_nextel
-- 
--   select * from #pedido_venda_nextel

  print 'Gerando entrada do registro do item do Pedido'
                  
  insert into  
    pedido_venda_nextel  
  select  
    *  
  from  
    #pedido_venda_nextel  

--  where
--    cd_pedido_venda
--  not in ( select cd_pedido_venda
--                              from #pedido_venda_nextel 
--                              where
--                                cd_pedido_venda             = @cd_pedido_venda and
--                                cd_cliente                  = @cd_cliente      and
--                                cd_vendedor                 = @cd_vendedor     and
--                                cd_produto                  = @cd_produto      and
--                                qt_item_pedido_venda_nextel = @qt_item_pedido_venda_nextel )
   
 
----------------------------------------------------------------------------------------------------------------------------------  
--Cria indice de todos os registro em uma tabela temporária.  
----------------------------------------------------------------------------------------------------------------------------------  

select   
  identity(int,1,1) as [id],  
  *  
into   
  #Pedido_venda_nextel2  
from  
  pedido_venda_nextel  with (nolock) 
where
  cd_pedido_venda = @cd_pedido_venda
order by  
  cd_pedido_venda   

--select * from #Pedido_Venda_Nextel2


-------------------------------------------------------------------------------------------------------------------------------------  
--Cria indice para o grupo cd_nota_saida e faz update na coluna cd_item_pedido_venda.  
-------------------------------------------------------------------------------------------------------------------------------------  

declare numerador cursor for

select
  [id],
  cd_pedido_venda 
from 
  #pedido_venda_nextel2 
where 
  cd_pedido_venda = @cd_pedido_venda 
order by 
  cd_pedido_venda  

open numerador -- Grava a select no cursor.
 
declare @id       int, 
        @cod      int, 
        @cod_ant  int, 
        @contador int -- Declara as variaveis.

set @contador = 1     -- Inicializa o contador.

fetch next from numerador into @id, @cod  

while (@@fetch_status<>-1) -- Percorre a select.
 begin
  
  set @cod_ant = @cod      -- Incrementa o código anterior com o valor atual. 

  update #pedido_venda_nextel2 
  set 
    cd_item_pedido_venda = @contador 
  where 
    [id]            = @id and 
    cd_pedido_venda = @cd_pedido_venda  --Faz update se os campos id e cd_pedido_venda forem iguais.

  fetch next from numerador into @id, @cod  

  if @cod <> @cod_ant   
   set @contador = 1             -- Verifica se o codigo anterior é diferente do atual. Se for inicializa o contador em 1.
  else  
   set @contador = @contador + 1 -- Acrescenta + 1 ao contado se o codigo anterior for igual ao atual.   

 end  

delete from pedido_venda_nextel 
where 
  cd_pedido_venda = @cd_pedido_venda  -- Deleta linhas da tabela principal.  

close      numerador -- Fecha o cursor. 
deallocate numerador -- Libera memória.  

-----------------------------------------------------------------------------------------------------
--Insere registros na tabela através da tabela temporária.  
-----------------------------------------------------------------------------------------------------

insert into    
  pedido_venda_nextel    
select    
  cd_pedido_venda,  
  cd_cliente,  
  cd_vendedor,  
  cd_nota_saida,  
  dt_pedido_venda_nextel,  
  qt_dia_pagamento,  
  cd_status_pedido_nextel,  
  cd_produto,  
  qt_item_pedido_venda_nextel,  
  vl_item_total_pedido,  
  cd_tabela_preco,  
  qt_itens_pedido_venda,  
  cd_usuario,  
  dt_usuario,  
  cd_item_pedido_venda,
  ic_gerado_pedido_venda,
  cd_condicao_pagamento,
  cd_controle,
  cd_vendedor_interno,
  dt_entrega_pedido, 
  cd_destinacao_produto,
  qt_saldo_produto,
  cd_tabela_preco_padrao,
  vl_saldo_cliente,
  cd_condicao_pedido,
  qt_estoque_produto,
  cd_unidade_medida
  
from    
  #pedido_venda_nextel2

where
  cd_pedido_venda = @cd_pedido_venda 

--   cd_pedido_venda not in ( select pvn.cd_pedido_venda 
--                            from pedido_venda_nextel pvn
--                            where
--                              pvn.cd_pedido_venda             = cd_pedido_venda and
--                              pvn.cd_cliente                  = cd_cliente      and
--                              pvn.cd_vendedor                 = cd_vendedor     and
--                              pvn.cd_produto                  = cd_produto      and
--                              pvn.qt_item_pedido_venda_nextel = qt_item_pedido_venda_nextel )
-- 
order by    
  cd_pedido_venda,
  cd_item_pedido_venda   


------------------------------------------------------------------------------------------------------------------------------------  
--Exclui tabela temporaria.---------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------  

Drop Table #pedido_venda_nextel2  

------------------------------------------------------------------------------------------------------------------------------------  

end

--select * from pedido_venda_nextel

