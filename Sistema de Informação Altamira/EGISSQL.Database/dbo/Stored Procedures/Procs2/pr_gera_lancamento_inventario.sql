
-------------------------------------------------------------------------------
--sp_helptext pr_gera_lancamento_inventario
-------------------------------------------------------------------------------
--pr_gera_entrada_estoque_automatico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Entrada de Estoque Automaticamente
--                   Através de uma Tabela Temporária
--Data             : 31.10.2006
--Alteração        : 30.10.2007 - Geração de uma tabela com Saldos Negativos
--                                após o Fechamento de Estoque
-- 09.04.2008 - Ajuste/Verificação da Procedure - Carlos Fernandes
-- 16.05.2009 - Custo Inicial - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_gera_lancamento_inventario
@ic_parametro              int         = 0,
@cd_usuario                int         = 0,
@dt_movimento_estoque      datetime    = '',
@cd_tipo_movimento_estoque int         = 1,
@cd_tipo_documento_estoque int         = 1,
@cd_documento_estoque      varchar(20) = '',
@cd_historico_estoque      int         = 0,
@nm_historico_estoque      varchar(255)= '',
@ic_zera_movimento         char(1)     = 'N',
@ic_tipo_pesquisa          char(1)     = 'F',
@nm_fantasia_produto       varchar(30) = '',
@dt_base                   datetime    = ''

as

if @dt_base is null
begin
  set @dt_base = getdate()
end

--select * from produto_inventario
--select * from movimento_estoque

declare @Tabela		      varchar(50)
declare @cd_movimento_estoque int


-- Nome da Tabela usada na geração e liberação de códigos
set @Tabela = cast(DB_NAME()+'.dbo.Movimento_Estoque' as varchar(50))

--select * from tipo_movimento_estoque

if isnull(@ic_zera_movimento,'N') = 'S' 
begin
   delete from Movimento_Estoque
end

------------------------------------------------------------------------------
--Delete a Tabela de Produto Inventário
------------------------------------------------------------------------------

if @ic_parametro = 1
begin
  delete from produto_inventario
end

------------------------------------------------------------------------------
--Consulta da Tabela Produto Inventário
------------------------------------------------------------------------------

if @ic_parametro = 2
begin
  select
    pinv.*,
    --pinv.cd_produto,
    p.nm_fantasia_produto,
    p.cd_mascara_produto,
    p.nm_produto,
    um.sg_unidade_medida,
    --pinv.qt_inventario,
    tme.nm_tipo_movimento_estoque,
    fp.nm_fase_produto,
    gp.nm_grupo_produto
  into
    #produto_inventario_tmp
  from
    produto_inventario pinv                    with (nolock) 
    inner join produto p                       with (nolock) on p.cd_produto                  = pinv.cd_produto
    left outer join unidade_medida um          with (nolock) on um.cd_unidade_medida          = p.cd_unidade_medida
    left outer join fase_produto   fp          with (nolock) on fp.cd_fase_produto            = pinv.cd_fase_produto
    left outer join tipo_movimento_estoque tme with (nolock) on tme.cd_tipo_movimento_estoque = pinv.cd_tipo_movimento_estoque
    left outer join grupo_produto  gp          with (nolock) on gp.cd_grupo_produto           = p.cd_grupo_produto
  order by
    p.nm_fantasia_produto    

  if IsNull(@nm_fantasia_produto,'') <> ''
  begin
    Select * from #produto_inventario_tmp
    where
      -- Código Mascara Produto
      IsNull(cd_mascara_produto,'') like ( case when (IsNull(@ic_tipo_pesquisa,'F') = 'C') and  IsNull(@nm_fantasia_produto,'') <> '' then
	                                                IsNull(@nm_fantasia_produto,'') + '%'
	                                          else
                                                        IsNull(cd_mascara_produto,'')
                                                  end )
      and -- Fantasia Produto
      IsNull(nm_fantasia_produto,'') like ( case when (IsNull(@ic_tipo_pesquisa,'F') = 'F') and  IsNull(@nm_fantasia_produto,'') <> '' then
	                                                 IsNull(@nm_fantasia_produto,'') + '%'
	                                           else
                                                         IsNull(nm_fantasia_produto,'')
	                                           end )
    order by nm_fantasia_produto
  end
  else
  begin
    Select * from #produto_inventario_tmp order by nm_fantasia_produto
  end
