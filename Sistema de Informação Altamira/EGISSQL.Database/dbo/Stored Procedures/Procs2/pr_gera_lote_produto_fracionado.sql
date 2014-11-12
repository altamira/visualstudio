
-------------------------------------------------------------------------------
--sp_helptext pr_gera_lote_produto_fracionado
-------------------------------------------------------------------------------
--pr_gera_lote_produto_fracionado
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Gera o Lote do Produto Fracionado
--Data             : 18.11.2010
--Alteração        : 20.11.2010 
--
-- 07.12.2010 - Somente gerar para o Produto Fracionado
-- 13.12.2010 - Data de Validade / Fabricação dos Laudos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_lote_produto_fracionado
@cd_guia_fracionamento      int = 0,
@cd_item_guia_fracionamento int = 0,
@cd_produto                 int = 0,
@cd_usuario                 int = 0
--@cd_produto_origem          int = 0

as

declare @dt_hoje               datetime
declare @cd_lote               varchar(25)

--select * from produto_fracionamento

--select * from laudo

declare @dt_fabricacao datetime
declare @dt_validade   datetime

--busca as datas do produto EO

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

--select * from guia_fracionamento_item

set @cd_lote = ''

select
  @cd_lote = isnull(lp.nm_ref_lote_produto,'')
from
 guia_fracionamento_item gfi      with (nolock)  
 inner join lote_produto lp       with (nolock)  on lp.nm_ref_lote_produto = gfi.cd_lote_fracionamento
 inner join lote_produto_item lpi with (nolock)  on lpi.cd_lote_produto    = lp.cd_lote_produto and
                                                    lpi.cd_produto         = @cd_produto
where
  gfi.cd_guia_fracionamento       = @cd_guia_fracionamento
  and
  gfi.cd_item_guia_fracionamento = @cd_item_guia_fracionamento


if @cd_lote = '' 
begin

--lote_produto

  declare @Tabela		     varchar(80)
  declare @cd_lote_produto           int
  
  --set @dt_lote = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)

  set @Tabela          = cast(DB_NAME()+'.dbo.Lote_Produto' as varchar(80))
  set @cd_lote_produto = 0

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lote_produto', @codigo = @cd_lote_produto output
	
  while exists(Select top 1 'x' from Lote_Produto
               where cd_lote_produto = @cd_lote_produto
               order by cd_lote_produto)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lote_produto', @codigo = @cd_lote_produto output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lote_produto, 'D'
  end


--select * from lote_produto
--select * from guia_fracionamento_item
--select * from guia_fracionamento
--select * from laudo
--select * from lote_produto_saldo

select
  top 1
  @cd_lote_produto          as cd_lote_produto,
  gfi.cd_lote_fracionamento as nm_lote_produto,
  gfi.cd_lote_fracionamento as nm_ref_lote_produto,
  'A'                       as ic_status_lote_produto,
  gf.dt_guia_fracionamento  as dt_entrada_lote_produto,

  case when l.dt_fabricacao is not null then
    l.dt_fabricacao         
  else
    @dt_hoje
  end                       as dt_inicial_lote_produto,

  case when l.dt_validade is not null then
    l.dt_validade  
  else 
   @dt_hoje
  end                       as dt_final_lote_produto,
  'S'                       as ic_inspecao_lote_produto,
  gf.dt_guia_fracionamento  as dt_inspecao_lote_produto,
  'S'                       as ic_rastro_lote_produto,
  1                         as cd_pais,
  null                      as cd_processo,
  @cd_usuario               as cd_usuario,
  getdate()                 as dt_usuario,
  'Guia Fracionamento: '+cast(gf.cd_guia_fracionamento as varchar) as nm_obs_lote_produto,
  null                      as dt_saida_lote_produto,
  null                      as cd_fornecedor,
  null                      as ic_estoque_lote_produto,
  null                      as cd_loja
into
  #Lote_Produto

from
  Guia_Fracionamento gf                  with (nolock)
  inner join guia_fracionamento_item gfi with (nolock) on gfi.cd_guia_fracionamento = gf.cd_guia_fracionamento
  left outer join laudo              l   with (nolock) on l.cd_laudo                = gfi.cd_laudo and
                                                          l.cd_produto              = @cd_produto --gfi.cd_produto_fracionamento

--select * from guia_fracionamento_item

where
  gf.cd_guia_fracionamento       = @cd_guia_fracionamento
  and
  gfi.cd_item_guia_fracionamento = @cd_item_guia_fracionamento

insert into 
  Lote_Produto 
select * from #Lote_Produto

if not exists(select cd_lote_produto from Lote_Produto_Item where @cd_lote_produto = cd_lote_produto and
                                                                  @cd_produto      = cd_produto   )

begin

  --select * from guia_fracionamento_item
  --select * from lote_produto_item
  --select * from produto_fracionamento


  insert into Lote_Produto_item
  select
    @cd_lote_produto            as cd_lote_produto,
    pf.cd_produto_fracionado    as cd_produto,
    gfi.qt_fracionada            as qt_produto_lote_produto,
    'Guia Fracionamento: '+cast(gfi.cd_guia_fracionamento as varchar) as nm_obs_item_lote_produto,
    gf.dt_guia_fracionamento     as dt_inicio_item_lote,
    gf.dt_guia_fracionamento     as dt_final_item_lote,
    'A'                          as ic_status_item_lote,
    null                         as cd_peca_item_lote,
    null                         as cd_box_item_lote,
    null                         as cd_cor,
    null                         as cd_tipo_desenho,
    p.cd_fase_produto_baixa      as cd_fase_produto,
    null                         as cd_loja,
    null                         as qt_largura_item_lote,
    null                         as qt_comp_item_lote,
    null                         as qt_venda_item_lote,
    null                         as qt_reserva_m2_item_lote,
    null                         as qt_saldo_m2_item_lote,
    null                         as qt_saldo_ml_item_lote,
    p.cd_unidade_medida          as cd_unidade_medida,
    null                         as cd_movimento_lote,
    null                         as cd_movimento_lote_origem,
    'E'                          as ic_tipo_movimento_lote,
    null                         as cd_movimento_estoque,
    @cd_usuario                  as cd_usuario,
    getdate()                    as dt_usuario,
    null                         as cd_nota_saida,
    null                         as cd_item_nota_saida,
    null                         as qt_saldo_atual_lote,
    null                         as ic_saldo_item_lote,
    null                         as cd_nota_entrada,
    null                         as cd_fornecedor,
    null                         as cd_serie_nota_fiscal,
    null                         as cd_operacao_fiscal,
    null                         as cd_item_nota_entrada

