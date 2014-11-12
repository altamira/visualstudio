

CREATE PROCEDURE pr_atualizacao_movto_plano_financ
@ic_parametro      int,
@cd_plano_exclusao int,
@dt_atualizacao    datetime,
@cd_usuario        int,
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@ic_zera_movimento char(1)  = 'S'

as

  declare @cd_documento        int 
  declare @cd_movimento        int
  declare @cd_plano_financeiro int
  declare @cd_centro_custo     int
  declare @dt_documento        datetime
  declare @vl_documento        float
  declare @Hoje                datetime
  declare @Documento           varchar(15)


  SET DATEFORMAT mdy

  set @Hoje = cast( convert(varchar(10), GetDate(), 101) as datetime )

  set @cd_movimento = IsNUll(( select max(cd_movimento) from plano_financeiro_movimento),0) + 1
  set @cd_centro_custo     = 0
  set @cd_plano_financeiro = 0
  set @Documento           = ''

-----------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Atualização do Plano_Financeiro_Movimento de Entrada no Previsto.
-----------------------------------------------------------------------------------------
begin

--select 
--  if @ic_zera_movimento='S'
--  begin

    --Zera todos os Lançamentos no Plano Financeiro
   --select * from plano_financeiro_movimento
   --select * from plano_financeiro_saldo

    delete from plano_financeiro_movimento where isnull(ic_lancamento_automatico,'N')='S' and dt_movto_plano_financeiro>=@dt_inicial
    delete from plano_financeiro_saldo     where dt_saldo_plano_financeiro>=@dt_inicial

    --Remove a Data de atualização no Fluxo de Caixa / Plano Financeiro Movimento
 
    update
      documento_pagar
    set
      dt_fluxo_docto_pagar = null
    where
      dt_fluxo_docto_pagar>=@dt_inicial
    -- 
--    select count(*) from documento_pagar_pagamento

    update 
     documento_pagar_pagamento
    set
      dt_fluxo_doc_pagar_pagto = null
    where
      dt_fluxo_doc_pagar_pagto>=@dt_inicial

    update
      documento_receber
    set
      dt_fluxo_docto_receber = null
    where
      dt_fluxo_docto_receber>=@dt_inicial
 
    update
      documento_receber_pagamento
    set
      dt_fluxo_doc_rec_pagto = null
    where
      dt_fluxo_doc_rec_pagto>=@dt_inicial

--  end

