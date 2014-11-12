
-------------------------------------------------------------------------------
--sp_helptext pr_calculo_folha_pagamento
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cálculo da Folha de Pagamento
--Data             : 12.06.2008
--Alteração        : 15.06.2008 - Ajuste Diveros
-- 16.06.2008 - Complemento dos Calculos
-- 07.11.2010 - Ajustes e Finalização de Desenvolvimento - Carlos Fernandes
-- 29.01.2011 - Cálculo da Folha de Acordo com o Tipo de Regime/Vínculo Empregatício
---------------------------------------------------------------------------------------
create procedure pr_calculo_folha_pagamento
@cd_controle_folha      int      = 0,
@cd_usuario             int      = 0
as

--select 
--select * from tipo_regime_funcionario
--select * from vinculo_empregaticio

print 'Cálculo da Folha de Pagamento'

-- if @ic_tipo_calculo = 0
-- begin
--    exit
-- end

declare @cd_forma_calculo       int
declare @cd_evento_calculo      int
declare @ic_gera_movimento      char(1) 
declare @cd_lancamento_folha    int
declare @dt_base_calculo_folha  datetime 
declare @dt_pagto_calculo_folha datetime 
declare @cd_tipo_calculo_folha  int
declare @cd_funcionario_calculo int
declare @vl_arredondamento      decimal(25,2)
declare @cd_roteiro_calculo     int
declare @cd_funcionario_roteiro int
declare @vl_base_calculo        decimal(25,2)
declare @cd_faixa_irrf          int
declare @pc_13salario_parcela   float
declare @ic_evento_incidencia   char(1)
declare @cd_tipo_regime         int              -- Vínculo Empregatício


--Busca o Controle de Cálculo da folha

select
  @cd_tipo_calculo_folha  = isnull(cd_tipo_calculo_folha,0),
  @dt_base_calculo_folha  = isnull(dt_base,''),
  @dt_pagto_calculo_folha = isnull(dt_pagamento,''),
  @vl_arredondamento      = isnull(vl_arredondamento,0)
from
  Controle_Folha with (nolock) 
where
  cd_controle_folha = @cd_controle_folha


-------------------------------------------------------------------------------
--Busca o Tipo de Cálculo da folha
-------------------------------------------------------------------------------
--select * from tipo_calculo_folha

select
  @cd_forma_calculo  = isnull(cd_forma_calculo,0),
  @cd_evento_calculo = isnull(cd_evento,0),
  @ic_gera_movimento = isnull(ic_gera_movimento,'N'),
  @cd_tipo_regime    = isnull(cd_tipo_regime,0)

from
  Tipo_Calculo_Folha with (nolock) 
where
  cd_tipo_calculo_folha = @cd_tipo_calculo_folha

--select @cd_tipo_calculo_folha,@cd_tipo_regime,@cd_forma_calculo,@ic_gera_movimento

-------------------------------------------------------------------------------
--Cálculo da Folha de Pagamento
-------------------------------------------------------------------------------

  declare @Tabela		     varchar(50)
  declare @cd_calculo_folha          int
  declare @pc_adto_empresa           decimal(25,2)
  declare @qt_hora_mes_folha         decimal(25,2)

-------------------------------------------------------------------------------
--Parâmetros de Cálculo
-------------------------------------------------------------------------------
--select * from parametro_folha

  select
    @pc_adto_empresa      = isnull(pc_adto_empresa,40),
    @qt_hora_mes_folha    = isnull(qt_hora_mes_folha,220),
    @vl_arredondamento    = case when @vl_arredondamento=0 then isnull(vl_arredondamento_empresa,0) else 0 end,
    @pc_13salario_parcela = isnull(pc_13salario_parcela,50)
  from
    parametro_folha    with (nolock) 
  where
    cd_empresa = dbo.fn_empresa() 

  -- Nome da Tabela usada na geração e liberação de códigos

  set @Tabela = cast(DB_NAME()+'.dbo.Calculo_Folha' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
	
  while exists(Select top 1 'x' from calculo_folha where cd_calculo_folha = @cd_calculo_folha)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'

-------------------------------------------------------------------------------
--Deleta o Cálculo do Movimento já Calculado
-------------------------------------------------------------------------------

  -- Cálculo do Funcionário

  delete from funcionario_calculo
  where
    cd_controle_folha = @cd_controle_folha

  --Movimento da Folha Gerado

  delete from movimento_folha
  where
    cd_controle_folha = @cd_controle_folha and
    isnull(ic_tipo_lancamento,'M') = 'A'   --Somente os Lançamentos Automáticos.
    

  --Cálculo Anterior
  
  delete from calculo_folha
  where
    cd_tipo_calculo_folha = @cd_tipo_calculo_folha and
    cd_controle_folha     = @cd_controle_folha


--Verifica a Forma de Cálculo

-------------------------------------------------------------------------------
--Atualiza o cadastro de Funcionários com a rotina de dependentes
-------------------------------------------------------------------------------
exec pr_atualiza_funcionario_dependente 0

-------------------------------------------------------------------------------
--Adiantamento de Salários
-------------------------------------------------------------------------------

if @cd_forma_calculo = 1 
begin

  --Busca Todos os Funcionários-------------------------------------------------------------------

  select
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_departamento,
    f.cd_centro_custo,
    f.cd_vinculo_empregaticio,
    ef.cd_evento,
    ef.nm_evento,

    --fe.vl_funcionario_evento,

--     case when isnull(ic_hora_natureza_evento,'N')='S' 
--     then
--       --Horas
--        fe.vl_funcionario_evento * 
--        case when isnull(fe.qt_hora_funcionario_evento,0)=0 
--        then 
--          @qt_hora_mes_folha
--        else
--          isnull(fe.qt_hora_funcionario_evento,0)
--        end
--     else
--       fe.vl_funcionario_evento
--     end                                                      as vl_funcionario_evento,
                      
   case when isnull(ic_hora_natureza_evento,'N')='S' 
   then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_funcionario_evento,


    --Horas
    isnull(fe.qt_hora_funcionario_evento,@qt_hora_mes_folha) as qt_hora_funcionario_evento,

    --Cálculo do Adiantamento------------------------------------------------------------------------
    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
      (@pc_adto_empresa/100) * fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
    (@pc_adto_empresa/100) * fe.vl_funcionario_evento
    end                                          as vl_adiantamento,

    --Cálculo do Evento-----------------------------------------------------------------------

    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                            as vl_base_calculo_evento,

--    fe.vl_funcionario_evento                     as vl_base_calculo_evento,

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto    

  into
    #Auxiliar_Calculo_Folha

  from
    Funcionario f                               with (nolock) 
   
    left outer join Situacao_Funcionario   sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario

    left outer join Funcionario_Evento     fe   with (nolock) on fe.cd_funcionario          = f.cd_funcionario and
                                                               isnull(fe.ic_ativo_calculo,'S') = 'S'

    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fe.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and  --Executa o Cálculo
    isnull(fe.vl_funcionario_evento,0) > 0        and  --Valor do Evento
    isnull(ef.ic_salario_evento,'N')   = 'S'      and
    isnull(fi.ic_adiantamento,'S')     = 'S'      and  --Verifica se Calculo o Adiantamento para o Funcionário
    isnull(fe.ic_ativo_calculo,'N' )   = 'S'           --Verifica se o Evento está Ativo para o Funcionário
    and
    fi.dt_demissao is null    --or fi.dt_demissao>@dt_base_calculo_folha
    and
    fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha
    and
    fi.cd_tipo_regime = @cd_tipo_regime

--   select @cd_tipo_regime
--   select * from #Auxiliar_calculo_folha

  --select * from funcionario_informacao

  --Montagem da Tabela de Cálculo
  --select * from calculo_folha

  select
    1                                         as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha                    as dt_base_calculo_folha,
    @cd_evento_calculo                        as cd_evento,
    cf.qt_hora_funcionario_evento             as vl_referencia_calculo,
   
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_provento_calculo,

    0.00                                      as vl_desconto_calculo,

    @pc_adto_empresa                          as pc_calculo,

--     dbo.fn_arredondamento(cf.vl_adiantamento,
--                           @vl_arredondamento) as vl_calculo_folha,
-- 
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_calculo_folha,

    cf.cd_departamento,
    null                                      as cd_seccao,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    cf.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)             as mm_calculo_folha,
    year(@dt_base_calculo_folha)              as aa_calculo_folha,
    cf.cd_centro_custo,
    @dt_pagto_calculo_folha                   as dt_pagto_calculo_folha,
    'A'                                       as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha                    as cd_tipo_calculo_folha,
    identity(int,1,1)                         as cd_controle,
    @cd_controle_folha                        as cd_controle_folha,
    null                                      as cd_ap,
    cf.vl_base_calculo_evento,
    isnull(ef.cd_evento_desconto,0)           as cd_evento_desconto,

    case when isnull(ef.cd_tipo_evento,0) = 1 then
      cf.qt_hora_funcionario_evento
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      cf.qt_hora_funcionario_evento
    else
      0
   end                                        as vl_ref_desconto_calculo,

   case when isnull(ef.cd_tipo_evento,0) = 1 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_provento,

   case when isnull(ef.cd_tipo_evento,0) = 2 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_desconto
 
