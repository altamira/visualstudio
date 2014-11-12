
-------------------------------------------------------------------------------  
--sp_helptext pr_gera_movimento_pedido_mercador
-------------------------------------------------------------------------------  
--pr_gera_movimento_pedido_mercador
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2008  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Cardoso Fernandes  
--Banco de Dados   : Egissql  
--Objetivo         : Importação de pedidos de Venda MERCADOR
--  
--Data             : 26.07.2008  
--Alteração        : 11.08.2008
--                 : 03.09.2008 - Deixei a procedure mais rápida.  
-- 20.09.2008      : Ajustes Diversos - Douglas / Carlos
-- 23.09.2008      : Flag de Geração do Pedido - Carlos Fernandes
-- 24.09.2008      : Acerto do Código do Produto - Carlos Fernandes
-- 10.11.2008      : Ajuste da Data do Pedido de Venda - Carlos Fernandes
-- 19.01.2009      : Complemento dos Campos - Carlos Fernandes
-- 27.01.2009      : Verificação - Carlos Fernandes
-- 02.02.2009      : Consistências - Carlos Fernandes
-- 02.04.2009      : Unidade de Medida - Carlos Fernandes
-- 19.11.2009      : Novos campos no cadastro do pedido - Carlos Fernandes
-- 17.02.2010      : Consistências - Carlos Fernandes
-- 18.09.2010      : Novos campos no cadastro do pedido - Carlos Fernandes
-- 22.12.2010      : Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------  
create procedure pr_gera_movimento_pedido_mercador
@tipo_registro                char(02)     = '',
@linha1                       varchar(200) = '',
@linha2                       varchar(200) = ''

--@linha3                       varchar(100) = '',
--@linha4                       varchar(100) = ''
  
as  

declare @linha                    varchar(800)
declare @cd_tipo_registro         char(02)
declare @cd_pedido_venda          int
declare @dt_pedido_venda          datetime
declare @cd_cliente               int
declare @cd_vendedor              int
declare @cd_vendedor_interno      int
declare @qt_dia_pagamento         int
declare @cd_status_pedido         int
declare @qt_item_pedido_venda     float
declare @vl_item_total_pedido     float
declare @qt_itens_pedido_venda    int
declare @cd_nota_saida            int
declare @cd_produto               int
declare @cd_tabela_preco          int
declare @cd_condicao_pagamento    int
declare @cd_controle              int
declare @cd_item_pedido_venda     int
declare @dt_entrega_pedido        datetime
declare @qt_multiplo_embalagem    float
declare @dt_hoje                  smalldatetime
declare @cd_destinacao_produto    int
declare @qt_saldo_produto         float
declare @cd_tabela_preco_padrao   int
declare @vl_saldo_cliente         float
declare @cd_condicao_pedido       int
declare @cd_fase_produto          int
declare @qt_saldo_reserva_produto float


set @dt_hoje  = getdate()
set @dt_hoje  = convert(datetime,left(convert(varchar,@dt_hoje,121),10)+' 00:00:00',121)

set @linha   = @tipo_registro + @linha1 + @linha2

set @cd_tipo_registro         = substring(@tipo_registro,1,2)
set @cd_status_pedido         = 0
set @cd_fase_produto          = 0
set @qt_saldo_reserva_produto = 0

--Fase do Produto

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  Parametro_Comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()


--pedido_venda_Item

--select @cd_tipo_registro

if @cd_tipo_registro = '01' --Cabeçalho
begin

  declare @Tabela		     varchar(80)

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela          = cast(DB_NAME()+'.dbo.Pedido_Venda_Nextel' as varchar(80))
  set @cd_controle = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_venda', @codigo = @cd_controle output
	
  while exists(Select top 1 'x' from pedido_venda_nextel where cd_controle = @cd_controle)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_controle', @codigo = @cd_controle output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_controle, 'D'
  end

    
  set @cd_pedido_venda   = cast( substring(@linha,9,20) as int )  
  set @dt_pedido_venda   = convert(datetime,@dt_hoje,103 )
  set @dt_entrega_pedido = @dt_hoje

  --set @dt_pedido_venda   = convert(varchar, @dt_hoje - Convert(varchar, @dt_hoje,114),101)

  set @dt_entrega_pedido = cast( substring(@linha,79,2)+'/'+substring(@linha,77,2)+'/'+substring(@linha,73,4) as datetime )
  set @dt_entrega_pedido = convert(datetime,left(convert(varchar,@dt_entrega_pedido,121),10)+' 00:00:00',121)

  --set @dt_entrega_pedido = @dt_hoje

  if @dt_entrega_pedido is null
  begin
     set @dt_entrega_pedido = @dt_hoje
  end

  --select @dt_hoje
  --select @dt_pedido_venda,@dt_entrega_pedido

  select
    @cd_cliente              = isnull(c.cd_cliente,0),
    @cd_vendedor             = isnull(c.cd_vendedor,0),
    @cd_vendedor_interno     = isnull(c.cd_vendedor_interno  ,0),
    @cd_condicao_pagamento   = isnull(c.cd_condicao_pagamento,0),
    @cd_destinacao_produto   = isnull(c.cd_destinacao_produto,0)

  from
    cliente c                         with (nolock)
    left outer join status_cliente sc with (nolock) on sc.cd_status_cliente = c.cd_status_cliente
  where
    c.cd_cnpj_cliente = cast( substring(@linha,209,14) as varchar(18)) 
    --and isnull(sc.ic_operacao_status_cliente,'S')='S'

