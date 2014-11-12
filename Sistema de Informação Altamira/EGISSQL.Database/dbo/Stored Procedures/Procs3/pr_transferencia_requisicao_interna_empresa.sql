
-------------------------------------------------------------------------------
--sp_helptext pr_transferencia_requisicao_interna_empresa
-------------------------------------------------------------------------------
--pr_transferencia_requisicao_interna_empresa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Transferência de Requisição de Interna de Empresa
--                   Estoque
--
--Data             : 24.01.2009
--Alteração        : 05.02.2009
--
--
------------------------------------------------------------------------------
create procedure pr_transferencia_requisicao_interna_empresa
@cd_requisicao_interna int = 0,
@cd_empresa            int = 0,
@cd_usuario            int = 0

as

declare @nm_banco_empresa     varchar(40)
declare @cd_movimento_estoque int 
declare @nm_fantasia_empresa  varchar(15)
declare @cd_fase_produto      int
declare @Tabela               varchar(80)

if @cd_requisicao_interna > 0
begin

  --Empresa Origem
  select 
    @nm_fantasia_empresa = nm_fantasia_empresa
  from
    egisadmin.dbo.empresa with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

  --fase de Produto
  select 
    @cd_fase_produto = isnull(cd_fase_produto,0)
  from
    parametro_comercial with (nolock)
  where
    cd_empresa = dbo.fn_empresa()

  --seleciona o Banco da Nova Empresa
  select
    @nm_banco_empresa = isnull(nm_banco_empresa,0) 
  from
    egisadmin.dbo.Empresa e
  where
    e.cd_empresa = @cd_empresa

--  select @cd_empresa,@nm_banco_empresa

--   select
--     *
--   from
--     Requisicao_Interna_item i
--   where
--     cd_requisicao_interna = @cd_requisicao_interna

  --Gera a Entrada de Estoque dos Produtos-----------------------------------------------------------

  --Busca do último código disponível

  select 
    @cd_movimento_estoque = isnull( max(cd_movimento_estoque)+1, 1 )
  from
    Movimento_Estoque with (nolock) 


   if @cd_movimento_estoque = 0
   begin
     set @cd_movimento_estoque = 1
   end

