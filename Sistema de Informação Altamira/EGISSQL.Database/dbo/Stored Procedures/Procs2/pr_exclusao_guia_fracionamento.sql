
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_guia_fracionamento
-------------------------------------------------------------------------------
--pr_exclusao_guia_fracionamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Exclusão Completa da Guia de Fracionamento
--Data             : 03.01.2008
--Alteração        : 31.01.2008 - Acerto da Recomposição de Saldos - Carlos Fernandes
--20.11.2010 - Complemento da Exclusão das novas tabelas para controle do Lote Interno - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
create procedure pr_exclusao_guia_fracionamento

@cd_guia_fracionamento int      = 0,
@dt_fechamento         datetime = '',
@dt_inicial            datetime = '',
@dt_final              datetime = ''

as

--select * from guia_fracionamento
--select * from guia_fracionamento_item
--select * from tipo_documento_estoque
--select * from requisicao_interna
--select * from movimento_estoque

if @cd_guia_fracionamento>0
begin

  --prepara uma tabela auxiliar com a Movimentação de Estoque para acerto dos saldo

  select 
    distinct
    cd_produto,cd_fase_produto, cd_lote_produto 
  into
    #GuiaProduto
  from 
    movimento_estoque  with (nolock) 
  where 
     cd_documento_movimento    = @cd_guia_fracionamento and
     cd_tipo_documento_estoque = 13 --guia de fracionamento

  --select * from #GuiaProduto

  declare @cd_produto       int
  declare @cd_fase_produto  int
  declare @cd_lote_produto  varchar(25)

  while exists ( select top 1 cd_produto from #GuiaProduto )
  begin

    select top 1 
      @cd_produto      = cd_produto,
      @cd_fase_produto = cd_fase_produto,
      @cd_lote_produto = cd_lote_produto
    from
      #GuiaProduto

    if @cd_lote_produto <> ''
    begin
      exec pr_recomposicao_saldo_lote_produto  @cd_lote_informado = @cd_lote_produto
    end

    if @cd_produto>0 and @cd_fase_produto>0
    begin
      print ''
      --Real
      -- exec pr_recomposicao_saldo 
      --   @ic_parametro = 5, 
      --   @dt_fechamento = 'dez 31 2007 12:00AM',
      --   @dt_inicial = 'jan  1 2008 12:00AM', 
      --   @dt_final   = 'jan 31 2008 12:00AM', 
      --   @cd_produto = 10, 
      --   @cd_grupo_produto = 0, 
      --   @cd_serie_produto = 0, 
      --   @cd_fase_produto = 1

  --Reserva

  -- exec pr_recomposicao_saldo 
  --   @ic_parametro = 6, 
  --   @dt_fechamento = 'dez 31 2007 12:00AM',
  --   @dt_inicial = 'jan  1 2008 12:00AM', 
  --   @dt_final   = 'jan 31 2008 12:00AM', 
  --   @cd_produto = 10, 
  --   @cd_grupo_produto = 0, 
  --   @cd_serie_produto = 0, 
  --   @cd_fase_produto = 1

    end

    delete from #GuiaProduto 
    where
      @cd_produto      = cd_produto      and
      @cd_fase_produto = cd_fase_produto and
      @cd_lote_produto = cd_lote_Produto

  end

  --acerto do Saldo do Lote

  -- exec pr_recomposicao_saldo_lote_produto  @cd_lote_informado = 'xx-jr-01'


  --acerto do Saldo dos Produtos

  --Real
  -- exec pr_recomposicao_saldo 
  --   @ic_parametro = 5, 
  --   @dt_fechamento = 'dez 31 2007 12:00AM',
  --   @dt_inicial = 'jan  1 2008 12:00AM', 
  --   @dt_final   = 'jan 31 2008 12:00AM', 
  --   @cd_produto = 10, 
  --   @cd_grupo_produto = 0, 
  --   @cd_serie_produto = 0, 
  --   @cd_fase_produto = 1

  --Reserva

  -- exec pr_recomposicao_saldo 
  --   @ic_parametro = 6, 
  --   @dt_fechamento = 'dez 31 2007 12:00AM',
  --   @dt_inicial = 'jan  1 2008 12:00AM', 
  --   @dt_final   = 'jan 31 2008 12:00AM', 
  --   @cd_produto = 10, 
  --   @cd_grupo_produto = 0, 
  --   @cd_serie_produto = 0, 
  --   @cd_fase_produto = 1

  --deleta a movimentação do Laudo / Lote
   
  --select * from lote_produto
  --select * from lote_numeracao_fracionamento

  select
    gfi.cd_laudo,
    lp.cd_lote_produto,
    gfi.cd_lote_fracionamento

  into
    #Laudo
  from
    guia_fracionamento_item gfi
    left outer join lote_produto lp on lp.nm_ref_lote_produto = gfi.cd_lote_fracionamento

  where cd_guia_fracionamento = @cd_guia_fracionamento

  declare @cd_laudo  int
  declare @cd_lote   int 

  while exists( select top 1 cd_laudo from #laudo )
  begin
    select top 1 
      @cd_laudo = cd_laudo,
      @cd_lote  = cd_lote_produto
    from
      #Laudo

    --Lote
    delete from lote_produto_saldo where cd_lote_produto = @cd_lote
    delete from lote_produto_item  where cd_lote_produto = @cd_lote
    delete from lote_produto       where cd_lote_produto = @cd_lote

    --Laudo

    delete from Laudo_Caracteristica
    where
      cd_laudo = @cd_laudo

    delete from Laudo_Aplicacao
    where
      cd_laudo = @cd_laudo
  
    delete from Laudo_Produto_Quimico
    where
      cd_laudo = @cd_laudo

    delete from Laudo
    where
      cd_laudo = @cd_laudo

    delete from #Laudo
    where
      cd_laudo = @cd_laudo

  end


  --select * from guia_fracionamento_item

  --deleta as Guias

  delete from guia_fracionamento_item where cd_guia_fracionamento = @cd_guia_fracionamento

  delete from guia_fracionamento      where cd_guia_fracionamento = @cd_guia_fracionamento

  delete from movimento_estoque       where cd_documento_movimento    = @cd_guia_fracionamento and
                                            cd_tipo_documento_estoque = 13 --guia de fracionamento


  drop table #Laudo
  

  declare @cd_requisicao_interna int

  select
    @cd_requisicao_interna = isnull(cd_requisicao_interna,0)
  from
    requisicao_interna
  where
   cd_guia_fracionamento = @cd_guia_fracionamento

  
  delete from requisicao_interna         where cd_guia_fracionamento     = @cd_guia_fracionamento
  delete from requisicao_interna_item    where cd_requisicao_interna     = @cd_requisicao_interna
  delete from movimento_estoque          where cd_documento_movimento    = @cd_requisicao_interna and
                                               cd_tipo_documento_estoque = 5 

  --select * from movimento_estoque where cd_documento_movimento = 9884

end

--ALTER TABLE EGISSQL.dbo.Requisicao_Interna ADD cd_guia_fracionamento INT  NULL 