--select * from status_cliente

--select 
--  select substring(@linha,209,14)

  set @cd_nota_saida   = 0

  --pedido_venda_nextel
 
  select  
    cast(@cd_pedido_venda as int )                    as cd_pedido_venda,  
    @cd_cliente                                       as cd_cliente,  
    @cd_vendedor                                      as cd_vendedor,  
    @cd_nota_saida                                    as cd_nota_saida,  
    @dt_pedido_venda                                  as dt_pedido_venda_nextel,  
    @qt_dia_pagamento                                 as qt_dia_pagamento,  
    cast(@cd_status_pedido as int )                   as cd_status_pedido_nextel,  
    @cd_produto                                       as cd_produto,
    cast(@qt_item_pedido_venda as float )             as qt_item_pedido_venda_nextel,  
    cast(@vl_item_total_pedido as float)              as vl_item_total_pedido,  
    cast(@cd_tabela_preco as int )                    as cd_tabela_preco,  
    cast(@qt_itens_pedido_venda as float)             as qt_itens_pedido_venda,  
    1                                                 as cd_usuario,  
    getdate()                                         as dt_usuario,  
    1                                                 as cd_item_pedido_venda,
    'N'                                               as ic_gerado_pedido_venda,
    @cd_condicao_pagamento                            as cd_condicao_pagamento,
    @cd_controle                                      as cd_controle,
    @cd_vendedor_interno                              as cd_vendedor_interno,
    @dt_entrega_pedido                                as dt_entrega_pedido, 
    @cd_destinacao_produto                            as cd_destinacao_produto,
    null                                              as qt_saldo_produto,
    null                                              as cd_tabela_preco_padrao,
    null                                              as vl_saldo_cliente,
    null                                              as cd_condicao_pedido,
    null                                              as qt_estoque_produto,
    null                                              as cd_unidade_medida

into  
  #Pedido_venda

-- from
--   Pedido_Venda_Nextel
-- 
-- where
--   cd_pedido_venda not in ( select isnull(cd_pedido_venda,0) as cd_pedido_venda from Pedido_Venda_Nextel 
--                            where
--                              cd_pedido_venda = cast(@cd_pedido_venda as int ) )


--select * from #pedido_venda


--Verifica se exista pedido de venda


if @cd_pedido_venda>0
begin

  insert into    
    pedido_venda_nextel    
  select    
    *
  from
    #pedido_venda
  where
    cd_pedido_venda is not null 
    
end

drop table #pedido_venda

end

--Registro 02

if @cd_tipo_registro = '02' --Pagamento
begin

  --busca o código do último pedido

  select
    @cd_controle = max(cd_controle)
  from
    pedido_venda_nextel with (nolock) 
  
  set @qt_dia_pagamento = substring( @linha, 15,3 )
  
  select
    @cd_condicao_pedido = isnull(cd_condicao_pagamento,0)
  from
    Condicao_Pagamento_Parcela
  where
    qt_dia_cond_parcela_pgto = @qt_dia_pagamento and
    pc_condicao_parcela_pgto = 100

--select * from condicao_pagamento
--select * from condicao_pagamento_parcela
--select * from status_pedido_nextel

  --Atualização do Pedido de Venda

  update
    pedido_venda_nextel
  set
    qt_dia_pagamento        = @qt_dia_pagamento,
    cd_condicao_pedido      = @cd_condicao_pedido
    
  from
    pedido_venda_nextel
  where
    cd_controle = @cd_controle

  --Atualiza o Status do Pedido de Venda

  set @cd_status_pedido = case when @cd_condicao_pagamento<>@cd_condicao_pedido then 4 else @cd_status_pedido end


end


-----------------------------------------------------------------------
--Registro 04 = Itens do Pedido
-----------------------------------------------------------------------
--select * from status_produto

