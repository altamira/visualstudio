
-------------------------------------------------------------------------------
--sp_helptext pr_gera_lote_produto_laudo
-------------------------------------------------------------------------------
--pr_gera_lote_produto_laudo
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
-- 15.12.2010 - Ajustes Diversos - Carlos Fernandes
-- 27.12.2010 - Verificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_lote_produto_laudo
@cd_laudo                   int = 0,
@cd_produto                 int = 0,
@cd_usuario                 int = 0

as


--Verifica se o Lote já existe----------------------------------------------------------

  declare @cd_lote          varchar(25)

  set @cd_lote = '' 

  select
    @cd_lote = isnull(cd_lote,@cd_lote)
  from
    Laudo l                    with (nolock)   
    inner join lote_produto lp with (nolock) on lp.nm_ref_lote_produto = l.cd_lote
  where
    cd_laudo   = @cd_laudo    and
    cd_produto = @cd_produto

--select @cd_lote

--lote_produto

if ( @cd_lote = '' )
   or
   ( not exists ( select top 1 nm_ref_lote_produto from lote_produto where nm_ref_lote_produto = @cd_lote ) )

   --or substring(@cd_lote,1,3)<>'PS-'    -- <Temporário para Pharma Special> --
begin

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
--select * from laudo
--select * from lote_produto_saldo

  select
    top 1
  @cd_lote_produto          as cd_lote_produto,
  l.cd_lote                 as nm_lote_produto,
  l.cd_lote                 as nm_ref_lote_produto,
  'A'                       as ic_status_lote_produto,
  l.dt_laudo                as dt_entrada_lote_produto,
  l.dt_fabricacao           as dt_inicial_lote_produto,
  l.dt_validade             as dt_final_lote_produto,
  'S'                       as ic_inspecao_lote_produto,
  l.dt_laudo                as dt_inspecao_lote_produto,
  'S'                       as ic_rastro_lote_produto,
  1                         as cd_pais,
  null                      as cd_processo,
  @cd_usuario               as cd_usuario,
  getdate()                 as dt_usuario,
  'Laudo N.: '+cast(l.cd_laudo as varchar) as nm_obs_lote_produto,
  null                      as dt_saida_lote_produto,
  null                      as cd_fornecedor,
  null                      as ic_estoque_lote_produto,
  null                      as cd_loja

  into
    #Lote_Produto

  from
    Laudo l                  with (nolock)

  where
    l.cd_laudo = @cd_laudo 
  

  insert into 
    Lote_Produto 
  select * from #Lote_Produto



--Produto no Lote/Laudo

  if not exists(select top 1 cd_lote_produto from Lote_Produto_Item where @cd_lote_produto = cd_lote_produto and
                                                                          @cd_produto      = cd_produto   )
 
  begin

  --select * from guia_fracionamento_item
  --select * from lote_produto_item
  --select * from produto_fracionamento


  insert into Lote_Produto_item
  select
    top 1
    @cd_lote_produto             as cd_lote_produto,
    l.cd_produto                 as cd_produto,
    l.qt_laudo                   as qt_produto_lote_produto,
    'Laudo N.: '+cast(l.cd_laudo as varchar) as nm_obs_item_lote_produto,
    l.dt_fabricacao              as dt_inicio_item_lote,
    l.dt_validade                as dt_final_item_lote,
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
    Laudo l               with (nolock) 
    left outer join produto p                with (nolock) on p.cd_produto                = l.cd_produto

  where
    l.cd_laudo = @cd_laudo

 
  end

--Grava o Lote Produto Saldo - lote_produto_saldo

  if not exists(select top 1 cd_lote_produto from Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                                                                         @cd_produto      = cd_produto   )

  begin

  insert into lote_produto_saldo
  select
     top 1

--GBS
    @cd_lote_produto            as cd_lote_produto,
    l.cd_produto                as cd_produto,
    @cd_usuario                 as cd_usuario,
    getdate()                   as dt_usuario,
    'Laudo N.: '+cast(l.cd_laudo as varchar) as nm_obs_item_lote_produto,
    l.dt_fabricacao              as dt_inicio_item_lote,
    l.dt_validade                as dt_final_item_lote,
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
    l.cd_lote                    as nm_lote_produto,
    null                         as cd_nota_entrada,
    null                         as cd_fornecedor,
    null                         as cd_serie_nota_fiscal,
    null                         as cd_operacao_fiscal,
    null                         as cd_item_nota_entrada,
    l.qt_laudo                   as qt_saldo_reserva_lote,
    l.qt_laudo                   as qt_saldo_atual_lote

--PHARMA

--     @cd_lote_produto            as cd_lote_produto,
--     l.cd_produto                as cd_produto,
--     @cd_usuario                 as cd_usuario,
--     getdate()                   as dt_usuario,
--     'Laudo N.: '+cast(l.cd_laudo as varchar) as nm_obs_item_lote_produto,
--     l.dt_fabricacao              as dt_inicio_item_lote,
--     l.dt_validade                as dt_final_item_lote,
--     null                         as cd_peca_item_lote,
--     'A'                          as ic_status_item_lote,
--     null                         as cd_box_item_lote,
--     null                         as cd_cor,
--     null                         as cd_desenho_projeto,
--     p.cd_fase_produto_baixa      as cd_fase_produto,
--     null                         as qt_largura_item_lote,
--     null                         as qt_comp_item_lote,
--     null                         as qt_comp_reserva_item_lote,
--     l.cd_lote                    as nm_lote_produto,
--     null                         as cd_nota_entrada,
--     p.cd_unidade_medida          as cd_unidade_medida,
--     null                         as cd_fornecedor,
--     null                               as cd_serie_nota_fiscal,
--     null                               as cd_operacao_fiscal,
--     null                               as cd_item_nota_entrada,
--     null                               as cd_movimento_estoque,
--     l.qt_laudo                         as qt_saldo_reserva_lote,
--     l.qt_laudo                         as qt_saldo_atual_lote,
--     null                               as cd_loja,
--     l.qt_laudo                         as qt_saldo_atual,
--     l.qt_laudo                         as qtd_saldo_atual



  from
    laudo l              with (nolock) 
    left outer join produto p                with (nolock) on p.cd_produto                = l.cd_produto

  where
    l.cd_laudo = @cd_laudo

  end


  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lote_produto, 'D'

  drop table #Lote_Produto

end