--select * from evento_folha

  into
    #Calculo_Folha    

  from
    #Auxiliar_Calculo_Folha cf         with (nolock)
    left outer join Evento_Folha ef    with (nolock) on ef.cd_evento               = @cd_evento_calculo	 
    left outer join movimento_folha mf with (nolock) on mf.dt_lancamento_folha     = @dt_base_calculo_folha and                        
                                                        mf.cd_evento               = @cd_evento_calculo	    and
                                                        mf.cd_funcionario          = cf.cd_funcionario      and
                                                        mf.ic_tipo_lancamento      = 'M'         





  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Calculo_Folha
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Calculo_Folha

--  select * from #Calculo_Folha

--  print '1'
    
  --Gera o Movimento da Folha de Pagamento-----------------------------------------------------------------

  if @ic_gera_movimento = 'S'
  begin

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
      'Cálculo do Adiantamento'             as nm_obs_lancamento_folha,
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
      #Calculo_Folha c    
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

    --select * from #movimento_folha
    --select * from movimento_folha
-------------------------------------------------------------------------------
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
      'Cálculo do Adiantamento'             as nm_obs_lancamento_folha,
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
      #Calculo_Folha c
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


-------------------------------------------------------------------------------
    --Imposto de Renda
-------------------------------------------------------------------------------
    --select * from Roteiro_Calculo_Folha

    select
