
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_calculo_afastamento
-------------------------------------------------------------------------------
--pr_geracao_calculo_afastamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo do Afastamento de Funcionário da Folha de Pagamento
--Data             : 12.06.2008
--Alteração        : 15.06.2008 - Ajuste Diveros
-- 16.06.2008 - Complemento dos Calculos
-- 07.11.2010 - Ajustes e Finalização de Desenvolvimento - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_geracao_calculo_afastamento
@cd_controle_folha      int      = 0,
@cd_usuario             int      = 0,
@dt_base_calculo_folha  datetime = '',
@dt_pagto_calculo_folha datetime = '',
@cd_tipo_calculo_folha  int 
as


print 'Cálculo do Afastamento de Funcionário da Folha de Pagamento'

declare @cd_lancamento_folha    int
declare @Tabela		     varchar(50)

select
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_departamento,
    f.cd_centro_custo,
    f.cd_vinculo_empregaticio,
    ef.cd_evento,
    ef.nm_evento,
--    fe.vl_funcionario_evento,

    --Cálculo do Evento

    fa.vl_evento_afastamento                                 as vl_calculo_folha,
                      

    0.00                                                     as vl_referencia_calculo,
    --fe.vl_funcionario_evento                     as vl_base_calculo_evento,

    fa.vl_evento_afastamento                                 as vl_base_calculo_evento,
                      

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto,
    fi.dt_afastamento,    
    ta.nm_tipo_afastamento,
    @cd_tipo_calculo_folha                       as cd_tipo_calculo_folha

  into
    #AF_Calculo_Folha

  from
    Funcionario f                                with (nolock) 
    inner join      Funcionario_Afastamento fa   with (nolock) on fa.cd_funcionario          = f.cd_funcionario and
                                                                  fa.dt_fim_afastamento is null                 and
                                                                  fa.dt_afastamento <= @dt_base_calculo_folha    

    left outer join Situacao_Funcionario    sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario


    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fa.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    left outer join Tipo_Afastamento       ta   with (nolock) on ta.cd_tipo_afastamento     = fi.cd_tipo_afastamento    
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and
    fi.dt_afastamento is not null  --or fi.dt_afastamento>@dt_base_calculo_folha


  --Geração dos Eventos no Movimento da Folha de Pagamento------------------------------------------------------------
  --movimento_folha

  set @Tabela = cast(DB_NAME()+'.dbo.Movimento_Folha' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
	
    while exists(Select top 1 'x' from movimento_folha where cd_lancamento_folha = @cd_lancamento_folha)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_folha, 'D'
    end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_folha, 'D'

    --select * from 
    --select * from movimento_folha

  select
      1                                     as cd_lancamento_folha,
      @dt_base_calculo_folha                as dt_lancamento_folha,
      1                                     as cd_tipo_lancamento_folha,
      c.cd_funcionario,
      c.vl_calculo_folha                    as vl_lancamento_folha,
      c.vl_referencia_calculo               as vl_hora_folha,
      'Cálculo do Afastamento'              as nm_obs_lancamento_folha,
      c.cd_evento,
      1                                     as cd_historico_folha,
      getdate()                             as dt_usuario,
      @cd_usuario                           as cd_usuario,
      'A'                                   as ic_tipo_lancamento,
      identity(int,1,1)                     as cd_controle,
      isnull(e.cd_tipo_calculo_folha,
             c.cd_tipo_calculo_folha)       as cd_tipo_calculo_folha,
      @dt_base_calculo_folha                as dt_base_calculo_folha,
      @dt_pagto_calculo_folha               as dt_pagto_calculo_folha,
      @cd_controle_folha                    as cd_controle_folha,
      null                                  as cd_movimento_evento 

    into
      #movimento_folha

    from
      #AF_Calculo_Folha c
      left outer join evento_folha e on e.cd_evento = c.cd_evento

    --Atualiza o Número do Lançamento do Movimento------------------------------------------------------

    update
      #movimento_folha
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle


    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha

    --select * from funcionario_afastamento

------------------------------------------------------------------------------
    --Geração dos Lançamentos de Desconto
-------------------------------------------------------------------------------

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
	
    while exists(Select top 1 'x' from movimento_folha where cd_lancamento_folha = @cd_lancamento_folha)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_folha, 'D'
    end

    select
      1                                     as cd_lancamento_folha,
      @dt_base_calculo_folha                as dt_lancamento_folha,
      1                                     as cd_tipo_lancamento_folha,
      c.cd_funcionario,
      c.vl_calculo_folha                    as vl_lancamento_folha,
      c.vl_referencia_calculo               as vl_hora_folha,
      'Cálculo do Afastameto Desconto'      as nm_obs_lancamento_folha,
      c.cd_evento_desconto                  as cd_evento,
      1                                     as cd_historico_folha,
      getdate()                             as dt_usuario,
      @cd_usuario                           as cd_usuario,
      'A'                                   as ic_tipo_lancamento,
      identity(int,1,1)                     as cd_controle,
      isnull(e.cd_tipo_calculo_folha,
             c.cd_tipo_calculo_folha)       as cd_tipo_calculo_folha,
      @dt_base_calculo_folha                as dt_base_calculo_folha,
      @dt_pagto_calculo_folha               as dt_pagto_calculo_folha,
      @cd_controle_folha                    as cd_controle_folha,
      null                                  as cd_movimento_evento 

    into
      #movimento_folha_desconto

    from
      #AF_Calculo_Folha c
      left outer join evento_folha e on e.cd_evento = c.cd_evento_desconto
    where
      isnull(c.cd_evento_desconto,0)<>0

    --Atualiza o Número do Lançamento do Movimento

    update
      #movimento_folha_desconto
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle

    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_desconto