if @cd_tipo_registro = '04' 
begin

  --busca o código do último pedido
  select
    @cd_controle = max(cd_controle)
  from
    pedido_venda_nextel with (nolock) 

  select
    @cd_pedido_venda        = cd_pedido_venda,
    @cd_cliente             = cd_cliente,
    @cd_vendedor            = cd_vendedor,
    @cd_vendedor_interno    = cd_vendedor_interno, 
    @cd_nota_saida          = cd_nota_saida,
    @dt_pedido_venda        = dt_pedido_venda_nextel,
    @qt_dia_pagamento       = qt_dia_pagamento,
    @cd_status_pedido       = isnull(cd_status_pedido_nextel,@cd_status_pedido),
    @cd_condicao_pagamento  = cd_condicao_pagamento,
    @cd_item_pedido_venda   = cast( substring(@linha,3,4) as int ),       
    @qt_item_pedido_venda   = cast( substring(@linha,100,15) as float ) / 100,
    @vl_item_total_pedido   = cast( substring(@linha,183,15) as float ) / 100,
    @dt_entrega_pedido      = dt_entrega_pedido,
    @cd_destinacao_produto  = cd_destinacao_produto,
    @qt_saldo_produto       = qt_saldo_produto,
    @cd_tabela_preco_padrao = cd_tabela_preco_padrao,
    @vl_saldo_cliente       = vl_saldo_cliente
    
  from
    pedido_venda_nextel with (nolock) 
  where
    cd_controle = @cd_controle
 
  select
    @cd_produto               = p.cd_produto,
    @qt_multiplo_embalagem    = case when isnull(qt_multiplo_embalagem,0)>0    then isnull(qt_multiplo_embalagem,0) else 1                 end,
    @cd_status_pedido         = case when isnull(sp.ic_permitir_venda,'N')='N' then 1                               else @cd_status_pedido end,
    @qt_saldo_reserva_produto = isnull(ps.qt_saldo_reserva_produto,0)
  from
    Produto p                         with (nolock)  
    left outer join status_produto sp on sp.cd_status_produto = p.cd_status_produto
    left outer join produto_saldo  ps on ps.cd_produto        = p.cd_produto and
                                         ps.cd_fase_produto   = case when isnull(p.cd_fase_produto_baixa,0)>0 then
                                                                  p.cd_fase_produto_baixa else @cd_fase_produto
                                                                end

  where
    p.cd_codigo_barra_produto = substring(@linha,19,13)

--select qt_multiplo_embalagem,* from produto where cd_mascara_produto = 'S93'

  select  
    @cd_pedido_venda                                             as cd_pedido_venda,  
    @cd_cliente                                                  as cd_cliente,  
    @cd_vendedor                                                 as cd_vendedor,  
    @cd_nota_saida                                               as cd_nota_saida,  
    @dt_pedido_venda                                             as dt_pedido_venda_nextel,  
    @qt_dia_pagamento                                            as qt_dia_pagamento,  
    cast(@cd_status_pedido as int )                              as cd_status_pedido_nextel,  
    @cd_produto                                                  as cd_produto,

    --Antes de 06.05.2009
--     --Quantidade
--     cast(@qt_item_pedido_venda as float )*@qt_multiplo_embalagem as qt_item_pedido_venda_nextel,  
-- 
--     --Valor Unitário
--     cast(@vl_item_total_pedido as float)/@qt_multiplo_embalagem 

    --Quantidade
    cast(@qt_item_pedido_venda as float )                        as qt_item_pedido_venda_nextel,  

    --Valor Unitário
    cast(@vl_item_total_pedido as float)
                                                                 as vl_item_total_pedido,  

    cast(@cd_tabela_preco as int )                               as cd_tabela_preco,  

    cast(@qt_item_pedido_venda as float)                         as qt_itens_pedido_venda,  
    1                                                            as cd_usuario,  
    getdate()                                                    as dt_usuario,  
    @cd_item_pedido_venda                                        as cd_item_pedido_venda,
    'N'                                                          as ic_gerado_pedido_venda,
    @cd_condicao_pagamento                                       as cd_condicao_pagamento,
    @cd_controle                                                 as cd_controle,
    @cd_vendedor_interno                                         as cd_vendedor_interno,
    @dt_entrega_pedido                                           as dt_entrega_pedido,
    @cd_destinacao_produto                                       as cd_destinacao_produto,
    @qt_saldo_produto                                            as qt_saldo_produto,
    @cd_tabela_preco_padrao                                      as cd_tabela_preco_padrao,
    @vl_saldo_cliente                                            as vl_saldo_cliente,
    @cd_condicao_pedido                                          as cd_condicao_pedido,
    @qt_saldo_reserva_produto                                    as qt_estoque_produto,
    null                                                         as cd_unidade_medida


  into  
    #Pedido_venda_Item

  insert into    
    pedido_venda_nextel    
  select    
    *
  from
    #pedido_venda_item

  delete from pedido_venda_nextel 
  where 
    cd_pedido_venda = @cd_pedido_venda and isnull(qt_item_pedido_venda_nextel,0) = 0

  drop table #pedido_venda_item

  
end

------------------------------------------------------------------------------------------------------------------------------------  
--delete from pedido_venda_nextel
------------------------------------------------------------------------------------------------------------------------------------  