--      top 1
      rcf.cd_roteiro_calculo,
      ef.cd_evento,
      isnull(ei.ic_evento_incidencia,'N') as ic_evento_incidencia

    into
      #Roteiro_Calculo_Adiantamento

    from
      Roteiro_Calculo_Folha rcf       with (nolock) 
      inner join Evento_Folha ef      with (nolock) on ef.cd_roteiro_calculo = rcf.cd_roteiro_calculo
      inner join Evento_Incidencia ei with (nolock) on ei.cd_evento          = ef.cd_evento

    where
      ef.cd_tipo_calculo_folha = @cd_tipo_calculo_Folha and
      ef.cd_tipo_evento        = 1                      and 
      isnull(ei.ic_evento_incidencia,'N')='S' 

    --select @cd_tipo_calculo_folha
    --select * from   #Roteiro_Calculo_Adiantamento

    --select * from evento_incidencia
    --select * from tipo_evento
    --select * from evento_folha 

    --print 'roteiro'
    --select * from  #Roteiro_Calculo_Adiantamento

    --select * from #Auxiliar_Calculo_Folha

    while exists ( select top 1 cd_roteiro_calculo from #Roteiro_Calculo_Adiantamento )
    begin

      select top 1 
        @cd_roteiro_calculo = cd_roteiro_calculo
      from 
        #Roteiro_Calculo_Adiantamento

      select
        a.cd_funcionario,
        case when a.vl_base_calculo_evento <> cf.vl_calculo_folha then
          cf.vl_calculo_folha
        else
          a.vl_base_calculo_evento
        end                                  as vl_base_calculo_evento
      into
        #Funcionario_Roteiro_Adiantamento 
        
      from    
        #Auxiliar_Calculo_Folha a
        left outer join #Calculo_Folha cf on cf.cd_funcionario = a.cd_funcionario
 
      --select * from #Funcionario_Roteiro_Adiantamento


      while exists( select top 1 cd_funcionario from #Funcionario_Roteiro_Adiantamento )
      begin

        select top 1 
           @cd_funcionario_roteiro = cd_funcionario,
           @vl_base_calculo        = vl_base_calculo_evento
        from
           #Funcionario_Roteiro_Adiantamento
   
        --select @cd_controle_folha,@cd_roteiro_calculo,@dt_base_calculo_folha,@vl_base_calculo,@cd_funcionario_roteiro

        --Geração do Lançamento Automática para Cálculo
        exec pr_roteiro_calculo_folha 
             @cd_controle_folha,
             @cd_roteiro_calculo,
             @dt_base_calculo_folha,
             @dt_pagto_calculo_folha,
             @vl_base_calculo,        
             @cd_funcionario_roteiro,         
             @cd_usuario,
             'S',
             @ic_evento_incidencia

             --@vl_retorno = @cd_faixa_irrf output

        delete from #Funcionario_Roteiro_Adiantamento where cd_funcionario = @cd_funcionario_roteiro
      
      end

      drop table #Funcionario_Roteiro_Adiantamento

      delete from #Roteiro_Calculo_Adiantamento where cd_roteiro_calculo = @cd_roteiro_calculo

    end

-------------------------------------------------------------------------------
    --Atualiza a Tabela de Cálculo do Funcionário
-------------------------------------------------------------------------------
-- 
    select
      cf.cd_controle_folha,
      cf.cd_funcionario,
      sum( isnull(cf.vl_provento_calculo,0))   as vl_total_provento,
      sum( isnull(cf.vl_desconto_calculo,0))   as vl_total_desconto,
      sum( isnull(cf.vl_provento_calculo,0))
      - 
      sum( isnull(cf.vl_desconto_calculo,0))    as vl_total_liquido,
      sum( isnull(cf.vl_base_calculo_evento,0)) as vl_salario_base,
      sum( isnull(cf.vl_calculo_folha,0))       as vl_adiantamento
      
    into
      #Funcionario_Calculo

    from
      Calculo_Folha cf           with (nolock) 
      inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
    where
      cf.cd_controle_folha     = @cd_controle_folha and
      cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

    group by
      cf.cd_funcionario,
      cf.cd_controle_folha

    --Atualiza o Código da Tabela de Cálculo do funcionário


    update
      Funcionario_Calculo
    set
       vl_total_provento = x.vl_total_provento,
       vl_total_desconto = x.vl_total_desconto,
       vl_total_liquido  = x.vl_total_liquido,
       vl_salario_base   = x.vl_salario_base,
       vl_adiantamento   = x.vl_adiantamento

       from 
         funcionario_calculo fc 
         inner join #funcionario_calculo x on
               fc.cd_funcionario    = x.cd_funcionario         and
               fc.dt_base_calculo   = @dt_base_calculo_folha  and
               fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
               fc.cd_controle_folha = x.cd_controle_folha



  end

  --Atualiza as Bases-----------------------------------------------

  
  --Deletas as Tabelas Auxiliares

  drop table #funcionario_calculo
  drop table #Calculo_Folha
  drop table #Auxiliar_Calculo_Folha
  drop table #movimento_folha
  drop table #movimento_folha_desconto


end

-------------------------------------------------------------------------------
--Cálculo dos Eventos da Folha
-------------------------------------------------------------------------------

if @cd_forma_calculo = 2
begin

  --Gera Movimento de Funcionários Afastados

  exec pr_geracao_calculo_afastamento 
       @cd_controle_folha,
       @cd_usuario,
       @dt_base_calculo_folha,
       @dt_pagto_calculo_folha,
       @cd_tipo_calculo_folha


  --Busca Todos os Funcionários------------------------------------------------------

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

    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_funcionario_evento,
                      

    isnull(fe.qt_hora_funcionario_evento,@qt_hora_mes_folha) as qt_hora_funcionario_evento,

    --fe.vl_funcionario_evento                     as vl_base_calculo_evento,
    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_base_calculo_evento,
                      

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto,
    fi.dt_afastamento,    
    ta.nm_tipo_afastamento

  into
    #AM_Calculo_Folha

  from
    Funcionario f                               with (nolock) 
    left outer join Situacao_Funcionario   sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario

    left outer join Funcionario_Evento     fe   with (nolock) on fe.cd_funcionario          = f.cd_funcionario and
                                                               isnull(fe.ic_ativo_calculo,'S') = 'S'

    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fe.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    left outer join Tipo_Afastamento       ta   with (nolock) on ta.cd_tipo_afastamento     = fi.cd_tipo_afastamento    
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and
    isnull(fe.vl_funcionario_evento,0)>0          and
    isnull(fe.ic_ativo_calculo,'N' )   = 'S'
    and
    fi.dt_demissao is null    --or fi.dt_demissao>@dt_base_calculo_folha

    --and
    --fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha

    and
    fi.cd_tipo_regime = @cd_tipo_regime

---select * from funcionario_afastamento   

--   select * from #AM_Calculo_Folha


--select * from funcionario_evento

  --Montagem da Tabela de Cálculo
  --select * from calculo_folha

  select
    1                                  as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha             as dt_base_calculo_folha,
    cf.cd_evento                       as cd_evento,
    cf.qt_hora_funcionario_evento      as vl_referencia_calculo,

    case when ef.cd_tipo_evento = 1 then
       cf.vl_funcionario_evento
    else
       0.00
    end                                as vl_provento_calculo,

    case when ef.cd_tipo_evento = 2 then
       cf.vl_funcionario_evento
    else
       0.00
    end                                as vl_desconto_calculo,

    @pc_adto_empresa                   as pc_calculo,
    cf.vl_funcionario_evento           as vl_calculo_folha,
    cf.cd_departamento,
    null                               as cd_seccao,
    @cd_usuario                        as cd_usuario,
    getdate()                          as dt_usuario,
    cf.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)      as mm_calculo_folha,
    year(@dt_base_calculo_folha)       as aa_calculo_folha,
    cf.cd_centro_custo,  
    @dt_pagto_calculo_folha            as dt_pagto_calculo_folha,
    'A'                                as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha             as cd_tipo_calculo_folha,
    identity(int,1,1)                  as cd_controle,
    @cd_controle_folha                 as cd_controle_folha,
    null                               as cd_ap,
    cf.vl_base_calculo_evento,
    isnull(cf.cd_evento_desconto,0)    as cd_evento_desconto,

    case when isnull(ef.cd_tipo_evento,0) = 1 then
      cf.qt_hora_funcionario_evento
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      cf.qt_hora_funcionario_evento
    else
      0
   end                                        as vl_ref_desconto_calculo,

   case when isnull(ef.cd_tipo_evento,0) = 1 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_provento,

   case when isnull(ef.cd_tipo_evento,0) = 2 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_desconto
 

  into
    #Mensal_Calculo_Folha

  from
    #AM_Calculo_Folha cf            with (nolock)
    left outer join Evento_Folha ef on ef.cd_evento = cf.cd_evento
  where
    cf.dt_afastamento is null       


  --select * from #Mensal_Calculo_Folha

  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Mensal_Calculo_Folha
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Mensal_Calculo_Folha

  --select * from #Mensal_Calculo_Folha


  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
	
  while exists(Select top 1 'x' from calculo_folha where cd_calculo_folha = @cd_calculo_folha)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'

  --select * from roteiro_calculo_folha

  select
    distinct
    rcf.cd_roteiro_calculo,
    rcf.nm_roteiro_calculo,
    isnull(ei.ic_evento_incidencia,'N') as ic_evento_incidencia
  into
    #Roteiro_Calculo

  from
    Roteiro_Calculo_Folha rcf                 with (nolock) 
    left outer join Evento_Folha ef           with (nolock) on ef.cd_roteiro_calculo = rcf.cd_roteiro_calculo
    left outer join Evento_Incidencia ei      with (nolock) on ei.cd_evento          = ef.cd_evento

    
--   order by
--     rcf.qt_ordem_calculo

--  select * from #Roteiro_Calculo
--  select * from evento_incidencia

 
  while exists ( select top 1 cd_roteiro_calculo from #Roteiro_Calculo )
  begin

    select top 1 
      @cd_roteiro_calculo   = cd_roteiro_calculo,
      @ic_evento_incidencia = ic_evento_incidencia
    from 
      #Roteiro_Calculo

    select
      cd_funcionario,
      vl_base_calculo_evento
    into
      #Funcionario_Roteiro
    from    
      #AM_Calculo_Folha 
    where
      dt_afastamento is null       

   --select * from #AM_Calculo_Folha 

   --select * from #Funcionario_Roteiro


    while exists( select top 1 cd_funcionario from #Funcionario_Roteiro )
    begin

      select top 1 
         @cd_funcionario_roteiro = cd_funcionario,
         @vl_base_calculo        = isnull(vl_base_calculo_evento,0)
      from
         #Funcionario_Roteiro
   

      --select * from #Funcionario_Roteiro

      --Geração do Lançamento Automática para Cálculo

--       select
--            @cd_controle_folha,
--            @cd_roteiro_calculo,
--            @dt_base_calculo_folha,
--            @dt_pagto_calculo_folha,
--            @vl_base_calculo,        
--            @cd_funcionario_roteiro,         
--            @cd_usuario


      exec pr_roteiro_calculo_folha 
           @cd_controle_folha,
           @cd_roteiro_calculo,
           @dt_base_calculo_folha,
           @dt_pagto_calculo_folha,
           @vl_base_calculo,        
           @cd_funcionario_roteiro,         
           @cd_usuario,
           'N',
           @ic_evento_incidencia

           --@vl_retorno = @cd_faixa_irrf output
             

      delete from #Funcionario_Roteiro where cd_funcionario = @cd_funcionario_roteiro
      
    end
 
    drop table #Funcionario_Roteiro

    delete from #Roteiro_Calculo where cd_roteiro_calculo = @cd_roteiro_calculo

  end

  --select * from #Mensal_Calculo_Folha

-------------------------------------------------------------------------------
  --Atualiza no Cálculo os Lançamentos do Movimento da Folha dos Funcionários
-------------------------------------------------------------------------------
  --select * from movimento_folha
 
  select
    1                                  as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha             as dt_base_calculo_folha,
    cf.cd_evento                       as cd_evento,
    cf.vl_hora_folha                   as vl_referencia_calculo,

    case when ef.cd_tipo_evento = 1 then
      cf.vl_lancamento_folha
    else
      0.00
    end                                as vl_provento_calculo,

    case when ef.cd_tipo_evento = 2 then
      cf.vl_lancamento_folha
    else
      0.00
    end                                as vl_desconto_calculo,

    null                               as pc_calculo,
    cf.vl_lancamento_folha             as vl_calculo_folha,
    f.cd_departamento,
    null                               as cd_seccao,
    @cd_usuario                        as cd_usuario,
    getdate()                          as dt_usuario,
    f.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)      as mm_calculo_folha,
    year(@dt_base_calculo_folha)       as aa_calculo_folha,
    f.cd_centro_custo,  
    @dt_pagto_calculo_folha            as dt_pagto_calculo_folha,
    'A'                                as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha             as cd_tipo_calculo_folha,
    identity(int,1,1)                  as cd_controle,
    @cd_controle_folha                 as cd_controle_folha,
    null                               as cd_ap,
    cf.vl_lancamento_folha,
    0                                  as cd_evento_desconto,
    case when isnull(ef.cd_tipo_evento,0) = 1 then
      cf.vl_hora_folha
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      cf.vl_hora_folha
    else
      0
   end                                        as vl_ref_desconto_calculo,

   case when isnull(ef.cd_tipo_evento,0) = 1 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_provento,

   case when isnull(ef.cd_tipo_evento,0) = 2 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_desconto
 

  into
    #Movimento_Calculo_Folha

  from
    Movimento_Folha cf              with (nolock)
    left outer join Funcionario f   with (nolock) on f.cd_funcionario = cf.cd_funcionario
    left outer join Evento_Folha ef with (nolock) on ef.cd_evento     = cf.cd_evento

  where
    cf.cd_tipo_calculo_folha = @cd_tipo_calculo_folha and
    cf.dt_base_calculo_folha = @dt_base_calculo_folha 

    --select * from movimento_folha

    --and cf.cd_controle_folha = @cd_controle_folha 

  --select *  from #Movimento_Calculo_Folha


  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Movimento_Calculo_Folha
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Movimento_Calculo_Folha


-------------------------------------------------------------------------------
    --Atualiza a Tabela de Cálculo do Funcionário
-------------------------------------------------------------------------------
-- 
    select
      cf.cd_controle_folha,
      cf.cd_funcionario,
      sum( isnull(cf.vl_provento_calculo,0))   as vl_total_provento,
      sum( isnull(cf.vl_desconto_calculo,0))   as vl_total_desconto,
      sum( isnull(cf.vl_provento_calculo,0))
      - 
      sum( isnull(cf.vl_desconto_calculo,0))    as vl_total_liquido,
      sum( isnull(cf.vl_base_calculo_evento,0)) as vl_salario_base,
      sum( isnull(cf.vl_calculo_folha,0))       as vl_adiantamento
      
    into
      #Funcionario_Calculo_Mes

    from
      Calculo_Folha cf           with (nolock) 
      inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
    where
      cf.cd_controle_folha     = @cd_controle_folha and
      cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

    group by
      cf.cd_funcionario,
      cf.cd_controle_folha

    --Atualiza o Código da Tabela de Cálculo do funcionário

    update
      Funcionario_Calculo
    set
       vl_total_provento = x.vl_total_provento,
       vl_total_desconto = x.vl_total_desconto,
       vl_total_liquido  = x.vl_total_liquido,
       vl_salario_base   = x.vl_salario_base

       from 
         funcionario_calculo fc 
         inner join #funcionario_calculo_mes x on
               fc.cd_funcionario    = x.cd_funcionario         and
               fc.dt_base_calculo   = @dt_base_calculo_folha  and
               fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
               fc.cd_controle_folha = x.cd_controle_folha




  --select * from #Movimento_Calculo_Folha


end

-----------------------------------------------------------------------------------
--Férias
-----------------------------------------------------------------------------------


if @cd_forma_calculo = 3
begin
  print 'calculo de folha de férias'

end


-----------------------------------------------------------------------------------
--13o. Salário - 1a. Parcela
-----------------------------------------------------------------------------------


if @cd_forma_calculo = 4
begin

  print 'calculo 13o. Salário - 1a. Parcela'

  --Busca Todos os Funcionários-------------------------------------------------------------------

  select

    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_departamento,
    f.cd_centro_custo,
    f.cd_vinculo_empregaticio,
    ef.cd_evento,
    ef.nm_evento,
                      
   case when isnull(ic_hora_natureza_evento,'N')='S' 
   then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_funcionario_evento,


    --Horas
    isnull(fe.qt_hora_funcionario_evento,@qt_hora_mes_folha) as qt_hora_funcionario_evento,

    --Cálculo do Adiantamento------------------------------------------------------------------------
    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
      (@pc_13salario_parcela/100) * fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
    (@pc_13salario_parcela/100) * fe.vl_funcionario_evento
    end                                          as vl_adiantamento,

    --Cálculo do Evento-----------------------------------------------------------------------

    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                            as vl_base_calculo_evento,

--    fe.vl_funcionario_evento                     as vl_base_calculo_evento,

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto    

  into
    #Auxiliar_Calculo_13S1P

  from
    Funcionario f                               with (nolock) 
    left outer join Situacao_Funcionario   sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario

    left outer join Funcionario_Evento     fe   with (nolock) on fe.cd_funcionario          = f.cd_funcionario and
                                                               isnull(fe.ic_ativo_calculo,'S') = 'S'

    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fe.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and  --Executa o Cálculo
    isnull(fe.vl_funcionario_evento,0) > 0        and  --Valor do Evento
    isnull(fe.ic_ativo_calculo,'N' )   = 'S'           --Verifica se o Evento está Ativo para o Funcionário
    and
    fi.dt_demissao    is null    --or fi.dt_demissao>@dt_base_calculo_folha
    and
    fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha
    
    --verificar se o Funcionário pegou na Férias--------------------------------------------
    and
    f.cd_funcionario not in ( select top 1 fr.cd_funcionario
                              from
                                Ferias fr
                              where 
                                fr.cd_funcionario = f.cd_funcionario                   and
                                year(@dt_base_calculo_folha) = year(fr.dt_fim_a_ferias) and
                                isnull(fr.ic_parcela_13_ferias,'N')='S' 
                              order by
                                fr.dt_fim_a_ferias )


    and
    fi.cd_tipo_regime = @cd_tipo_regime

  --select * from funcionario_informacao

  --Montagem da Tabela de Cálculo
  --select * from calculo_folha

  select
    1                                         as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha                    as dt_base_calculo_folha,
    @cd_evento_calculo                        as cd_evento,
    cf.qt_hora_funcionario_evento             as vl_referencia_calculo,
   
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_provento_calculo,

    0.00                                      as vl_desconto_calculo,

    @pc_adto_empresa                          as pc_calculo,

--     dbo.fn_arredondamento(cf.vl_adiantamento,
--                           @vl_arredondamento) as vl_calculo_folha,
-- 
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_calculo_folha,

    cf.cd_departamento,
    null                                      as cd_seccao,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    cf.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)             as mm_calculo_folha,
    year(@dt_base_calculo_folha)              as aa_calculo_folha,
    cf.cd_centro_custo,
    @dt_pagto_calculo_folha                   as dt_pagto_calculo_folha,
    'A'                                       as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha                    as cd_tipo_calculo_folha,
    identity(int,1,1)                         as cd_controle,
    @cd_controle_folha                        as cd_controle_folha,
    null                                      as cd_ap,
    cf.vl_base_calculo_evento,
    isnull(ef.cd_evento_desconto,0)           as cd_evento_desconto 

  into
    #Calculo_Folha_13S1P    

  from
    #Auxiliar_Calculo_13S1P cf         with (nolock)
    left outer join Evento_Folha ef    with (nolock) on ef.cd_evento               = @cd_evento_calculo	 
    left outer join movimento_folha mf with (nolock) on mf.dt_lancamento_folha     = @dt_base_calculo_folha and                        
                                                        mf.cd_evento               = @cd_evento_calculo	    and
                                                        mf.cd_funcionario          = cf.cd_funcionario      and
                                                        mf.ic_tipo_lancamento      = 'M'         


  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Calculo_Folha_13S1P
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Calculo_Folha_13S1P

--  select * from #Calculo_Folha

--  print '1'
    
  --Gera o Movimento da Folha de Pagamento-----------------------------------------------------------------

  if @ic_gera_movimento = 'S'
  begin

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
      1                                      as cd_lancamento_folha,
      @dt_base_calculo_folha                 as dt_lancamento_folha,
      1                                      as cd_tipo_lancamento_folha,
      c.cd_funcionario,
      c.vl_calculo_folha                     as vl_lancamento_folha,
      c.vl_referencia_calculo                as vl_hora_folha,
      'Cálculo do 13o. Salário - 1a.Parcela' as nm_obs_lancamento_folha,
      c.cd_evento,
      1                                      as cd_historico_folha,
      getdate()                              as dt_usuario,
      @cd_usuario                            as cd_usuario,
      'A'                                    as ic_tipo_lancamento,
      identity(int,1,1)                      as cd_controle,
      isnull(e.cd_tipo_calculo_folha,
             c.cd_tipo_calculo_folha)        as cd_tipo_calculo_folha,
      @dt_base_calculo_folha                 as dt_base_calculo_folha,
      @dt_pagto_calculo_folha                as dt_pagto_calculo_folha,
      @cd_controle_folha                     as cd_controle_folha,
      null                                   as cd_movimento_evento 

    into
      #movimento_folha_13S1P

    from
      #Calculo_Folha_13S1P c    
      left outer join evento_folha e on e.cd_evento = c.cd_evento

    --Atualiza o Número do Lançamento do Movimento------------------------------------------------------

    update
      #movimento_folha_13S1P
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle


    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_13S1P

    --select * from #movimento_folha
    --select * from movimento_folha
-------------------------------------------------------------------------------
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
      'Cálculo do 13o. Salário - 1a.Parcela' as nm_obs_lancamento_folha,
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
      #movimento_folha_desconto_13S1P

    from
      #Calculo_Folha_13S1P c
      left outer join evento_folha e on e.cd_evento = c.cd_evento_desconto
    where
      isnull(c.cd_evento_desconto,0)<>0

    --Atualiza o Número do Lançamento do Movimento

    update
      #movimento_folha_desconto_13S1P
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle

    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_desconto_13S1P

-------------------------------------------------------------------------------
    --Atualiza a Tabela de Cálculo do Funcionário
-------------------------------------------------------------------------------

        --Geração do Lançamento Automática para Cálculo
        exec pr_roteiro_calculo_folha 
             @cd_controle_folha,
             0,
             @dt_base_calculo_folha,
             @dt_pagto_calculo_folha,
             0,        
             999,         
             @cd_usuario,
             'N',
             @ic_evento_incidencia
 
    select
      cf.cd_controle_folha,
      cf.cd_funcionario,
      sum( isnull(cf.vl_provento_calculo,0))   as vl_total_provento,
      sum( isnull(cf.vl_desconto_calculo,0))   as vl_total_desconto,
      sum( isnull(cf.vl_provento_calculo,0))
      - 
      sum( isnull(cf.vl_desconto_calculo,0))    as vl_total_liquido,
      sum( isnull(cf.vl_base_calculo_evento,0)) as vl_salario_base,
      sum( isnull(cf.vl_calculo_folha,0))       as vl_adiantamento
      
    into
      #Funcionario_Calculo_13S1P

    from
      Calculo_Folha cf           with (nolock) 
      inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
    where
      cf.cd_controle_folha     = @cd_controle_folha and
      cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

    group by
      cf.cd_funcionario,
      cf.cd_controle_folha

    --Atualiza o Código da Tabela de Cálculo do funcionário

    update
      Funcionario_Calculo
    set
       vl_total_provento = x.vl_total_provento,
       vl_total_desconto = x.vl_total_desconto,
       vl_total_liquido  = x.vl_total_liquido,
       vl_salario_base   = x.vl_salario_base,
       vl_adiantamento   = x.vl_adiantamento

       from 
         funcionario_calculo fc 
         inner join #funcionario_calculo_13S1P x on
               fc.cd_funcionario    = x.cd_funcionario         and
               fc.dt_base_calculo   = @dt_base_calculo_folha  and
               fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
               fc.cd_controle_folha = x.cd_controle_folha

  end

  --Atualiza as Bases-----------------------------------------------

  
  --Deletas as Tabelas Auxiliares

  drop table #funcionario_calculo_13S1P
  drop table #Calculo_Folha_13S1P
  drop table #Auxiliar_Calculo_13S1P
  drop table #movimento_folha_13S1P
  drop table #movimento_folha_desconto_13S1P

end


-----------------------------------------------------------------------------------
--13o. Salário - 2a. Parcela
-----------------------------------------------------------------------------------


if @cd_forma_calculo = 5
begin

  print 'calculo 13o. Salário - 2a. Parcela'

  --Busca Todos os Funcionários-------------------------------------------------------------------

  select
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_departamento,
    f.cd_centro_custo,
    f.cd_vinculo_empregaticio,
    ef.cd_evento,
    ef.nm_evento,

    --fe.vl_funcionario_evento,

--     case when isnull(ic_hora_natureza_evento,'N')='S' 
--     then
--       --Horas
--        fe.vl_funcionario_evento * 
--        case when isnull(fe.qt_hora_funcionario_evento,0)=0 
--        then 
--          @qt_hora_mes_folha
--        else
--          isnull(fe.qt_hora_funcionario_evento,0)
--        end
--     else
--       fe.vl_funcionario_evento
--     end                                                      as vl_funcionario_evento,
                      
   case when isnull(ic_hora_natureza_evento,'N')='S' 
   then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_funcionario_evento,


    --Horas
    isnull(fe.qt_hora_funcionario_evento,@qt_hora_mes_folha) as qt_hora_funcionario_evento,

    --Cálculo do Adiantamento------------------------------------------------------------------------
    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
      (@pc_adto_empresa/100) * fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
    (@pc_adto_empresa/100) * fe.vl_funcionario_evento
    end                                          as vl_adiantamento,

    --Cálculo do Evento-----------------------------------------------------------------------

    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                            as vl_base_calculo_evento,

--    fe.vl_funcionario_evento                     as vl_base_calculo_evento,

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto    

  into
    #Auxiliar_Calculo_13S2P

  from
    Funcionario f                               with (nolock) 
    left outer join Situacao_Funcionario   sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario

    left outer join Funcionario_Evento     fe   with (nolock) on fe.cd_funcionario          = f.cd_funcionario and
                                                               isnull(fe.ic_ativo_calculo,'S') = 'S'

    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fe.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and  --Executa o Cálculo
    isnull(fe.vl_funcionario_evento,0) > 0        and  --Valor do Evento
    isnull(ef.ic_salario_evento,'N')   = 'S'      and
    isnull(fe.ic_ativo_calculo,'N' )   = 'S'           --Verifica se o Evento está Ativo para o Funcionário
    and
    fi.dt_demissao is null    --or fi.dt_demissao>@dt_base_calculo_folha
    and
    fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha

    and
    fi.cd_tipo_regime = @cd_tipo_regime

  --select * from funcionario_informacao

  --Montagem da Tabela de Cálculo
  --select * from calculo_folha

  select
    1                                         as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha                    as dt_base_calculo_folha,
    @cd_evento_calculo                        as cd_evento,
    cf.qt_hora_funcionario_evento             as vl_referencia_calculo,
   
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_provento_calculo,

    0.00                                      as vl_desconto_calculo,

    @pc_adto_empresa                          as pc_calculo,

--     dbo.fn_arredondamento(cf.vl_adiantamento,
--                           @vl_arredondamento) as vl_calculo_folha,
-- 
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_calculo_folha,

    cf.cd_departamento,
    null                                      as cd_seccao,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    cf.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)             as mm_calculo_folha,
    year(@dt_base_calculo_folha)              as aa_calculo_folha,
    cf.cd_centro_custo,
    @dt_pagto_calculo_folha                   as dt_pagto_calculo_folha,
    'A'                                       as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha                    as cd_tipo_calculo_folha,
    identity(int,1,1)                         as cd_controle,
    @cd_controle_folha                        as cd_controle_folha,
    null                                      as cd_ap,
    cf.vl_base_calculo_evento,
    isnull(ef.cd_evento_desconto,0)           as cd_evento_desconto 

  into
    #Calculo_Folha_13S2P

  from
    #Auxiliar_Calculo_13S2P cf         with (nolock)
    left outer join Evento_Folha ef    with (nolock) on ef.cd_evento               = @cd_evento_calculo	 
    left outer join movimento_folha mf with (nolock) on mf.dt_lancamento_folha     = @dt_base_calculo_folha and                        
                                                        mf.cd_evento               = @cd_evento_calculo	    and
                                                        mf.cd_funcionario          = cf.cd_funcionario      and
                                                        mf.ic_tipo_lancamento      = 'M'         





  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Calculo_Folha_13S2P
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Calculo_Folha_13S2P