--   select @cd_movimento_estoque

   declare @dt_movimento_estoque      datetime    
   declare @cd_tipo_movimento_estoque int  
   declare @cd_tipo_documento_estoque int         
   declare @cd_documento_estoque      varchar(20) 
   declare @cd_historico_estoque      int         
   declare @nm_historico_estoque      varchar(255)
   
   set @dt_movimento_estoque      = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
   set @cd_tipo_movimento_estoque = 1
   set @cd_tipo_documento_estoque = 8 --Transferência
   set @cd_documento_estoque      = cast(@cd_requisicao_interna as varchar(20))
   set @cd_historico_estoque      = null
   set @nm_historico_estoque      = 'Transferência - Requisição Interna : '+cast(@cd_requisicao_interna as varchar)+' '+@nm_fantasia_empresa

   --select * from tipo_movimento_estoque
   --select * from tipo_documento_estoque
   --select * from historico_estoque   
   --select * from requisicao_interna_item

   select
    identity(int,1,1)                     as cd_movimento_estoque,
    @dt_movimento_estoque                 as dt_movimento_estoque,
    --Entrada
    ---@cd_tipo_movimento_estoque            as cd_tipo_movimento_estoque,
    1                                     as cd_tipo_movimento_estoque,
    @cd_documento_estoque                 as cd_documento_movimento,
    ri.cd_item_req_interna                as cd_item_documento,
    @cd_tipo_documento_estoque            as cd_tipo_documento_estoque,
    @dt_movimento_estoque                 as dt_documento_movimento,
    null                                  as cd_centro_custo,
    ri.qt_item_req_interna                as qt_movimento_estoque,
    null                                  as vl_unitario_movimento,
    null                                  as vl_total_movimento,
    pc.ic_peps_produto                    as ic_peps_movimento_estoque,
    null                                  as ic_terceiro_movimento,
    null                                  as ic_consig_movimento,
    @nm_historico_estoque                 as nm_historico_movimento,
    case when @cd_tipo_movimento_estoque = 1 
    then 'E'
    else 'S' end                          as ic_mov_movimento,
    null                                  as cd_fornecedor,
    ri.cd_produto                          as cd_produto,
    case when isnull(p.cd_fase_produto_baixa,0)>0 then
     p.cd_fase_produto_baixa
    else
     isNull(@cd_fase_produto,3)
    end                                   as cd_fase_produto,
    null                                  as ic_fase_entrada_movimento,
    null                                  as cd_fase_produto_entrada,
    null                                  as ds_observacao_movimento,
    null                                  as vl_fob_produto,
    null                                  as cd_lote_produto,
    null                                  as vl_custo_contabil_produto,
    null                                  as nm_referencia_movimento,
    @cd_usuario                           as cd_usuario,
    getdate()                             as dt_usuario,
    null                                  as cd_origem_baixa_produto,
    null                                  as cd_item_movimento,
    null                                  as ic_consig_mov_estoque,
    p.cd_unidade_medida                   as cd_unidade_medida,
    null                                  as cd_historico_estoque,
    null                                  as cd_tipo_destinatario,
    null                                  as nm_destinatario,
    null                                  as nm_invoice,
    null                                  as nm_di,
    null                                  as vl_fob_convertido,
    'A'                                   as ic_tipo_lancto_movimento,
    null                                  as ic_amostra_movimento,
    null                                  as cd_item_composicao,
    null                                  as ic_canc_movimento_estoque,
    null                                  as cd_movimento_estoque_origem,
    null                                  as cd_movimento_saida_original,
    null                                  as cd_aplicacao_produto,
    null                                  as cd_serie_nota_fiscal,
    null                                  as cd_operacao_fiscal,
    null                                  as ic_tipo_terc_movimento,
    null                                  as ic_tipo_consig_movimento,
    null                                  as cd_unidade_origem,
    null                                  as qt_fator_produto_unidade,
    null                                  as qt_origem_movimento,
    null                                  as cd_loja,
    null                                  as qt_peso_movimento_estoque

  into
    #Movimento_Estoque

  from
    Requisicao_Interna_Item ri       with (nolock) 
    left outer join Produto p        on p.cd_produto  = ri.cd_produto
    left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
  where
    cd_requisicao_interna = @cd_requisicao_interna and
    isnull(ri.cd_produto,0)>0                      and
    isnull(ri.qt_item_req_interna,0)>0             and
    isnull(ri.ic_transferencia,'N')='N'

  --Verificação do Número do Lançamento
  --select db_name()

  -- Nome da Tabela usada na geração e liberação de códigos
  --set @Tabela = cast(DB_NAME()+'.dbo.Movimento_Estoque' as varchar(50))
  set @Tabela = cast(@nm_banco_empresa+'.dbo.Movimento_Estoque' as varchar(60))
--  select @Tabela

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output
	
  while exists(Select top 1 'x' from movimento_estoque where cd_movimento_estoque = @cd_movimento_estoque)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'

--  select @cd_movimento_estoque

--  update
--    #Movimento_Estoque
--  set
--    cd_movimento_estoque = cd_movimento_estoque + @cd_movimento_estoque