--  print 'oi'

  -- Pegando as entradas previstas.

  set @cd_centro_custo     = 0
  set @cd_plano_financeiro = 0

  select 
    max(cd_identificacao)              as cd_identificacao,
    cd_plano_financeiro,
    isnull(cd_centro_custo,0)          as cd_centro_custo,
    sum( isnull(vl_saldo_documento,0)) as vl_previsto,
    dt_vencimento_documento
  into
    #VlPrevistoFinalEntrada
  from 
    Documento_Receber
  where
    --select * from documento_receber
    dt_emissao_documento >= @dt_inicial and
    dt_fluxo_docto_receber is null      and
    isnull(cd_plano_financeiro,0) > 0   and
    isnull(vl_saldo_documento,0) > 0    and
    dt_cancelamento_documento is null   and
    dt_devolucao_documento    is null  
  group by
    cd_plano_financeiro,
    cd_centro_custo,
    dt_vencimento_documento

  set @Documento = ( select top 1 cd_identificacao 
                     from 
                       #VlPrevistoFinalEntrada 
                     where dt_vencimento_documento is null )

  if @Documento is not null
  begin
    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a receber com data de vencimento nula, Número:  %s ',
      16, 1, @Documento)
    RETURN
  end
 
  while exists ( select 'x' from #VlPrevistoFinalEntrada)
  begin
    select top 1 
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @dt_documento        = dt_vencimento_documento,
      @vl_documento        = vl_previsto
    from
      #VlPrevistoFinalEntrada

    if exists ( select 'x' from Plano_Financeiro_Movimento
		where
                  cd_plano_financeiro       = @cd_plano_financeiro and
                  cd_centro_custo           = @cd_centro_custo     and
                  dt_movto_plano_financeiro = @dt_documento and
                  cd_tipo_lancamento_fluxo  = 1 and -- Previsto 
                  cd_tipo_operacao = 2 and          -- Entrada
                  isnull(ic_lancamento_automatico,'N') = 'S' and
                  cd_modulo = 56 )

      update Plano_Financeiro_Movimento
      set vl_plano_financeiro = isnull(vl_plano_financeiro,0) + @vl_documento
      where
        cd_plano_financeiro = @cd_plano_financeiro and
        cd_centro_custo     = @cd_centro_custo     and
        dt_movto_plano_financeiro = @dt_documento and
        cd_tipo_lancamento_fluxo = 1 and -- Previsto 
        cd_tipo_operacao = 2 and -- Entrada
        isnull(ic_lancamento_automatico,'N') = 'S' and
        cd_modulo = 56
    else
    begin
      Insert Into Plano_Financeiro_Movimento
        (cd_movimento,
         dt_movto_plano_financeiro,
         vl_plano_financeiro,
         nm_historico_movimento,
         cd_plano_financeiro,
         cd_centro_custo,
         cd_tipo_lancamento_fluxo,
         cd_historico_financeiro,
         cd_tipo_operacao,
         cd_moeda,
         cd_usuario,
         dt_usuario,
         ic_lancamento_automatico,
         cd_modulo)
      Values
        (@cd_movimento,
         @dt_documento,
         @vl_documento,
         'Atualização Automática SFI',
         @cd_plano_financeiro,
         @cd_centro_custo,
         1,   -- Valor Previsto
         0,   -- Em lançamento automático nada será preenchido.
         2,   -- Entrada
         1,   -- Por enquanto, só real.
         @cd_usuario,
         @Hoje,
         'S',
         56)  -- Financeiro.

      set @cd_movimento = IsNUll(( select max(cd_movimento) from PLano_Financeiro_Movimento),0) + 1

    end

    update Documento_Receber
    set 
      dt_fluxo_docto_receber = @Hoje
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      dt_vencimento_documento = @dt_documento


    delete from #VlPrevistoFinalEntrada
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      cd_centro_custo         = @cd_centro_custo and
      dt_vencimento_documento = @dt_documento

  end

end

---------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Atualizando Entradas no Realizado.
---------------------------------------------------------------------------------
begin

  set @cd_centro_custo     = 0
  set @cd_plano_financeiro = 0

  select
    max(d.cd_identificacao)                   as cd_identificacao,
    d.cd_plano_financeiro,
    isnull(d.cd_centro_custo,0)               as cd_centro_custo,
    drp.dt_pagamento_documento,
    drp.cd_documento_receber,
    sum(isnull(drp.vl_pagamento_documento,0)) as vl_pagto

  into #VlRealizadoFinalEntrada
  from
    Documento_Receber_Pagamento drp inner join
    Documento_Receber d on drp.cd_documento_receber = d.cd_documento_receber 
                          --and d.dt_fluxo_docto_receber is null 
  where
--    drp.dt_pagamento_documento >= @dt_inicial    and
    d.dt_emissao_documento >= @dt_inicial    and
    drp.dt_fluxo_doc_rec_pagto  is null      and
    isnull(cd_plano_financeiro,0) > 0        and
    --d.cd_plano_financeiro       is not null  and
    d.dt_cancelamento_documento is null      and
    d.dt_devolucao_documento    is null
  group by
    d.cd_plano_financeiro,
    d.cd_centro_custo,
    drp.dt_Pagamento_documento,
    drp.cd_documento_receber

--  select * from #VlRealizadoFinalEntrada

  set @Documento = ( select top 1 cd_identificacao 
                     from 
                       #VlRealizadoFinalEntrada 
                     where dt_Pagamento_documento is null )

  if @Documento is not null
  begin
    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a receber com data de pagamento nula, Número: %s',
      16, 1, @Documento)

    RETURN
  end

  while exists ( select 'x' from #VlRealizadoFinalEntrada )
  begin

    select top 1 
      @cd_documento        = cd_documento_receber,
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @dt_documento        = dt_pagamento_documento,
      @vl_documento        = vl_pagto
    from
      #VlRealizadoFinalEntrada

    if exists ( select 'x' from Plano_Financeiro_Movimento
		where
                  cd_plano_financeiro                   = @cd_plano_financeiro and
                  cd_centro_custo                       = @cd_centro_custo     and
                  dt_movto_plano_financeiro             = @dt_documento and
                  cd_tipo_lancamento_fluxo              = 2   and -- Realizado
                  cd_tipo_operacao                      = 2   and -- Entrada
                  isnull(ic_lancamento_automatico,'N')  = 'S' and
                  cd_modulo                             = 56 )

      update Plano_Financeiro_Movimento
      set vl_plano_financeiro = isnull(vl_plano_financeiro,0) + @vl_documento
      where
        cd_plano_financeiro       = @cd_plano_financeiro and
        cd_centro_custo           = @cd_centro_custo     and
        dt_movto_plano_financeiro = @dt_documento        and
        cd_tipo_lancamento_fluxo  = 2                    and -- Realizado
        cd_tipo_operacao          = 2                    and -- Entrada
        isnull(ic_lancamento_automatico,'N')  = 'S'      and
        cd_modulo                 = 56
    else
    begin
      Insert Into Plano_Financeiro_Movimento
        (cd_movimento,
         dt_movto_plano_financeiro,
         vl_plano_financeiro,
         nm_historico_movimento,
         cd_plano_financeiro,
         cd_centro_custo,
         cd_tipo_lancamento_fluxo,
         cd_historico_financeiro,
         cd_tipo_operacao,
         cd_moeda,
         cd_usuario,
         dt_usuario,
         ic_lancamento_automatico,
         cd_modulo)
      Values
        (@cd_movimento,
         @dt_documento,
         @vl_documento,
         'Atualização Automática SFI',
         @cd_plano_financeiro,
         @cd_centro_custo,
         2,   -- Valor Realizado
         0,   -- Em lançamento automático nada será preenchido.
         2,   -- Entrada
         1,   -- Por enquanto, só real.
         @cd_usuario,
         @Hoje,
         'S',
         56)  -- Financeiro
        
      set @cd_movimento = IsNUll(( select max(cd_movimento) from PLano_Financeiro_Movimento),0) + 1

    end    

    update 
      Documento_Receber_Pagamento
    set 
      dt_fluxo_doc_rec_pagto = @Hoje
    where
      cd_documento_receber   = @cd_documento and
      dt_pagamento_documento = @dt_documento

    delete from #VlRealizadoFinalEntrada
    where
      cd_plano_financeiro    = @cd_plano_financeiro and
      cd_centro_custo        = @cd_centro_custo     and
      dt_pagamento_documento = @dt_documento

  end    

end

------------------------------------------------------------------------
else if @ic_parametro = 3 -- Atualizando Saídas no Previsto.
------------------------------------------------------------------------
begin

  set @cd_centro_custo     = 0
  set @cd_plano_financeiro = 0

  select
    max(cd_identificacao_document) as cd_identificacao_document,
    cd_plano_financeiro,
    isnull(cd_centro_custo,0) as cd_centro_custo,
    dt_vencimento_documento,
    sum( isnull(vl_saldo_documento_pagar,0) )  as vl_previsto
  into 
    #VlPrevistoFinalSaida
  from
    Documento_Pagar
  where
    dt_emissao_documento_paga >=@dt_inicial and
    dt_fluxo_docto_pagar is null            and
    isnull(cd_plano_financeiro,0) > 0       and
    --cd_plano_financeiro  is not null        and 
    isnull(vl_saldo_documento_pagar,0) > 0  and
    dt_cancelamento_documento is null
  group by
    cd_plano_financeiro,
    cd_centro_custo,
    dt_vencimento_documento


  set @Documento = ( select top 1 cd_identificacao_document 
                     from 
                       #VlPrevistoFinalSaida 
                     where dt_vencimento_documento is null )

  if @Documento is not null
  begin

    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a pagar com data de vencimento nula, Número: %s',
      16, 1, @Documento)
    RETURN
  end


  while exists ( select top 1 'x' from #VlPrevistoFinalSaida)
  begin
    select top 1 
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @dt_documento        = dt_vencimento_documento,
      @vl_documento        = vl_previsto
    from
      #VlPrevistoFinalSaida

    if exists ( select 'x' from Plano_Financeiro_Movimento
		where
                  cd_plano_financeiro       = @cd_plano_financeiro and
                  cd_centro_custo           = @cd_centro_custo     and
                  dt_movto_plano_financeiro = @dt_documento        and
                  cd_tipo_lancamento_fluxo  = 1                    and -- Previsto 
                  cd_tipo_operacao          = 1                    and -- Saída
                  isnull(ic_lancamento_automatico,'N') = 'S'                  and
                  cd_modulo                            = 56 )

      update Plano_Financeiro_Movimento
      set 
         vl_plano_financeiro = isnull(vl_plano_financeiro,0) + @vl_documento
      where
        cd_plano_financeiro       = @cd_plano_financeiro and
        cd_centro_custo           = @cd_centro_custo     and
        dt_movto_plano_financeiro = @dt_documento        and
        cd_tipo_lancamento_fluxo  = 1                    and -- Previsto 
        cd_tipo_operacao          = 1                    and -- Saída
        isnull(ic_lancamento_automatico,'N')  = 'S'                  and
        cd_modulo                 = 56
    else
    begin
      Insert Into Plano_Financeiro_Movimento
        (cd_movimento,
         dt_movto_plano_financeiro,
         vl_plano_financeiro,
         nm_historico_movimento,
         cd_plano_financeiro,
         cd_centro_custo,
         cd_tipo_lancamento_fluxo,
         cd_historico_financeiro,
         cd_tipo_operacao,
         cd_moeda,
         cd_usuario,
         dt_usuario,
         ic_lancamento_automatico,
         cd_modulo)
      Values
        (@cd_movimento,
         @dt_documento,
         @vl_documento,
         'Atualização Automática SFI',
         @cd_plano_financeiro,
         @cd_centro_custo,
         1,   -- Valor Previsto
         0,   -- Em lançamento automático nada será preenchido.
         1,   -- Saída
         1,   -- Por enquanto, só real.
         @cd_usuario,
         @Hoje,
         'S',
         56)  -- Financeiro

      set @cd_movimento = IsNUll(( select max(cd_movimento) from PLano_Financeiro_Movimento),0) + 1

    end

    update Documento_Pagar
    set dt_fluxo_docto_pagar = @Hoje
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      dt_vencimento_documento = @dt_documento

    delete from #VlPrevistoFinalSaida
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      cd_centro_custo         = @cd_centro_custo     and
      dt_vencimento_documento = @dt_documento

  end

end

-------------------------------------------------------------------------
else if @ic_parametro = 4 -- Atualizando Saídas no Realizado.
-------------------------------------------------------------------------
begin


  select
    max(d.cd_identificacao_document)          as cd_identificacao_document,
    dpp.cd_documento_pagar,
    d.cd_plano_financeiro,
    isnull(d.cd_centro_custo,0)               as cd_centro_custo,
    dpp.dt_pagamento_documento,
    sum(isnull(dpp.vl_pagamento_documento,0)) as vl_pagto

  into #VlRealizadoFinalSaida
  from
    Documento_Pagar_Pagamento dpp 
    inner join Documento_Pagar d on dpp.cd_documento_pagar = d.cd_documento_pagar 
                                         --and
                                         --d.dt_fluxo_docto_pagar is null 
  where
    d.dt_emissao_documento_paga >=@dt_inicial and
--    d.dt_emissao_documento_paga between @dt_inicial and @dt_final and
    dpp.dt_fluxo_doc_pagar_pagto is null and
    isnull(cd_plano_financeiro,0) > 0 --   and
    --d.cd_plano_financeiro        is not null
  group by
    dpp.cd_documento_pagar,
    d.cd_plano_financeiro,
    d.cd_centro_custo,
    dpp.dt_Pagamento_documento

  set @Documento = ( select top 1 cd_identificacao_document 
                     from 
                       #VlRealizadoFinalSaida 
                     where dt_pagamento_documento is null )


  if @Documento is not null
  begin
    print('É nulo!')
    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a pagar com data de pagamento nula, Número: %s',
      16, 1, @Documento)
    RETURN
  end