--  select * from #Calculo_Folha

--  print '1'
    
  --Gera o Movimento da Folha de Pagamento-----------------------------------------------------------------

  if @ic_gera_movimento = 'S'
  begin

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
      'Cálculo do 13o. Salário - 2a. Parcela' as nm_obs_lancamento_folha,
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
      #movimento_folha_13S2P

    from
      #Calculo_Folha_13S2P c    
      left outer join evento_folha e on e.cd_evento = c.cd_evento

    --Atualiza o Número do Lançamento do Movimento------------------------------------------------------

    update
      #movimento_folha_13S2P
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle


    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_13S2P

    --select * from #movimento_folha
    --select * from movimento_folha
-------------------------------------------------------------------------------
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
      1                                       as cd_lancamento_folha,
      @dt_base_calculo_folha                  as dt_lancamento_folha,
      1                                       as cd_tipo_lancamento_folha,
      c.cd_funcionario,
      c.vl_calculo_folha                      as vl_lancamento_folha,
      c.vl_referencia_calculo                 as vl_hora_folha,
      'Cálculo do 13o. Salário - 2a. Parcela' as nm_obs_lancamento_folha,
      c.cd_evento_desconto                    as cd_evento,
      1                                       as cd_historico_folha,
      getdate()                               as dt_usuario,
      @cd_usuario                             as cd_usuario,
      'A'                                     as ic_tipo_lancamento,
      identity(int,1,1)                       as cd_controle,
      isnull(e.cd_tipo_calculo_folha,
             c.cd_tipo_calculo_folha)         as cd_tipo_calculo_folha,
      @dt_base_calculo_folha                  as dt_base_calculo_folha,
      @dt_pagto_calculo_folha                 as dt_pagto_calculo_folha,
      @cd_controle_folha                      as cd_controle_folha,
      null                                    as cd_movimento_evento 

    into
      #movimento_folha_desconto_13S2P

    from
      #Calculo_Folha c
      left outer join evento_folha e on e.cd_evento = c.cd_evento_desconto
    where
      isnull(c.cd_evento_desconto,0)<>0

    --Atualiza o Número do Lançamento do Movimento

    update
      #movimento_folha_desconto_13S2P
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle

    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_desconto_13S2P