end

--select * from tipo_movimento_estoque

-------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  --Busca do último código disponível

  select 
    @cd_movimento_estoque = isnull( max(cd_movimento_estoque)+1, 1 )
  from
    Movimento_Estoque with (nolock) 


   if @cd_movimento_estoque = 0
   begin
     set @cd_movimento_estoque = 1
   end

  select
    identity(int,1,1)                        as cd_movimento_estoque,
    @dt_movimento_estoque                    as dt_movimento_estoque,
    m.cd_tipo_movimento_estoque              as cd_tipo_movimento_estoque,
    @cd_documento_estoque                    as cd_documento_movimento,
    1                                        as cd_item_documento,
    @cd_tipo_documento_estoque               as cd_tipo_documento_estoque,
    @dt_movimento_estoque                    as dt_documento_movimento,
    null                                     as cd_centro_custo,
    m.qt_inventario                          as qt_movimento_estoque,
    round(isnull(m.vl_custo_inventario,0),6) as vl_unitario_movimento,
    --null                                  as vl_total_movimento,
    round(m.qt_inventario * round(isnull(m.vl_custo_inventario,0),6),2) as vl_total_movimento,
    pc.ic_peps_produto                       as ic_peps_movimento_estoque,
    null                                     as ic_terceiro_movimento,
    null                                     as ic_consig_movimento,
    @nm_historico_estoque                    as nm_historico_movimento,
    case when m.cd_tipo_movimento_estoque = 1 
    then 'E'
    else 'S' end                             as ic_mov_movimento,
    null                                     as cd_fornecedor,
    p.cd_produto                             as cd_produto,
    isNull(m.cd_fase_produto,3)              as cd_fase_produto,
    null                                     as ic_fase_entrada_movimento,
    null                                     as cd_fase_produto_entrada,
    null                                     as ds_observacao_movimento,
    null                                     as vl_fob_produto,
    null                                     as cd_lote_produto,
    round(isnull(m.vl_custo_inventario,0),6) as vl_custo_contabil_produto,
    null                                     as nm_referencia_movimento,
    @cd_usuario                              as cd_usuario,
    getdate()                                as dt_usuario,
    null                                     as cd_origem_baixa_produto,
    null                                     as cd_item_movimento,
    null                                     as ic_consig_mov_estoque,
    p.cd_unidade_medida                      as cd_unidade_medida,
    null                                     as cd_historico_estoque,
    null                                     as cd_tipo_destinatario,
    null                                     as nm_destinatario,
    null                                     as nm_invoice,
    null                                     as nm_di,
    null                                     as vl_fob_convertido,
    'A'                                      as ic_tipo_lancto_movimento,
    null                                     as ic_amostra_movimento,
    null                                     as cd_item_composicao,
    null                                     as ic_canc_movimento_estoque,
    null                                     as cd_movimento_estoque_origem,
    null                                     as cd_movimento_saida_original,
    null                                     as cd_aplicacao_produto,
    null                                     as cd_serie_nota_fiscal,
    null                                     as cd_operacao_fiscal,
    null                                     as ic_tipo_terc_movimento,
    null                                     as ic_tipo_consig_movimento,
    null                                     as cd_unidade_origem,
    null                                     as qt_fator_produto_unidade,
    null                                     as qt_origem_movimento,
    null                                     as cd_loja,
    null                                     as qt_peso_movimento_estoque,
    null                                     as vl_custo_comissao,
    'N'                                      as ic_nf_complemento


  into
    #Movimento_Estoque
  from
    Produto_Inventario m             with (nolock) 
    left outer join Produto p        with (nolock) on p.cd_produto  = m.cd_produto
    left outer join Produto_Custo pc with (nolock) on pc.cd_produto = p.cd_produto

  where
    isnull(m.qt_inventario,0)>0

  --Verificação do Número do Lançamento

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output
	
  while exists(Select top 1 'x' from movimento_estoque where cd_movimento_estoque = @cd_movimento_estoque)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output

    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'
  end