--  select * from #VlRealizadoFinalSaida
  

  while exists ( select 'x' from #VlRealizadoFinalSaida )
  begin

    select top 1 
      @cd_documento        = cd_documento_pagar,
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @dt_documento        = dt_pagamento_documento,
      @vl_documento        = vl_pagto
    from
      #VlRealizadoFinalSaida

    if exists ( select 'x' from Plano_Financeiro_Movimento
		where
                  cd_plano_financeiro       = @cd_plano_financeiro and
                  cd_centro_custo           = @cd_centro_custo     and
                  dt_movto_plano_financeiro = @dt_documento        and
                  cd_tipo_lancamento_fluxo  = 2                    and -- Realizado
                  cd_tipo_operacao          = 1                    and -- Saída
                  isnull(ic_lancamento_automatico,'N')  = 'S'      and
                  cd_modulo = 56 )

      update 
        Plano_Financeiro_Movimento
      set 
        vl_plano_financeiro = isnull(vl_plano_financeiro,0) + @vl_documento
      where
        cd_plano_financeiro       = @cd_plano_financeiro and
        cd_centro_custo           = @cd_centro_custo     and
        dt_movto_plano_financeiro = @dt_documento        and
        cd_tipo_lancamento_fluxo  = 2                    and -- Realizado
        cd_tipo_operacao          = 1                    and -- Saída
        isnull(ic_lancamento_automatico,'N')  = 'S'      and
        cd_modulo                 = 56
    else
    begin
      Insert Into Plano_Financeiro_Movimento
        (cd_movimento,
         dt_movto_plano_financeiro,
         vl_plano_financeiro,
         nm_historico_movimento,
         cd_plano_financeiro,
         cd_centro_custo,
         cd_tipo_lancamento_fluxo,
         cd_historico_financeiro,
         cd_tipo_operacao,
         cd_moeda,
         cd_usuario,
         dt_usuario,
         ic_lancamento_automatico,
         cd_modulo)
      Values
        (@cd_movimento,
         @dt_documento,
         @vl_documento,
         'Atualização Automática SFI',
         @cd_plano_financeiro,
         @cd_centro_custo,
         2,   -- Valor Realizado
         0,   -- Em lançamento automático nada será preenchido.
         1,   -- Saída
         1,   -- Por enquanto, só real.
         @cd_usuario,
         @Hoje,
         'S',
         56)  -- Financeiro
        
      set @cd_movimento = IsNUll(( select max(cd_movimento) from PLano_Financeiro_Movimento),0) + 1

    end    

    update Documento_Pagar_Pagamento
    set dt_fluxo_doc_pagar_pagto = @Hoje
    where
      cd_documento_pagar     = @cd_documento and
      dt_pagamento_documento = @dt_documento

    delete from #VlRealizadoFinalSaida
    where
      cd_plano_financeiro    = @cd_plano_financeiro and
      cd_centro_custo        = @cd_centro_custo     and
      dt_pagamento_documento = @dt_documento

  end    

end

-------------------------------------------------------------------------------
else if @ic_parametro = 5 -- Exclusões das Movimentações de Entrada Previstas.
-------------------------------------------------------------------------------
begin

  -- Pegando as entradas previstas.
  select 
    max(cd_identificacao)             as cd_identificacao,
    cd_plano_financeiro,
    sum(isnull(vl_saldo_documento,0)) as vl_previsto,
    dt_vencimento_documento
  into
    #VlPrevistoExclusaoEntrada
  from 
    Documento_Receber
  where
    dt_fluxo_docto_receber = @dt_atualizacao and
    (cd_plano_financeiro = @cd_plano_exclusao or @cd_plano_exclusao = 0) and
    isnull(cd_plano_financeiro,0) > 0
    --cd_plano_financeiro is not null
  group by
    cd_plano_financeiro,
    dt_vencimento_documento

  set @Documento = ( select top 1 cd_identificacao
                     from 
                       #VlPrevistoExclusaoEntrada
                     where dt_vencimento_documento is null )

  if @Documento is not null
  begin

    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a receber com data de vencimento nula, Número: %s ',
      16, 1, @Documento)
    RETURN
  end


  while exists ( select 'x' from #VlPrevistoExclusaoEntrada)
  begin
    select top 1 
      @cd_plano_financeiro = cd_plano_financeiro,
      @dt_documento        = dt_vencimento_documento,
      @vl_documento        = isnull(vl_previsto,0)
    from
      #VlPrevistoExclusaoEntrada

    update Plano_Financeiro_Movimento
    set vl_plano_financeiro = isnull(vl_plano_financeiro,0) - @vl_documento
    where
      cd_plano_financeiro = @cd_plano_financeiro and
      dt_movto_plano_financeiro = @dt_documento and
      cd_tipo_lancamento_fluxo = 1 and -- Previsto 
      cd_tipo_operacao = 2 and -- Entrada
      isnull(ic_lancamento_automatico,'N') = 'S' and
      cd_modulo = 56


    update Documento_Receber
    set dt_fluxo_docto_receber = null
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      dt_vencimento_documento = @dt_documento


    delete from #VlPrevistoExclusaoEntrada
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      dt_vencimento_documento = @dt_documento

  end

  delete from Plano_Financeiro_Movimento
  where cast(str(vl_plano_financeiro,25,2) as decimal(25,2)) = 0

end

---------------------------------------------------------------------------------
else if @ic_parametro = 6 -- Excluindo Entradas no Realizado.
---------------------------------------------------------------------------------
begin

  select
    max(d.cd_identificacao)         as cd_identificacao, 
    sum(drp.vl_pagamento_documento) as vl_pagto,
    drp.dt_pagamento_documento,
    d.cd_plano_financeiro,
    drp.cd_documento_receber
  into #VlRealizadoExclusaoEntrada
  from
    Documento_Receber_Pagamento drp left outer join
    Documento_Receber d on drp.cd_documento_receber = d.cd_documento_receber and
                           d.dt_fluxo_docto_receber is null
  where
    drp.dt_fluxo_doc_rec_pagto = @dt_atualizacao and
    (cd_plano_financeiro = @cd_plano_exclusao or @cd_plano_exclusao = 0) and
    isnull(cd_plano_financeiro,0) > 0  -- and
    --cd_plano_financeiro is not null
  group by
    d.cd_plano_financeiro,
    drp.dt_Pagamento_documento,
    drp.cd_documento_receber

  set @Documento = ( select top 1 cd_identificacao 
                     from 
                       #VlRealizadoExclusaoEntrada
                     where dt_pagamento_documento is null )

  if @Documento is not null

  begin
    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a receber com data de pagamento nula, Número: %s ',
      16, 1, @Documento)
    RETURN
  end

  while exists ( select 'x' from #VlRealizadoExclusaoEntrada )
  begin

    select top 1 
      @cd_documento        = cd_documento_receber,
      @cd_plano_financeiro = cd_plano_financeiro,
      @dt_documento        = dt_pagamento_documento,
      @vl_documento        = vl_pagto
    from
      #VlRealizadoExclusaoEntrada

    update Plano_Financeiro_Movimento
    set vl_plano_financeiro = isnull(vl_plano_financeiro,0) - @vl_documento
    where
      cd_plano_financeiro                   = @cd_plano_financeiro and
      dt_movto_plano_financeiro             = @dt_documento and
      cd_tipo_lancamento_fluxo              = 2 and -- Realizado
      cd_tipo_operacao                      = 2 and -- Entrada
      isnull(ic_lancamento_automatico,'N')  = 'S' and
      cd_modulo                             = 56
        
    update Documento_Receber_Pagamento
    set dt_fluxo_doc_rec_pagto = Null
    where
      cd_documento_receber   = @cd_documento and
      dt_pagamento_documento = @dt_documento

    delete from #VlRealizadoExclusaoEntrada
    where
      cd_plano_financeiro = @cd_plano_financeiro and
      dt_pagamento_documento = @dt_documento
  end    

  delete from Plano_Financeiro_Movimento
  where cast(str(vl_plano_financeiro,25,2) as decimal(25,2)) = 0

end

------------------------------------------------------------------------
else if @ic_parametro = 7 -- Excluindo Saídas no Previsto.
------------------------------------------------------------------------
begin

  select
    max(cd_identificacao_document) as cd_identificacao_document,
    cd_plano_financeiro,
    cd_centro_custo,
    dt_vencimento_documento,
    sum( isnull(vl_saldo_documento_pagar,0) ) as vl_previsto
  into 
    #VlPrevistoExclusaoSaida
  from
    Documento_Pagar
  where
    dt_fluxo_docto_pagar = @dt_atualizacao and
    (cd_plano_financeiro = @cd_plano_exclusao or @cd_plano_exclusao = 0) and
    isnull(cd_plano_financeiro,0) > 0--   and
    --cd_plano_financeiro is not null
  group by
    cd_plano_financeiro,
    cd_centro_custo,
    dt_vencimento_documento

  set @Documento = ( select top 1 cd_identificacao_document 
                     from 
                       #VlPrevistoExclusaoSaida
                     where dt_vencimento_documento is null )

  if @Documento is not null
  begin
    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a pagar com data de vencimento nula, Número: %s ',
      16, 1,@Documento)
    RETURN
  end


  while exists ( select 'x' from #VlPrevistoExclusaoSaida)
  begin
    select top 1 
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @dt_documento        = dt_vencimento_documento,
      @vl_documento        = vl_previsto
    from
      #VlPrevistoExclusaoSaida

    update 
      Plano_Financeiro_Movimento
    set 
      vl_plano_financeiro = vl_plano_financeiro - @vl_documento
    where
      cd_plano_financeiro       = @cd_plano_financeiro and
      cd_centro_custo           = @cd_centro_custo     and
      dt_movto_plano_financeiro = @dt_documento        and
      cd_tipo_lancamento_fluxo  = 1                    and -- Previsto 
      cd_tipo_operacao          = 1                    and -- Saída
      ic_lancamento_automatico  = 'S'                  and
      cd_modulo                 = 56

    update Documento_Pagar
    set dt_fluxo_docto_pagar = Null
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      cd_centro_custo         = @cd_centro_custo     and
      dt_vencimento_documento = @dt_documento


    delete from #VlPrevistoExclusaoSaida
    where
      cd_plano_financeiro     = @cd_plano_financeiro and
      cd_centro_custo         = @cd_centro_custo    and
      dt_vencimento_documento = @dt_documento

  end

  delete from Plano_Financeiro_Movimento
  where cast(str(vl_plano_financeiro,25,2) as decimal(25,2)) = 0


end

-------------------------------------------------------------------------
else if @ic_parametro = 8 -- Excluindo Saídas no Realizado.
-------------------------------------------------------------------------
begin

  select
    max(d.cd_identificacao_document) as cd_identificacao_document,
    dpp.cd_documento_pagar,
    d.cd_plano_financeiro,
    d.cd_centro_custo,
    dpp.dt_pagamento_documento,
    sum(isnull(dpp.vl_pagamento_documento,0)) as vl_pagto

  into #VlRealizadoExclusaoSaida
  from
    Documento_Pagar_Pagamento dpp inner join
    Documento_Pagar d on dpp.cd_documento_pagar = d.cd_documento_pagar 
                         --and
                         --d.dt_fluxo_docto_pagar is null
  where
    dpp.dt_fluxo_doc_pagar_pagto = @dt_atualizacao and
    (cd_plano_financeiro = @cd_plano_exclusao or @cd_plano_exclusao = 0) and
    isnull(cd_plano_financeiro,0) > 0   --and
    --cd_plano_financeiro is not null
  group by
    dpp.cd_documento_pagar,
    d.cd_plano_financeiro,
    d.cd_centro_custo,
    dpp.dt_Pagamento_documento

  set @Documento = ( select top 1 cd_identificacao_document 
                     from 
                       #VlRealizadoExclusaoSaida
                     where dt_pagamento_documento is null )

  if @Documento is not null
  begin
    RAISERROR ('Atenção! Não foi possível executar ! Há documentos a pagar com data de pagamento nula, Número: %s ',
      16, 1,@Documento)
    RETURN
  end


  while exists ( select 'x' from #VlRealizadoExclusaoSaida )
  begin

    select top 1 
      @cd_documento        = cd_documento_pagar,
      @cd_plano_financeiro = cd_plano_financeiro,
      @cd_centro_custo     = cd_centro_custo,
      @dt_documento        = dt_pagamento_documento,
      @vl_documento        = vl_pagto
    from
      #VlRealizadoExclusaoSaida

    update Plano_Financeiro_Movimento
    set vl_plano_financeiro = vl_plano_financeiro - @vl_documento
    where
      cd_plano_financeiro = @cd_plano_financeiro and
      cd_centro_custo     = @cd_centro_custo     and
      dt_movto_plano_financeiro = @dt_documento and
      cd_tipo_lancamento_fluxo = 2 and -- Realizado
      cd_tipo_operacao = 1 and -- Saída
      ic_lancamento_automatico = 'S' and
      cd_modulo = 56

    update Documento_Pagar_Pagamento
    set dt_fluxo_doc_pagar_pagto = Null
    where
      cd_documento_pagar     = @cd_documento    and
--    cd_centro_custo        = @cd_centro_custo and
      dt_pagamento_documento = @dt_documento

    delete from #VlRealizadoExclusaoSaida
    where
      cd_plano_financeiro    = @cd_plano_financeiro and
      cd_centro_custo        = @cd_centro_custo     and
      dt_pagamento_documento = @dt_documento

  end    

  delete from Plano_Financeiro_Movimento
  where cast(str(vl_plano_financeiro,25,2) as decimal(25,2)) = 0

end