-- select * from #Movimento_Estoque

  declare @sql varchar(8000)
  set @sql = ''
  set @sql =   
  'insert into ' +
    @nm_banco_empresa+'.dbo.Movimento_Estoque
  (
   cd_movimento_estoque,
   dt_movimento_estoque,
   cd_tipo_movimento_estoque,
   cd_documento_movimento,
   cd_item_documento,
   cd_tipo_documento_estoque,
   dt_documento_movimento,
   cd_centro_custo,
   qt_movimento_estoque,
   vl_unitario_movimento,
   vl_total_movimento,
   ic_peps_movimento_estoque,
   ic_terceiro_movimento,
   ic_consig_movimento,
   nm_historico_movimento,
   ic_mov_movimento,
   cd_fornecedor,
   cd_produto,
   cd_fase_produto,
   ic_fase_entrada_movimento,
   cd_fase_produto_entrada,
   ds_observacao_movimento,
   vl_fob_produto,
   cd_lote_produto,
   vl_custo_contabil_produto,
   nm_referencia_movimento,
   cd_usuario,
   dt_usuario,
   cd_origem_baixa_produto,
   cd_item_movimento,
   ic_consig_mov_estoque,
   cd_unidade_medida,
   cd_historico_estoque,
   cd_tipo_destinatario,
   nm_destinatario,
   nm_invoice,
   nm_di,
   vl_fob_convertido,
   ic_tipo_lancto_movimento,
   ic_amostra_movimento,
   cd_item_composicao,
   ic_canc_movimento_estoque,
   cd_movimento_estoque_origem,
   cd_movimento_saida_original,
   cd_aplicacao_produto,
   cd_serie_nota_fiscal,
   cd_operacao_fiscal,
   ic_tipo_terc_movimento,
   ic_tipo_consig_movimento,
   cd_unidade_origem,
   qt_fator_produto_unidade,
   qt_origem_movimento,
   cd_loja,
   qt_peso_movimento_estoque)

  select
    cd_movimento_estoque + '+cast(@cd_movimento_estoque as varchar)+',
    dt_movimento_estoque,
    cd_tipo_movimento_estoque,
    cd_documento_movimento,
    cd_item_documento,
    cd_tipo_documento_estoque,
    dt_documento_movimento,
    cd_centro_custo,
    qt_movimento_estoque,
    vl_unitario_movimento,
    vl_total_movimento,
    ic_peps_movimento_estoque,
    ic_terceiro_movimento,
    ic_consig_movimento,
    nm_historico_movimento,
    ic_mov_movimento,
    cd_fornecedor,
    cd_produto,
    cd_fase_produto,
    ic_fase_entrada_movimento,
    cd_fase_produto_entrada,
    ds_observacao_movimento,
    vl_fob_produto,
    cd_lote_produto,
    vl_custo_contabil_produto,
    nm_referencia_movimento,
    cd_usuario,
    dt_usuario,
    cd_origem_baixa_produto,
    cd_item_movimento,
    ic_consig_mov_estoque,
    cd_unidade_medida,
    cd_historico_estoque,
    cd_tipo_destinatario,
    nm_destinatario,
    nm_invoice,
    nm_di,
    vl_fob_convertido,
    ic_tipo_lancto_movimento,
    ic_amostra_movimento,
    cd_item_composicao,
    ic_canc_movimento_estoque,
    cd_movimento_estoque_origem,
    cd_movimento_saida_original,
    cd_aplicacao_produto,
    cd_serie_nota_fiscal,
    cd_operacao_fiscal,
    ic_tipo_terc_movimento,
    ic_tipo_consig_movimento,
    cd_unidade_origem,
    qt_fator_produto_unidade,
    qt_origem_movimento,
    cd_loja,
    qt_peso_movimento_estoque
  from 
    #Movimento_Estoque'

  exec(@sql)

  --Atualiza o Flag de Transferência na Requisição

  update
    requisicao_interna_item
  set
    ic_transferencia = 'S'
  where
    cd_requisicao_interna = @cd_requisicao_interna


  --Atualiza a Tabela Produto Saldo
  --select * from produto_saldo

  set @sql = 
  'update '+
    @nm_banco_empresa+'.dbo.produto_saldo
  set
   qt_saldo_reserva_produto = ps.qt_saldo_reserva_produto + me.qt_movimento_estoque,
   qt_saldo_atual_produto   = ps.qt_saldo_atual_produto   + me.qt_movimento_estoque     
  from '+
    @nm_banco_empresa+'.dbo.produto_saldo ps
    inner join #movimento_estoque me on me.cd_produto      = ps.cd_produto and 
                                        me.cd_fase_produto = ps.cd_fase_produto'

--  print @sql

  exec (@sql)

  drop table #Movimento_Estoque


end

--select * from egisadmin.dbo.empresa
--select * from requisicao_interna_item 
--update requisicao_interna_item set ic_transferencia = 'N'
--select * from egissql_aguafunda.dbo.movimento_estoque
--select * from egissql_aguafunda.dbo.produto_saldo where cd_produto = 263
--select * from movimento_estoque