-- update
--   #Movimento_Estoque
--  set
--   cd_movimento_estoque = cd_movimento_estoque + @cd_movimento_estoque

--select * from #Movimento_Estoque

  insert into
    Movimento_Estoque
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
    cd_movimento_estoque + @cd_movimento_estoque,
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
    #Movimento_Estoque

  drop table #Movimento_Estoque

end

-------------------------------------------------------------------------------
--Saldos Negativo de Fechamento
-------------------------------------------------------------------------------

--select * from tipo_movimento_estoque

if @ic_parametro = 4
begin

  delete from produto_inventario

  --select @dt_base
  
  --select * from produto_inventario
  --select * from produto_fechamento
  select
    pf.cd_produto,
    pf.qt_atual_prod_fechamento * -1  as qt_inventario,
    pf.cd_fase_produto,
    @cd_usuario                       as cd_usuario,
    getdate()                         as dt_usuario,
    1                                 as cd_tipo_movimento_estoque,
    pf.qt_atual_prod_fechamento * -1  as qt_saldo_atual_produto
  into
    #produto_inventario_negativo
  from
    Produto_Fechamento pf with (nolock)
  where
    pf.dt_produto_fechamento = @dt_base and
    isnull(pf.qt_atual_prod_fechamento,0) < 0

--  select * from #produto_inventario_negativo

  insert into
    produto_inventario
  select
    *
  from
    #produto_inventario_negativo
    
  drop table #produto_inventario_negativo

end

-------------------------------------------------------------------------------
--Ajuste de Saldo da Reserva > Saldo Atual
-------------------------------------------------------------------------------

if @ic_parametro = 5
begin

  delete from produto_inventario

  --select @dt_base
  
  --select * from produto_inventario
  --select * from produto_saldo
  --select * from tipo_movimento_estoque

  select
    ps.cd_produto,

    (ps.qt_saldo_atual_produto - 
     ps.qt_saldo_reserva_produto)*-1  as qt_inventario,
    ps.cd_fase_produto,
    @cd_usuario                       as cd_usuario,
    getdate()                         as dt_usuario,
    2                                 as cd_tipo_movimento_estoque,
    (ps.qt_saldo_atual_produto - 
     ps.qt_saldo_reserva_produto)*-1  as qt_saldo_atual_produto
  into
    #produto_inventario_reserva
  from
    Produto_Saldo ps with (nolock)
  where
    isnull(ps.qt_saldo_reserva_produto,0)>isnull(ps.qt_saldo_atual_produto,0)    

--  select * from #produto_inventario_negativo

  insert into
    produto_inventario
  select
    *
  from
    #produto_inventario_reserva
    
  drop table #produto_inventario_reserva


end

-------------------------------------------------------------------------------
--Ajuste de Saldo Atual Negativo
-------------------------------------------------------------------------------

if @ic_parametro = 6
begin

  delete from produto_inventario

  --select @dt_base
  
  --select * from produto_inventario
  --select * from produto_saldo
  --select * from tipo_movimento_estoque

  select
    ps.cd_produto,

    (ps.qt_saldo_atual_produto * -1 ) as qt_inventario,
    ps.cd_fase_produto,
    @cd_usuario                       as cd_usuario,
    getdate()                         as dt_usuario,
    1                                 as cd_tipo_movimento_estoque,
    (ps.qt_saldo_atual_produto * -1 ) as qt_saldo_atual_produto
  into
    #produto_inventario_saldo_atual
  from
    Produto_Saldo ps with (nolock)
  where
    isnull(qt_saldo_atual_produto,0) < 0   

--  select * from #produto_inventario_negativo

  insert into
    produto_inventario
  select
    *
  from
    #produto_inventario_saldo_atual
    
  drop table #produto_inventario_saldo_atual


end