from
  guia_fracionamento_item gfi              with (nolock) 
  inner join guia_fracionamento gf         with (nolock) on gf.cd_guia_fracionamento    = gfi.cd_guia_fracionamento
  left outer join produto p                with (nolock) on p.cd_produto                = gfi.cd_produto_fracionamento
  left outer join produto_fracionamento pf with (nolock) on pf.cd_produto_fracionamento = gfi.cd_produto_fracionamento

where
  gf.cd_guia_fracionamento       = @cd_guia_fracionamento
  and
  gfi.cd_item_guia_fracionamento = @cd_item_guia_fracionamento

--select * from guia_fracionamento_item
--select * from lote_produto_item
 
end

--Grava o Lote Produto Saldo - lote_produto_saldo

if not exists(select cd_lote_produto from Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                                                                   @cd_produto      = cd_produto   )

begin

insert into lote_produto_saldo
select
--GBS
    @cd_lote_produto            as cd_lote_produto,
    pf.cd_produto_fracionado    as cd_produto,
    @cd_usuario                 as cd_usuario,
    getdate()                   as dt_usuario,
    'Guia Fracionamento: '+cast(gfi.cd_guia_fracionamento as varchar) as nm_obs_item_lote_produto,
    gf.dt_guia_fracionamento     as dt_inicio_item_lote,
    gf.dt_guia_fracionamento     as dt_final_item_lote,
    null                         as cd_peca_item_lote,
    'A'                          as ic_status_item_lote,
    null                         as cd_box_item_lote,
    null                         as cd_cor,
    null                         as cd_desenho_projeto,
    p.cd_fase_produto_baixa      as cd_fase_produto,
    null                         as cd_loja,
    null                         as qt_largura_item_lote,
    null                         as qt_comp_item_lote,
    null                         as qt_comp_reserva_item_lote,
    p.cd_unidade_medida          as cd_unidade_medida,
    null                         as cd_movimento_estoque,
    gfi.cd_lote_fracionamento    as nm_lote_produto,
    null                         as cd_nota_entrada,
    null                         as cd_fornecedor,
    null                         as cd_serie_nota_fiscal,
    null                         as cd_operacao_fiscal,
    null                         as cd_item_nota_entrada,
    gfi.qt_fracionada            as qt_saldo_reserva_lote,
    gfi.qt_fracionada            as qt_saldo_atual_lote

--PHARMA

--     @cd_lote_produto            as cd_lote_produto,
--     pf.cd_produto_fracionado    as cd_produto,
--     @cd_usuario                 as cd_usuario,
--     getdate()                   as dt_usuario,
--     'Guia Fracionamento: '+cast(gfi.cd_guia_fracionamento as varchar) as nm_obs_item_lote_produto,
--     gf.dt_guia_fracionamento     as dt_inicio_item_lote,
--     gf.dt_guia_fracionamento     as dt_final_item_lote,
--     null                         as cd_peca_item_lote,
--     'A'                          as ic_status_item_lote,
--     null                         as cd_box_item_lote,
--     null                         as cd_cor,
--     null                         as cd_desenho_projeto,
--     p.cd_fase_produto_baixa      as cd_fase_produto,
--     null                         as qt_largura_item_lote,
--     null                         as qt_comp_item_lote,
--     null                         as qt_comp_reserva_item_lote,
--     gfi.cd_lote_fracionamento    as nm_lote_produto,
--     null                         as cd_nota_entrada,
--     p.cd_unidade_medida          as cd_unidade_medida,
--     null                         as cd_fornecedor,
--     null                         as cd_serie_nota_fiscal,
--     null                         as cd_operacao_fiscal,
--     null                         as cd_item_nota_entrada,
--     null                         as cd_movimento_estoque,
--     gfi.qt_fracionada                         as qt_saldo_reserva_lote,
--     gfi.qt_fracionada                         as qt_saldo_atual_lote,
--     null                         as cd_loja,
--     gfi.qt_fracionada                         as qt_saldo_atual,
--     gfi.qt_fracionada                         as qtd_saldo_atual



from
  guia_fracionamento_item gfi              with (nolock) 
  inner join guia_fracionamento gf         with (nolock) on gf.cd_guia_fracionamento    = gfi.cd_guia_fracionamento
  left outer join produto p                with (nolock) on p.cd_produto                = gfi.cd_produto_fracionamento
  left outer join produto_fracionamento pf with (nolock) on pf.cd_produto_fracionamento = gfi.cd_produto_fracionamento

where
  gf.cd_guia_fracionamento       = @cd_guia_fracionamento
  and
  gfi.cd_item_guia_fracionamento = @cd_item_guia_fracionamento



end


exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lote_produto, 'D'

drop table #Lote_Produto

end