-------------------------------------------------------------------------------
    --Imposto de Renda
-------------------------------------------------------------------------------
    --select * from Roteiro_Calculo_Folha

    select
--      top 1
      rcf.cd_roteiro_calculo,
      ef.cd_evento
    into
      #Roteiro_Calculo_Adiantamento_13S2P

    from
      Roteiro_Calculo_Folha rcf       with (nolock) 
      inner join Evento_Folha ef      with (nolock) on ef.cd_roteiro_calculo = rcf.cd_roteiro_calculo
      inner join Evento_Incidencia ei with (nolock) on ei.cd_evento          = ef.cd_evento

    where
      ef.cd_tipo_calculo_folha = @cd_tipo_calculo_Folha and
      ef.cd_tipo_evento        = 1                      and 
      isnull(ei.ic_evento_incidencia,'N')='S' 

    --select @cd_tipo_calculo_folha
    --select * from   #Roteiro_Calculo_Adiantamento

    --select * from evento_incidencia
    --select * from tipo_evento
    --select * from evento_folha 

    --print 'roteiro'
    --select * from  #Roteiro_Calculo_Adiantamento

    --select * from #Auxiliar_Calculo_Folha

    while exists ( select top 1 cd_roteiro_calculo from #Roteiro_Calculo_Adiantamento_13S2P )
    begin

      select top 1 
        @cd_roteiro_calculo = cd_roteiro_calculo
      from 
        #Roteiro_Calculo_Adiantamento_13S2P

      select
        a.cd_funcionario,
        case when a.vl_base_calculo_evento <> cf.vl_calculo_folha then
          cf.vl_calculo_folha
        else
          a.vl_base_calculo_evento
        end                                  as vl_base_calculo_evento
      into
        #Funcionario_Roteiro_13S2P
        
      from    
        #Auxiliar_Calculo_13S2P a
        left outer join #Calculo_13S2P cf on cf.cd_funcionario = a.cd_funcionario
 
      --select * from #Funcionario_Roteiro_Adiantamento


      while exists( select top 1 cd_funcionario from #Funcionario_Roteiro_13S2P )
      begin

        select top 1 
           @cd_funcionario_roteiro = cd_funcionario,
           @vl_base_calculo        = vl_base_calculo_evento
        from
           #Funcionario_Roteiro_13S2P
   
        --select @cd_controle_folha,@cd_roteiro_calculo,@dt_base_calculo_folha,@vl_base_calculo,@cd_funcionario_roteiro

        --Geração do Lançamento Automática para Cálculo
        exec pr_roteiro_calculo_folha 
             @cd_controle_folha,
             @cd_roteiro_calculo,
             @dt_base_calculo_folha,
             @dt_pagto_calculo_folha,
             @vl_base_calculo,        
             @cd_funcionario_roteiro,         
             @cd_usuario,
             'S',
             @ic_evento_incidencia

             --@vl_retorno = @cd_faixa_irrf output

        delete from #Funcionario_Roteiro_13S2P where cd_funcionario = @cd_funcionario_roteiro
      
      end

      drop table #Funcionario_Roteiro_13S2P

      delete from #Roteiro_Calculo_13S2P where cd_roteiro_calculo = @cd_roteiro_calculo

    end

-------------------------------------------------------------------------------
    --Atualiza a Tabela de Cálculo do Funcionário
-------------------------------------------------------------------------------
-- 
    select
      cf.cd_controle_folha,
      cf.cd_funcionario,
      sum( isnull(cf.vl_provento_calculo,0))   as vl_total_provento,
      sum( isnull(cf.vl_desconto_calculo,0))   as vl_total_desconto,
      sum( isnull(cf.vl_provento_calculo,0))
      - 
      sum( isnull(cf.vl_desconto_calculo,0))    as vl_total_liquido,
      sum( isnull(cf.vl_base_calculo_evento,0)) as vl_salario_base,
      sum( isnull(cf.vl_calculo_folha,0))       as vl_adiantamento
      
    into
      #Funcionario_Calculo_13S2P

    from
      Calculo_Folha cf           with (nolock) 
      inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
    where
      cf.cd_controle_folha     = @cd_controle_folha and
      cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

    group by
      cf.cd_funcionario,
      cf.cd_controle_folha

    --Atualiza o Código da Tabela de Cálculo do funcionário

    update
      Funcionario_Calculo
    set
       vl_total_provento = x.vl_total_provento,
       vl_total_desconto = x.vl_total_desconto,
       vl_total_liquido  = x.vl_total_liquido,
       vl_salario_base   = x.vl_salario_base,
       vl_adiantamento   = x.vl_adiantamento

       from 
         funcionario_calculo fc 
         inner join #funcionario_calculo_13S2P x on
               fc.cd_funcionario    = x.cd_funcionario         and
               fc.dt_base_calculo   = @dt_base_calculo_folha  and
               fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
               fc.cd_controle_folha = x.cd_controle_folha



  end

  --Atualiza as Bases-----------------------------------------------

  
  --Deletas as Tabelas Auxiliares

  drop table #funcionario_calculo_13S2P
  drop table #Calculo_Folha_13S2P
  drop table #Auxiliar_Calculo_13S2P
  drop table #movimento_folha_13S2P
  drop table #movimento_folha_desconto_13S2P


end


if @cd_forma_calculo = 6
begin
  print 'Rescição'

end


-------------------------------------------------------------------------------
--Cálculo de Adiantamento sem Vínculo Empregatício
-------------------------------------------------------------------------------

--select @cd_forma_calculo

if @cd_forma_calculo = 10 
begin

  --Busca Todos os Funcionários-------------------------------------------------------------------

  select
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_departamento,
    f.cd_centro_custo,
    f.cd_vinculo_empregaticio,
    ef.cd_evento,
    ef.nm_evento,

    --fe.vl_funcionario_evento,

--     case when isnull(ic_hora_natureza_evento,'N')='S' 
--     then
--       --Horas
--        fe.vl_funcionario_evento * 
--        case when isnull(fe.qt_hora_funcionario_evento,0)=0 
--        then 
--          @qt_hora_mes_folha
--        else
--          isnull(fe.qt_hora_funcionario_evento,0)
--        end
--     else
--       fe.vl_funcionario_evento
--     end                                                      as vl_funcionario_evento,
                      
   case when isnull(ic_hora_natureza_evento,'N')='S' 
   then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_funcionario_evento,


    --Horas
    isnull(fe.qt_hora_funcionario_evento,@qt_hora_mes_folha) as qt_hora_funcionario_evento,

    --Cálculo do Adiantamento------------------------------------------------------------------------
    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
      (@pc_adto_empresa/100) * fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
    (@pc_adto_empresa/100) * fe.vl_funcionario_evento
    end                                          as vl_adiantamento,

    --Cálculo do Evento-----------------------------------------------------------------------

    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                            as vl_base_calculo_evento,

--    fe.vl_funcionario_evento                     as vl_base_calculo_evento,

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto    

  into
    #Auxiliar_Calculo_Folha_SR

  from
    Funcionario f                               with (nolock) 
   
    left outer join Situacao_Funcionario   sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario

    left outer join Funcionario_Evento     fe   with (nolock) on fe.cd_funcionario          = f.cd_funcionario and
                                                               isnull(fe.ic_ativo_calculo,'S') = 'S'

    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fe.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and  --Executa o Cálculo
    isnull(fe.vl_funcionario_evento,0) > 0        and  --Valor do Evento
    isnull(ef.ic_salario_evento,'N')   = 'S'      and
    isnull(fi.ic_adiantamento,'S')     = 'S'      and  --Verifica se Calculo o Adiantamento para o Funcionário
    isnull(fe.ic_ativo_calculo,'N' )   = 'S'           --Verifica se o Evento está Ativo para o Funcionário
    and
    fi.dt_demissao is null    --or fi.dt_demissao>@dt_base_calculo_folha
    and
    fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha
    and
    fi.cd_tipo_regime = @cd_tipo_regime


  --select * from   #Auxiliar_Calculo_Folha_SR

  --select * from funcionario_informacao

  --Montagem da Tabela de Cálculo
  --select * from calculo_folha

  select
    1                                         as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha                    as dt_base_calculo_folha,
    @cd_evento_calculo                        as cd_evento,
    cf.qt_hora_funcionario_evento             as vl_referencia_calculo,
   
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_provento_calculo,

    0.00                                      as vl_desconto_calculo,

    @pc_adto_empresa                          as pc_calculo,

--     dbo.fn_arredondamento(cf.vl_adiantamento,
--                           @vl_arredondamento) as vl_calculo_folha,
-- 
    case when isnull(mf.vl_lancamento_folha,0)<>0 then
      dbo.fn_arredondamento(mf.vl_lancamento_folha,
                            @vl_arredondamento) 
    else
      dbo.fn_arredondamento(cf.vl_adiantamento,
                            @vl_arredondamento)
    end                                       as vl_calculo_folha,

    cf.cd_departamento,
    null                                      as cd_seccao,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    cf.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)             as mm_calculo_folha,
    year(@dt_base_calculo_folha)              as aa_calculo_folha,
    cf.cd_centro_custo,
    @dt_pagto_calculo_folha                   as dt_pagto_calculo_folha,
    'A'                                       as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha                    as cd_tipo_calculo_folha,
    identity(int,1,1)                         as cd_controle,
    @cd_controle_folha                        as cd_controle_folha,
    null                                      as cd_ap,
    cf.vl_base_calculo_evento,
    isnull(ef.cd_evento_desconto,0)           as cd_evento_desconto,

    case when isnull(ef.cd_tipo_evento,0) = 1 then
      cf.qt_hora_funcionario_evento
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      cf.qt_hora_funcionario_evento
    else
      0
   end                                        as vl_ref_desconto_calculo,

   case when isnull(ef.cd_tipo_evento,0) = 1 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_provento,

   case when isnull(ef.cd_tipo_evento,0) = 2 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_desconto
 
--select * from evento_folha

  into
    #Calculo_Folha_SR    

  from
    #Auxiliar_Calculo_Folha_SR cf         with (nolock)
    left outer join Evento_Folha ef    with (nolock) on ef.cd_evento               = @cd_evento_calculo	 
    left outer join movimento_folha mf with (nolock) on mf.dt_lancamento_folha     = @dt_base_calculo_folha and                        
                                                        mf.cd_evento               = @cd_evento_calculo	    and
                                                        mf.cd_funcionario          = cf.cd_funcionario      and
                                                        mf.ic_tipo_lancamento      = 'M'         





--  select * from  #Calculo_Folha_SR    

  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Calculo_Folha_SR
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Calculo_Folha_SR

--  select * from #Calculo_Folha

--  print '1'
    
  --Gera o Movimento da Folha de Pagamento-----------------------------------------------------------------

  if @ic_gera_movimento = 'S'
  begin

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
      'Cálculo do Adiantamento'             as nm_obs_lancamento_folha,
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
      #movimento_folha_SR

    from
      #Calculo_Folha_SR c    
      left outer join evento_folha e on e.cd_evento = c.cd_evento


    --select * from  #movimento_folha_SR

    --Atualiza o Número do Lançamento do Movimento------------------------------------------------------

    update
      #movimento_folha_SR
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle


    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_SR

    --select * from #movimento_folha
    --select * from movimento_folha

-------------------------------------------------------------------------------
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
      'Cálculo do Adiantamento'             as nm_obs_lancamento_folha,
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
      #movimento_folha_desconto_SR

    from
      #Calculo_Folha_SR c
      left outer join evento_folha e on e.cd_evento = c.cd_evento_desconto
    where
      isnull(c.cd_evento_desconto,0)<>0


    --select * from  #movimento_folha_desconto_SR

    --Atualiza o Número do Lançamento do Movimento

    update
      #movimento_folha_desconto_SR
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle

    insert into
      movimento_folha
    select
      *
    from
      #movimento_folha_desconto_SR


-------------------------------------------------------------------------------
    --Atualiza a Tabela de Cálculo do Funcionário
-------------------------------------------------------------------------------
--

    while exists( select top 1 cd_funcionario from #Auxiliar_Calculo_Folha_SR )
    begin

      select top 1
        @cd_funcionario_roteiro = cd_funcionario
      from
        #Auxiliar_Calculo_Folha_SR
   
      exec pr_roteiro_calculo_folha 
             @cd_controle_folha,
             9999,
             @dt_base_calculo_folha,
             @dt_pagto_calculo_folha,
             @vl_base_calculo,        
             @cd_funcionario_roteiro,         
             @cd_usuario,
             'S',
             @ic_evento_incidencia
 
       delete from     #Auxiliar_Calculo_Folha_SR
       where
         cd_funcionario = @cd_funcionario_roteiro

    end

    select
      cf.cd_controle_folha,
      cf.cd_funcionario,
      sum( isnull(cf.vl_provento_calculo,0))   as vl_total_provento,
      sum( isnull(cf.vl_desconto_calculo,0))   as vl_total_desconto,
      sum( isnull(cf.vl_provento_calculo,0))
      - 
      sum( isnull(cf.vl_desconto_calculo,0))    as vl_total_liquido,
      sum( isnull(cf.vl_base_calculo_evento,0)) as vl_salario_base,
      sum( isnull(cf.vl_calculo_folha,0))       as vl_adiantamento
      
    into
      #Funcionario_Calculo_SR

    from
      Calculo_Folha cf           with (nolock) 
      inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
    where
      cf.cd_controle_folha     = @cd_controle_folha and
      cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

    group by
      cf.cd_funcionario,
      cf.cd_controle_folha


    --select * from  #Funcionario_Calculo_SR

    --Atualiza o Código da Tabela de Cálculo do funcionário

    update
      Funcionario_Calculo
    set
       vl_total_provento = x.vl_total_provento,
       vl_total_desconto = x.vl_total_desconto,
       vl_total_liquido  = x.vl_total_liquido,
       vl_salario_base   = x.vl_salario_base,
       vl_adiantamento   = x.vl_adiantamento

       from 
         funcionario_calculo fc 
         inner join #funcionario_calculo_SR x on
               fc.cd_funcionario    = x.cd_funcionario         and
               fc.dt_base_calculo   = @dt_base_calculo_folha  and
               fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
               fc.cd_controle_folha = x.cd_controle_folha



  end

  --Atualiza as Bases-----------------------------------------------

  
  --Deletas as Tabelas Auxiliares

  drop table #funcionario_calculo_SR
  drop table #Calculo_Folha_SR
  drop table #Auxiliar_Calculo_Folha_SR
  drop table #movimento_folha_SR
  drop table #movimento_folha_desconto_SR


end

-----------------------------------------------------------------------------------
--Cálculo da Folha do Mês sem Registro
-----------------------------------------------------------------------------------

if @cd_forma_calculo = 11
begin

  --Gera Movimento de Funcionários Afastados

  exec pr_geracao_calculo_afastamento 
       @cd_controle_folha,
       @cd_usuario,
       @dt_base_calculo_folha,
       @dt_pagto_calculo_folha,
       @cd_tipo_calculo_folha


  --Busca Todos os Funcionários------------------------------------------------------

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

    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_funcionario_evento,
                      

    isnull(fe.qt_hora_funcionario_evento,@qt_hora_mes_folha) as qt_hora_funcionario_evento,

    --fe.vl_funcionario_evento                     as vl_base_calculo_evento,
    case when isnull(ic_hora_natureza_evento,'N')='S' 
    then
      --Horas
       fe.vl_funcionario_evento * 
       case when isnull(fe.qt_hora_funcionario_evento,0)=0 
       then 
         @qt_hora_mes_folha
       else
         isnull(fe.qt_hora_funcionario_evento,0)
       end
    else
      fe.vl_funcionario_evento
    end                                                      as vl_base_calculo_evento,
                      

    isnull(ef.ic_gera_desconto,'N')              as ic_gera_desconto,
    isnull(ef.cd_evento_desconto,0)              as cd_evento_desconto,
    fi.dt_afastamento,    
    ta.nm_tipo_afastamento

  into
    #AM_Calculo_Folha_SR

  from
    Funcionario f                               with (nolock) 
    left outer join Situacao_Funcionario   sf   with (nolock) on sf.cd_situacao_funcionario = f.cd_situacao_funcionario

    left outer join Funcionario_Evento     fe   with (nolock) on fe.cd_funcionario          = f.cd_funcionario and
                                                               isnull(fe.ic_ativo_calculo,'S') = 'S'

    left outer join Evento_Folha           ef   with (nolock) on ef.cd_evento               = fe.cd_evento 
    left outer join Natureza_Evento        ne   with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
    left outer join Funcionario_Informacao fi   with (nolock) on fi.cd_funcionario          = f.cd_funcionario
    left outer join Tipo_Afastamento       ta   with (nolock) on ta.cd_tipo_afastamento     = fi.cd_tipo_afastamento    
    
  where
    isnull(sf.ic_processo_calculo,'S') = 'S'      and
    isnull(fe.vl_funcionario_evento,0)>0          and
    isnull(fe.ic_ativo_calculo,'N' )   = 'S'
    and
    fi.dt_demissao is null    --or fi.dt_demissao>@dt_base_calculo_folha

    --and
    --fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha

    and
    fi.cd_tipo_regime = @cd_tipo_regime

---select * from funcionario_afastamento   

--   select * from #AM_Calculo_Folha


--select * from funcionario_evento

  --Montagem da Tabela de Cálculo
  --select * from calculo_folha

  select
    1                                  as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha             as dt_base_calculo_folha,
    cf.cd_evento                       as cd_evento,
    cf.qt_hora_funcionario_evento      as vl_referencia_calculo,

    case when ef.cd_tipo_evento = 1 then
       cf.vl_funcionario_evento
    else
       0.00
    end                                as vl_provento_calculo,

    case when ef.cd_tipo_evento = 2 then
       cf.vl_funcionario_evento
    else
       0.00
    end                                as vl_desconto_calculo,

    @pc_adto_empresa                   as pc_calculo,
    cf.vl_funcionario_evento           as vl_calculo_folha,
    cf.cd_departamento,
    null                               as cd_seccao,
    @cd_usuario                        as cd_usuario,
    getdate()                          as dt_usuario,
    cf.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)      as mm_calculo_folha,
    year(@dt_base_calculo_folha)       as aa_calculo_folha,
    cf.cd_centro_custo,  
    @dt_pagto_calculo_folha            as dt_pagto_calculo_folha,
    'A'                                as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha             as cd_tipo_calculo_folha,
    identity(int,1,1)                  as cd_controle,
    @cd_controle_folha                 as cd_controle_folha,
    null                               as cd_ap,
    cf.vl_base_calculo_evento,
    isnull(cf.cd_evento_desconto,0)    as cd_evento_desconto,

    case when isnull(ef.cd_tipo_evento,0) = 1 then
      cf.qt_hora_funcionario_evento
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      cf.qt_hora_funcionario_evento
    else
      0
   end                                        as vl_ref_desconto_calculo,

   case when isnull(ef.cd_tipo_evento,0) = 1 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_provento,

   case when isnull(ef.cd_tipo_evento,0) = 2 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_desconto
 

  into
    #Mensal_Calculo_Folha_SR

  from
    #AM_Calculo_Folha_SR cf            with (nolock)
    left outer join Evento_Folha ef on ef.cd_evento = cf.cd_evento
  where
    cf.dt_afastamento is null       


  --select * from #Mensal_Calculo_Folha

  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Mensal_Calculo_Folha_SR
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Mensal_Calculo_Folha_SR

  --select * from #Mensal_Calculo_Folha


  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
	
  while exists(Select top 1 'x' from calculo_folha where cd_calculo_folha = @cd_calculo_folha)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'
  end

  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'

  --select * from roteiro_calculo_folha

  select
    distinct
    rcf.cd_roteiro_calculo,
    rcf.nm_roteiro_calculo,
    isnull(ei.ic_evento_incidencia,'N') as ic_evento_incidencia
  into
    #Roteiro_Calculo_SR

  from
    Roteiro_Calculo_Folha rcf                 with (nolock) 
    left outer join Evento_Folha ef           with (nolock) on ef.cd_roteiro_calculo = rcf.cd_roteiro_calculo
    left outer join Evento_Incidencia ei      with (nolock) on ei.cd_evento          = ef.cd_evento

    
--   order by
--     rcf.qt_ordem_calculo

--  select * from #Roteiro_Calculo
--  select * from evento_incidencia

 
  while exists ( select top 1 cd_roteiro_calculo from #Roteiro_Calculo_SR )
  begin

    select top 1 
      @cd_roteiro_calculo   = cd_roteiro_calculo,
      @ic_evento_incidencia = ic_evento_incidencia
    from 
      #Roteiro_Calculo_SR

    select
      cd_funcionario,
      vl_base_calculo_evento
    into
      #Funcionario_Roteiro_SR
    from    
      #AM_Calculo_Folha_SR
    where
      dt_afastamento is null       

   --select * from #AM_Calculo_Folha 

   --select * from #Funcionario_Roteiro


    while exists( select top 1 cd_funcionario from #Funcionario_Roteiro_SR )
    begin

      select top 1 
         @cd_funcionario_roteiro = cd_funcionario,
         @vl_base_calculo        = isnull(vl_base_calculo_evento,0)
      from
         #Funcionario_Roteiro_SR
   

      --select * from #Funcionario_Roteiro

      --Geração do Lançamento Automática para Cálculo

--       select
--            @cd_controle_folha,
--            @cd_roteiro_calculo,
--            @dt_base_calculo_folha,
--            @dt_pagto_calculo_folha,
--            @vl_base_calculo,        
--            @cd_funcionario_roteiro,         
--            @cd_usuario


      exec pr_roteiro_calculo_folha 
           @cd_controle_folha,
           @cd_roteiro_calculo,
           @dt_base_calculo_folha,
           @dt_pagto_calculo_folha,
           @vl_base_calculo,        
           @cd_funcionario_roteiro,         
           @cd_usuario,
           'N',
           @ic_evento_incidencia

           --@vl_retorno = @cd_faixa_irrf output
             

      delete from #Funcionario_Roteiro_SR where cd_funcionario = @cd_funcionario_roteiro
      
    end
 
    drop table #Funcionario_Roteiro_SR

    delete from #Roteiro_Calculo_SR where cd_roteiro_calculo = @cd_roteiro_calculo

  end

  --select * from #Mensal_Calculo_Folha

-------------------------------------------------------------------------------
  --Atualiza no Cálculo os Lançamentos do Movimento da Folha dos Funcionários
-------------------------------------------------------------------------------
  --select * from movimento_folha
 
  select
    1                                  as cd_calculo_folha,
    cf.cd_funcionario,
    @dt_base_calculo_folha             as dt_base_calculo_folha,
    cf.cd_evento                       as cd_evento,
    cf.vl_hora_folha                   as vl_referencia_calculo,

    case when ef.cd_tipo_evento = 1 then
      cf.vl_lancamento_folha
    else
      0.00
    end                                as vl_provento_calculo,

    case when ef.cd_tipo_evento = 2 then
      cf.vl_lancamento_folha
    else
      0.00
    end                                as vl_desconto_calculo,

    null                               as pc_calculo,
    cf.vl_lancamento_folha             as vl_calculo_folha,
    f.cd_departamento,
    null                               as cd_seccao,
    @cd_usuario                        as cd_usuario,
    getdate()                          as dt_usuario,
    f.cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)      as mm_calculo_folha,
    year(@dt_base_calculo_folha)       as aa_calculo_folha,
    f.cd_centro_custo,  
    @dt_pagto_calculo_folha            as dt_pagto_calculo_folha,
    'A'                                as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha             as cd_tipo_calculo_folha,
    identity(int,1,1)                  as cd_controle,
    @cd_controle_folha                 as cd_controle_folha,
    null                               as cd_ap,
    cf.vl_lancamento_folha,
    0                                  as cd_evento_desconto,
    case when isnull(ef.cd_tipo_evento,0) = 1 then
      cf.vl_hora_folha
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      cf.vl_hora_folha
    else
      0
   end                                        as vl_ref_desconto_calculo,

   case when isnull(ef.cd_tipo_evento,0) = 1 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_provento,

   case when isnull(ef.cd_tipo_evento,0) = 2 then
      ef.nm_evento
   else
      cast('' as varchar(40)) 
   end                                        as nm_evento_desconto
 

  into
    #Movimento_Calculo_Folha_SR

  from
    Movimento_Folha cf              with (nolock)
    left outer join Funcionario f   with (nolock) on f.cd_funcionario = cf.cd_funcionario
    left outer join Evento_Folha ef with (nolock) on ef.cd_evento     = cf.cd_evento

  where
    cf.cd_tipo_calculo_folha = @cd_tipo_calculo_folha and
    cf.dt_base_calculo_folha = @dt_base_calculo_folha 

    --select * from movimento_folha

    --and cf.cd_controle_folha = @cd_controle_folha 

  --select *  from #Movimento_Calculo_Folha


  --Atualiza o Número do Cálulo da Folha
  --select * from calculo_folha

  update
     #Movimento_Calculo_Folha_SR
  set
     cd_calculo_folha = @cd_calculo_folha + cd_controle

  insert into
    Calculo_Folha
  select 
    *
  from
    #Movimento_Calculo_Folha_SR


-------------------------------------------------------------------------------
    --Atualiza a Tabela de Cálculo do Funcionário
-------------------------------------------------------------------------------
-- 
    select
      cf.cd_controle_folha,
      cf.cd_funcionario,
      sum( isnull(cf.vl_provento_calculo,0))   as vl_total_provento,
      sum( isnull(cf.vl_desconto_calculo,0))   as vl_total_desconto,
      sum( isnull(cf.vl_provento_calculo,0))
      - 
      sum( isnull(cf.vl_desconto_calculo,0))    as vl_total_liquido,
      sum( isnull(cf.vl_base_calculo_evento,0)) as vl_salario_base,
      sum( isnull(cf.vl_calculo_folha,0))       as vl_adiantamento
      
    into
      #Funcionario_Calculo_Mes_SR

    from
      Calculo_Folha cf           with (nolock) 
      inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
    where
      cf.cd_controle_folha     = @cd_controle_folha and
      cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

    group by
      cf.cd_funcionario,
      cf.cd_controle_folha

    --Atualiza o Código da Tabela de Cálculo do funcionário

    update
      Funcionario_Calculo
    set
       vl_total_provento = x.vl_total_provento,
       vl_total_desconto = x.vl_total_desconto,
       vl_total_liquido  = x.vl_total_liquido,
       vl_salario_base   = x.vl_salario_base

       from 
         funcionario_calculo fc 
         inner join #funcionario_calculo_mes_SR x on
               fc.cd_funcionario    = x.cd_funcionario         and
               fc.dt_base_calculo   = @dt_base_calculo_folha  and
               fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
               fc.cd_controle_folha = x.cd_controle_folha




  --select * from #Movimento_Calculo_Folha


end




--select * from controle_folha
--select * from movimento_folha
--select * from tipo_calculo_folha
--select * from calculo_folha
--select * from funcionario_calculo


