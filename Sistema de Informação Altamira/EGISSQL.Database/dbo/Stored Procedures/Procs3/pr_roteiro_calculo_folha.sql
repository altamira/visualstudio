
-------------------------------------------------------------------------------
--sp_helptext pr_roteiro_calculo_folha
-------------------------------------------------------------------------------
--pr_roteiro_calculo_folha
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração dos Cálculos da Folha de Pagamento
--
--Data             : 16.06.2008
--Alteração        : 
--
-- 07.01.2011 - Ajustes Diversos / Complemento - Carlos Fernandes
-- 19.01.2011 - Cálculos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_roteiro_calculo_folha
@cd_controle_folha      int           = 0,
@cd_roteiro_calculo     int           = 0,
@dt_base_calculo_folha  datetime      = '',
@dt_pagto_calculo_folha datetime      = '',
@vl_base_calculo        decimal(25,2) = 0,
@cd_funcionario         int           = 0,
@cd_usuario             int           = 0,
@ic_gera_calculo        char(1)       = 'N',
@ic_evento_incidencia   char(1)       = 'N',
@vl_hora_calculo        decimal(25,4) = 0

--@vl_retorno             float         output


as

declare @Tabela		        varchar(80)
declare @cd_funcionario_calculo int

--select @cd_funcionario, @dt_base_calculo_folha, @dt_pagto_calculo_folha, @cd_controle_folha

------------------------------------------------------------------------------
--Verifica se Existe o Cálculo
------------------------------------------------------------------------------
if not exists ( select fc.cd_funcionario from funcionario_calculo    fc 
                where 
                  fc.cd_funcionario    = @cd_funcionario         and
                  fc.dt_base_calculo   = @dt_base_calculo_folha  and
                  fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
                  fc.cd_controle_folha = @cd_controle_folha
              )
begin       

  set @Tabela = cast(DB_NAME()+'.dbo.Funcionario_Calculo' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_funcionario_calculo', @codigo = @cd_funcionario_calculo output
	
    while exists(Select top 1 'x' from Funcionario_Calculo where cd_funcionario_calculo = @cd_funcionario_calculo)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_funcionario_calculo', @codigo = @cd_funcionario_calculo output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_funcionario_calculo, 'D'
    end

    --select * from funcionario_calculo

    select
      @cd_funcionario_calculo                   as cd_funcionario_calculo,
      @cd_funcionario                           as cd_funcionario,
      @dt_base_calculo_folha                    as dt_base_calculo,
      @dt_pagto_calculo_folha                   as dt_base_pagamento,
      0.00                                      as vl_total_provento,
      0.00                                      as vl_total_desconto,
      0.00                                      as vl_total_liquido,
      0.00                                      as vl_salario_base,
      0.00                                      as vl_adiantamento,
      0.00                                      as vl_salario_inss,
      0.00                                      as vl_base_fgts,
      0.00                                      as vl_fgts,
      0.00                                      as vl_base_irrf,
      0.00                                      as vl_faixa_irrf,
      cast('' as varchar)                       as nm_obs_funcionario_calculo,
      @cd_usuario                               as cd_usuario,
      getdate()                                 as dt_usuario,
      null                                      as cd_ap,
      null                                      as cd_solicitacao,
      null                                      as cd_documento_pagar,
      @cd_controle_folha                        as cd_controle_folha,
      @cd_controle_folha                        as cd_controle,
      'N'                                       as ic_banco_calculo,
      'N'                                       as ic_emitido_demo_calculo,
      0.00                                      as vl_irrf_adiantamento,
      0.00                                      as vl_inss_funcionario
      
    into
      #Funcionario_Calculo
 
    --select * from #Funcionario_Calculo

    insert into
      funcionario_calculo
    select
      *
    from
      #Funcionario_Calculo

    drop table #Funcionario_Calculo


end


if @cd_roteiro_calculo=9999
begin
  print 'Volta sem Calcular'
  return
end

------------------------------------------------------------------------------
--Cálculos
------------------------------------------------------------------------------

declare @cd_lancamento_folha    int
--declare @Tabela		        varchar(80)
declare @cd_evento               int
declare @vl_calculo_evento       decimal(25,2)
declare @vl_referencia           float
declare @qt_hora_evento          float
declare @pc_calculo_evento       float
declare @nm_roteiro_calculo      varchar(60)
declare @cd_tipo_calculo_folha   int
declare @cd_config_mensal_folha  int
declare @vl_ir_dependente        decimal(25,2)
declare @cd_movimento_evento     int
declare @pc_fgts                 decimal(25,2)
declare @pc_noturno              decimal(25,2)
declare @pc_insalubridade        decimal(25,2)
declare @pc_periculosidade       decimal(25,2)
declare @vl_arredondamento       decimal(25,2)
declare @ic_base_calculo         char(1)
declare @cd_calculo_folha        int 
declare @cd_tipo_evento          int 
declare @pc_base_IR              float
declare @vl_base_final_ir        decimal(25,2)
declare @vl_deducao_ir           decimal(25,2)
declare @cd_classe_ir            int
declare @pc_inss_prolabore       float
declare @pc_inss_autonomo        float
declare @pc_vale_transporte      float
declare @pc_convenio_medico      float
declare @vl_refeicao_mensal      float
declare @pc_refeicao_funcionario float

set @Tabela                  = cast(DB_NAME()+'.dbo.Movimento_Folha' as varchar(50))
set @cd_lancamento_folha     = 0
set @cd_evento               = 0
set @vl_calculo_evento       = 0
set @qt_hora_evento          = 0
set @pc_calculo_evento       = 0
set @cd_movimento_evento     = 0
set @ic_base_calculo         = 'N'
set @cd_calculo_folha        = 0
set @pc_vale_transporte      = 0
set @pc_convenio_medico      = 0
set @vl_refeicao_mensal      = 0
set @pc_refeicao_funcionario = 0

--Busca as Tabelas de IR/INSS
--select * from config_mensal_folha

  select
    @cd_config_mensal_folha  = isnull(cd_config_mensal_folha,0),
    @vl_ir_dependente        = isnull(vl_ir_dependente,0),
    @pc_fgts                 = isnull(pc_fgts,0),
    @pc_noturno              = isnull(pc_noturno,0),
    @pc_insalubridade        = isnull(pc_insalubridade,0),
    @pc_periculosidade       = isnull(pc_periculosidade,0),
    @vl_arredondamento       = isnull(vl_arredondamento_base,0),
    @pc_inss_prolabore       = case when isnull(pc_inss_prolabore,0) = 0  and isnull(vl_inss_prolabore,0)>0 then
                                 vl_inss_prolabore
                               else
                                 pc_inss_prolabore
                               end,
    @pc_inss_autonomo        =  case when isnull(pc_inss_autonomo,0) = 0   and isnull(vl_inss_autonomo,0)>0 then
                                 vl_inss_autonomo
                               else
                                 pc_inss_autonomo
                               end,
    @pc_vale_transporte      = isnull(pc_vale_transporte,0),
    @pc_convenio_medico      = isnull(pc_convenio_medico,0),
    @vl_refeicao_mensal      = isnull(vl_refeicao_mensal,0),
    @pc_refeicao_funcionario = isnull(pc_refeicao_funcionario,0)
   


  from

    Config_Mensal_Folha with (nolock) 

  where
    @dt_base_calculo_folha between dt_inicio_vigencia and dt_final_vigencia


select
  @cd_evento             = ef.cd_evento,
  @cd_tipo_calculo_folha = ef.cd_tipo_calculo_folha,
  @nm_roteiro_calculo    = rc.nm_roteiro_calculo,
  @ic_base_calculo       = isnull(ef.cd_tipo_evento,'N'),
  @cd_tipo_evento        = ef.cd_tipo_evento

from
  roteiro_calculo_folha rc   with (nolock) 
  inner join Evento_Folha ef on ef.cd_roteiro_calculo = rc.cd_roteiro_calculo
  inner join Tipo_Evento  te on te.cd_tipo_evento     = ef.cd_tipo_evento
  --Colocar aqui a tabela de Incidencia.....
  --select * from evento_incidencia
  --inner join evento_incidencia ei on evi.cd_evento  = ef.cd_evento
  --
where
  rc.cd_roteiro_calculo = @cd_roteiro_calculo

--select * from tipo_evento

------------------------------------------------------------------------------
--1. Contribuição Sindical
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 1
begin

  --select cd_sindicato from funcionario_documento
  --select * from sindicato

  --Verifica o Sindicato do Funcionario

  select
    @vl_calculo_evento = round((@vl_base_calculo / 30 ),2) 
  from
    Funcionario f                       with (nolock) 
    inner join funcionario_documento fd with (nolock) on fd.cd_funcionario = f.cd_funcionario    
    inner join sindicato             s  with (nolock) on s.cd_sindicato    = fd.cd_sindicato

  where
    f.cd_funcionario                  = @cd_funcionario 
    and isnull(qt_mes_contribuicao,0) = month(@dt_base_calculo_folha)


  --Atualiza o valor da Contribuição Social

  --update

end

------------------------------------------------------------------------------
--2. IMPOSTO DE RENDA SOBRE ADIANTAMENTO
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 2
begin

--   declare @pc_base_IR             float
--   declare @vl_base_final_ir       decimal(25,2)
--   declare @vl_deducao_ir          decimal(25,2)
--   declare @cd_classe_ir           int

--select * from IMPOSTO_RENDA
--select * from config_mensal_folha
--select * from

  --select @cd_config_mensal_folha,@vl_base_calculo

  select
    @cd_classe_ir      = isnull(cd_classe_ir,0),
    @pc_base_IR        = isnull(pc_base_ir,0) / 100,
    @vl_base_final_ir  = isnull(vl_base_final_ir,0),
    @vl_deducao_ir     = isnull(vl_deducao_ir,0)
  from
    IMPOSTO_RENDA with (nolock) 

  where
    cd_config_mensal_folha = @cd_config_mensal_folha and
    ( @vl_base_calculo       between isnull(vl_base_ir,0) and isnull(vl_base_final_ir,0) or 
      @vl_base_calculo > isnull(vl_base_final_ir,0) ) 

  --select @pc_base_IR,@vl_base_final_ir,@vl_deducao_ir

  select
    @vl_referencia     = @pc_base_ir * 100,    
    @vl_calculo_evento = round( (((@vl_base_calculo -
                                 (isnull(fi.qt_ir,0) * isnull(@vl_ir_dependente,0) )
                                 )
                                 * @pc_base_ir ) - @vl_deducao_ir),2) 
                                 
  from
    Funcionario f                             with (nolock) 
    left outer join funcionario_informacao fi on fi.cd_funcionario = f.cd_funcionario
  where
    f.cd_funcionario = @cd_funcionario

  --set @vl_retorno = cast( @cd_classe_ir as float )

--  select @vl_retorno,@cd_classe_ir

--  select @pc_base_ir,@vl_base_final_ir,@vl_deducao_ir,@vl_calculo_evento,(2 * @vl_ir_dependente )

  --select @vl_calculo_evento


  --Atualiza a Tabela do Funcionário 

  update
    funcionario_calculo
  set
    vl_irrf_adiantamento = @vl_calculo_evento,
    vl_base_irrf         = @vl_base_calculo,
    vl_faixa_irrf        = @cd_classe_ir 

  from
    funcionario_calculo fc
  where 
     fc.cd_funcionario    = @cd_funcionario         and
     fc.dt_base_calculo   = @dt_base_calculo_folha  and
     fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
     fc.cd_controle_folha = @cd_controle_folha

end

------------------------------------------------------------------------------
--3. INSS
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 3
begin
  
  declare @pc_base_inss           float
  declare @vl_base_inss_teto      decimal(25,2)

  select
    @pc_base_inss      = isnull(pc_base_inss,0) / 100,
    @vl_base_inss_teto = isnull(vl_base_final_inss,0)
  from
    INSS                 with (nolock) 
  where
    cd_config_mensal_folha = @cd_config_mensal_folha and
    ( @vl_base_calculo       between vl_base_inss and vl_base_final_inss or 
      @vl_base_calculo > vl_base_final_inss) 


--select 3038.99 * .11     
--  select @cd_config_mensal_folha, @pc_base_inss, @vl_base_calculo

  select
    --@vl_calculo_evento = round( ((case when @vl_base_calculo<=@vl_base_inss_teto then @vl_base_calculo else @vl_base_inss_teto end)
    --                            *  @pc_base_inss ),2) 

    @vl_calculo_evento = round(((case when @vl_base_calculo<=@vl_base_inss_teto then @vl_base_calculo else @vl_base_inss_teto end)
                                *  @pc_base_inss ),2,1),
    @vl_referencia     = @pc_base_inss * 100




  --Atualiza a Tabela do Funcionário 

  update
    funcionario_calculo
  set
    vl_salario_inss     = case when @vl_base_calculo<=@vl_base_inss_teto then @vl_base_calculo else @vl_base_inss_teto end,
    vl_inss_funcionario = @vl_calculo_evento

  from
    funcionario_calculo fc
  where 
     fc.cd_funcionario    = @cd_funcionario         and
     fc.dt_base_calculo   = @dt_base_calculo_folha  and
     fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
     fc.cd_controle_folha = @cd_controle_folha

    --trunc  
  --select * from config_mensal_folha
  --select * from inss

end

------------------------------------------------------------------------------
--4. EVENTOS AUTOMÁTICOS
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 4
begin

  set @vl_calculo_evento = 0

  --Lançamentos Automáticos de Eventos
  --select * from movimento_evento_automatico

  select
      1                                     as cd_lancamento_folha,
      @dt_base_calculo_folha                as dt_lancamento_folha,
      1                                     as cd_tipo_lancamento_folha,
      @cd_funcionario                       as cd_funcionario,
      mea.vl_movimento_evento               as vl_lancamento_folha,
      0                                     as vl_hora_folha,
      @nm_roteiro_calculo                   as nm_obs_lancamento_folha,
      mea.cd_evento                         as cd_evento,
      mea.cd_historico_folha                as cd_historico_folha,
      getdate()                             as dt_usuario,
      @cd_usuario                           as cd_usuario,
      'A'                                   as ic_tipo_lancamento,
      identity(int,1,1)                     as cd_controle,
      @cd_tipo_calculo_folha                as cd_tipo_calculo_folha,
      @dt_base_calculo_folha                as dt_base_calculo_folha,
      @dt_pagto_calculo_folha               as dt_pagto_calculo_folha,
      @cd_controle_folha                    as cd_controle_folha,
      mea.cd_movimento_evento               as cd_movimento_evento 

    into
      #movimento_automatico
    
  from
    Movimento_Evento_Automatico mea      with (nolock) 

  where
    mea.cd_funcionario                   = @cd_funcionario and
    isnull(mea.qt_saldo_parcela_evento,0)>0                and
    @dt_base_calculo_folha between dt_inicio_evento and dt_final_evento


  --select * from #movimento_automatico

  if exists ( select top 1 cd_lancamento_folha from #movimento_automatico )
  begin 
    
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
	
    while exists(Select top 1 'x' from movimento_folha where cd_lancamento_folha = @cd_lancamento_folha)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_folha, 'D'
    end

    --Atualiza o Número do Lançamento do Movimento

    update
      #movimento_automatico
    set
      cd_lancamento_folha = @cd_lancamento_folha + cd_controle

    insert into
      movimento_folha
    select
      *
    from
      #movimento_automatico


    drop table #movimento_automatico

  end

end

------------------------------------------------------------------------------
--5. FGTS
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 5 and @pc_fgts>0 and @ic_evento_incidencia = 'S' 
begin

  select
    @vl_calculo_evento = round((@vl_base_calculo * (@pc_fgts/100)),2) ,
    @vl_referencia     = @pc_fgts 

  --select @vl_calculo_evento

end

------------------------------------------------------------------------------
--6. ADICIONAL NOTURNO
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 6 and @pc_noturno>0
begin
  --select * from funcionario_informacao

  select
    @vl_calculo_evento = round((@vl_base_calculo * (@pc_noturno/100)),2) ,
    @vl_referencia     = @pc_noturno
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi on fi.cd_funcionario = f.cd_funcionario
  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.ic_adicional_noturno,'N') = 'S'

end

------------------------------------------------------------------------------
--7. INSALUBRIDADE
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 7 and @pc_insalubridade>0
begin
  --select * from funcionario_informacao

  select
    @vl_calculo_evento = round((@vl_base_calculo * 
                               (case when isnull(pc_insalubridade,0)<>0 
                                     then fi.pc_insalubridade 
                                     else @pc_insalubridade end/100)),2) ,
    @vl_referencia     = @pc_insalubridade
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi with (nolock) on fi.cd_funcionario = f.cd_funcionario
  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.ic_insalubridade,'N') = 'S'

end

------------------------------------------------------------------------------
--8. PERICULOSIDADE
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 8 and @pc_periculosidade>0
begin
  --select * from funcionario_informacao

  select
    @vl_calculo_evento = round((@vl_base_calculo * 
                               (case when isnull(pc_periculosidade,0)<>0 
                                     then fi.pc_periculosidade
                                     else @pc_periculosidade end/100)),2) ,
    @vl_referencia     = @pc_periculosidade
  from
    Funcionario f                        with (nolock)  
    inner join funcionario_informacao fi with (nolock) on fi.cd_funcionario = f.cd_funcionario
  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.ic_periculosidade,'N') = 'S'

end

------------------------------------------------------------------------------
--9. SALARIO-FAMILIA
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 9
begin
  --select * from salario_familia
   
  set @vl_calculo_evento = 0

  declare @vl_salario_familia      decimal(25,2)

  select
    @vl_salario_familia = isnull(vl_salario_familia,0)
  from
    Salario_Familia with (nolock)        
  where
    cd_config_mensal_folha = @cd_config_mensal_folha and
    ( @vl_base_calculo       between vl_base_salario_familia and vl_base_final_salario_familia )


--  select @vl_salario_familia

  --select * from funcionario_informacao

  select
    @vl_calculo_evento = @vl_salario_familia * isnull(fi.qt_salario_familia,0)
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi on fi.cd_funcionario = f.cd_funcionario 
  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.qt_salario_familia,0)>0

  
  --select * from config_mensal_folha
  --select * from inss

end


------------------------------------------------------------------------------
--11. Contribuição Assistencial
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 11
begin

  --select cd_sindicato from funcionario_documento
  --select * from sindicato

  --Verifica o Sindicato do Funcionario

  select
    @vl_calculo_evento = round((@vl_base_calculo * (isnull(s.pc_assistencial_sindicato/100,0))  ),2) ,
    @vl_referencia     = isnull(s.pc_assistencial_sindicato,0)
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi with (nolock) on fi.cd_funcionario = f.cd_funcionario    
    inner join funcionario_documento  fd with (nolock) on fd.cd_funcionario = f.cd_funcionario    
    inner join sindicato              s  with (nolock) on s.cd_sindicato    = fd.cd_sindicato

  where
    f.cd_funcionario                  = @cd_funcionario 
    and isnull(s.pc_assistencial_sindicato,0)>0 and	
    isnull(fi.ic_assistencial,'N')='S'

end

------------------------------------------------------------------------------
--12. Contribuição Confederativa
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 12
begin

  --select cd_sindicato from funcionario_documento
  --select * from sindicato

  --Verifica o Sindicato do Funcionario

  select
    @vl_calculo_evento = round((@vl_base_calculo * (s.pc_confederativa_sindicato/100)  ),2) ,
    @vl_referencia     = s.pc_confederativa_sindicato
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi with (nolock) on fi.cd_funcionario = f.cd_funcionario    
    inner join funcionario_documento  fd with (nolock) on fd.cd_funcionario = f.cd_funcionario    
    inner join sindicato              s  with (nolock) on s.cd_sindicato    = fd.cd_sindicato

  where
    f.cd_funcionario                  = @cd_funcionario 
    and isnull(s.pc_confederativa_sindicato,0)>0 and	
    isnull(fi.ic_confederativa,'N')='S'

end


------------------------------------------------------------------------------
--13. Pensão Alimentícia
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 13
begin

  --select cd_sindicato from funcionario_documento
  --select * from sindicato

  --Verifica o Sindicato do Funcionario

  select
    @vl_calculo_evento = case when isnull(fi.pc_pensao,0)>0 then 
                           round((@vl_base_calculo * (fi.pc_pensao/100)  ),2) 
                         else
                           isnull(fi.vl_pensao,0)
                         end,
    @vl_referencia = isnull(fi.pc_pensao,0)
   
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi with (nolock) on fi.cd_funcionario = f.cd_funcionario    

  where
    f.cd_funcionario                  = @cd_funcionario 
    and ( isnull(fi.pc_pensao,0)>0 or isnull(fi.vl_pensao,0)>0 ) and	
    isnull(fi.ic_pensao,'N')='S'

end

------------------------------------------------------------------------------
--14. IMPOSTO DE RENDA DA FOLHA / SALARIO
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 14
begin

  declare @vl_base_ir_calculo     decimal(25,2)
  declare @vl_inss                decimal(25,2)
  declare @qt_ir                  int           --quantidade de dependentes

  select
    @qt_ir   = isnull(fi.qt_ir,0),                                 
    @vl_inss = isnull(fc.vl_inss_funcionario,0)
  from
    Funcionario f                             with (nolock) 
    left outer join funcionario_informacao fi on fi.cd_funcionario    = f.cd_funcionario
    left outer join funcionario_calculo    fc on fc.cd_funcionario    = f.cd_funcionario       and
                                                 fc.dt_base_calculo   = @dt_base_calculo_folha and
                                                 fc.dt_base_pagamento = @dt_pagto_calculo_folha


  where
    f.cd_funcionario = @cd_funcionario


--select * from IMPOSTO_RENDA
--select * from config_mensal_folha
--select * from

  --select @cd_config_mensal_folha,@vl_base_calculo

  select
    @vl_base_ir_calculo = @vl_base_calculo - @vl_inss

  select
    @cd_classe_ir      = isnull(cd_classe_ir,0),
    @pc_base_IR        = isnull(pc_base_ir,0) / 100,
    @vl_base_final_ir  = isnull(vl_base_final_ir,0),
    @vl_deducao_ir     = isnull(vl_deducao_ir,0)

  from
    IMPOSTO_RENDA with (nolock) 

  where
    cd_config_mensal_folha = @cd_config_mensal_folha and
    ( @vl_base_ir_calculo       between isnull(vl_base_ir,0) and isnull(vl_base_final_ir,0) or 
      @vl_base_ir_calculo > isnull(vl_base_final_ir,0) ) 

  --select @pc_base_IR,@vl_base_final_ir,@vl_deducao_ir


  --set @vl_retorno        = cast( @cd_classe_ir as float )

  set @vl_referencia     = @pc_base_ir * 100
  set @vl_calculo_evento = round( (((@vl_base_ir_calculo -
                                 (isnull(@qt_ir,0) * isnull(@vl_ir_dependente,0) )
                                 )
                                 * @pc_base_ir ) - @vl_deducao_ir),2) 
                                 

end


------------------------------------------------------------------------------
--15. BASE DO IMPOSTO DE RENDA 
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 15
begin
  
  select
     @vl_calculo_evento  = vl_base_irrf

  from
    funcionario_calculo fc with (nolock) 
  where 
     fc.cd_funcionario    = @cd_funcionario         and
     fc.dt_base_calculo   = @dt_base_calculo_folha  and
     fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
     fc.cd_controle_folha = @cd_controle_folha

end


------------------------------------------------------------------------------
--16. INSS PROLABORE / AUTONOMO
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 16
begin

  if @pc_inss_prolabore > 0
  begin
    select
   
      @vl_calculo_evento = round( (@vl_base_calculo * @pc_inss_prolabore/100 ),2,1),

      @vl_referencia     = @pc_inss_prolabore
  
  end

  if @pc_inss_autonomo > 0
  begin
    select
   
      @vl_calculo_evento = round( (@vl_base_calculo * @pc_inss_autonomo/100 ),2,1),

      @vl_referencia     = @pc_inss_autonomo
  
  end

  --Atualiza a Tabela do Funcionário 

  update
    funcionario_calculo
  set
    vl_salario_inss     = @vl_base_calculo,
    vl_inss_funcionario = @vl_calculo_evento

  from
    funcionario_calculo fc
  where 
     fc.cd_funcionario    = @cd_funcionario         and
     fc.dt_base_calculo   = @dt_base_calculo_folha  and
     fc.dt_base_pagamento = @dt_pagto_calculo_folha and 
     fc.cd_controle_folha = @cd_controle_folha

    --trunc  
  --select * from config_mensal_folha
  --select * from inss

end



------------------------------------------------------------------------------
--17. VALE TRANSPORTE
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 17 and @pc_vale_transporte>0
begin

  select
    @vl_calculo_evento = round((@vl_base_calculo * (@pc_vale_transporte/100)),2) ,
    @vl_referencia     = @pc_vale_transporte
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi on fi.cd_funcionario = f.cd_funcionario
  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.ic_vale_transporte,'N') = 'S'

end

--pc_convenio_medico

------------------------------------------------------------------------------
--18. CONVÊNIO MÉDICO
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 18 and @pc_convenio_medico>0
begin

  select
    @vl_calculo_evento = round(( isnull(pm.vl_plano_medico,0) * (@pc_convenio_medico/100)),2) ,
    @vl_referencia     = @pc_convenio_medico
  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi on fi.cd_funcionario  = f.cd_funcionario
    inner join plano_medico           pm on pm.cd_plano_medico = fi.cd_plano_medico
  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.ic_convenio,'N') = 'S'

end

------------------------------------------------------------------------------
--19. REFEIÇÃO
------------------------------------------------------------------------------

if @cd_roteiro_calculo = 19 and ( @pc_refeicao_funcionario > 0 or @vl_refeicao_mensal > 0 )
begin

  
  select
    @vl_calculo_evento = case when @pc_refeicao_funcionario > 0 then
                            round(( isnull(@vl_refeicao_mensal,0) * (@pc_refeicao_funcionario/100)),2) 
                         else
                            @vl_refeicao_mensal
                         end,

    @vl_referencia     = @pc_refeicao_funcionario

  from
    Funcionario f                        with (nolock) 
    inner join funcionario_informacao fi on fi.cd_funcionario  = f.cd_funcionario

  where
    f.cd_funcionario = @cd_funcionario and
    isnull(fi.ic_refeicao_funcionario,'N') = 'S'

end

------------------------------------------------------------------------------
--20. HORA EXTRA
------------------------------------------------------------------------------
if @cd_roteiro_calculo = 20
begin

  print '20'

  --select * from parametro_folha
  --select
  --  @vl_calculo_evento = round( (@vl_base_calculo/220)  ),2) ,
  --  @vl_referencia     = @pc_vale_transporte

    --select * from movimento_folha

    --select * from funcionario_evento

--     select
--       e.vl_fator_evento,
--       e.cd_natureza_evento,
--       m.vl_hora_folha,
--       ( 1200.00/220.00 ),
--       (1200.00/220.00*e.vl_fator_evento/100),
--       ve = ( ( 1200.00/220.00 ) + (1200.00/220.00*e.vl_fator_evento/100)) * m.vl_hora_folha,
--       m.*
--      from movimento_folha m
--      inner join evento_folha e on e.cd_evento = m.cd_evento
--      inner join funcionario_evento fe on fe.cd_funcionario = m.cd_funcionario
--  
--     where
--       m.ic_tipo_lancamento = 'M'
--       and isnull(e.ic_calculo_lancamento_evento,'N')='S'
--       and e.cd_tipo_calculo_folha  = m.cd_tipo_calculo_folha
--       and e.cd_natureza_evento = 2
-- 
    --select * from evento_folha


  


end



------------------------------------------------------------------------------
--Atualização da Tabela de Funcionário / Cálculo
------------------------------------------------------------------------------

  --select * from funcionario_calculo

------------------------------------------------------------------------------
--Geração dos Lançamentos no Movimento da Folha
------------------------------------------------------------------------------
--print 'final'

--select @vl_calculo_evento

if @vl_calculo_evento > 0 --and @ic_gera_calculo = 'N'
begin

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
	
    while exists(Select top 1 'x' from movimento_folha where cd_lancamento_folha = @cd_lancamento_folha)
    begin
      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento_folha', @codigo = @cd_lancamento_folha output
      -- limpeza da tabela de código
      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento_folha, 'D'
    end

    --select * from 
    --select * from movimento_folha

    select
      1                                     as cd_lancamento_folha,
      @dt_base_calculo_folha                as dt_lancamento_folha,
      1                                     as cd_tipo_lancamento_folha,
      @cd_funcionario                       as cd_funcionario,
      @vl_calculo_evento                    as vl_lancamento_folha,
      @vl_referencia                        as vl_hora_folha,
      @nm_roteiro_calculo                   as nm_obs_lancamento_folha,
      @cd_evento                            as cd_evento,
      1                                     as cd_historico_folha,
      getdate()                             as dt_usuario,
      @cd_usuario                           as cd_usuario,
      'A'                                   as ic_tipo_lancamento,
      identity(int,1,1)                     as cd_controle,
      @cd_tipo_calculo_folha                as cd_tipo_calculo_folha,
      @dt_base_calculo_folha                as dt_base_calculo_folha,
      @dt_pagto_calculo_folha               as dt_pagto_calculo_folha,
      @cd_controle_folha                    as cd_controle_folha,
      @cd_movimento_evento                  as cd_movimento_evento 

    into
      #movimento_folha
    
     
--    select * from #movimento_folha

    --Atualiza o Número do Lançamento do Movimento

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


    drop table #movimento_folha


end

---------------------------------------------------------------------------------------------------------
--Geração Direto na tabela de Cálculo da Folha-----------------------------------------------------------
---------------------------------------------------------------------------------------------------------

if @ic_gera_calculo = 'S' and @vl_calculo_evento > 0 
begin

  set @Tabela = cast(DB_NAME()+'.dbo.Calculo_Folha' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
	
  while exists(Select top 1 'x' from calculo_folha where cd_calculo_folha = @cd_calculo_folha)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_calculo_folha', @codigo = @cd_calculo_folha output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_calculo_folha, 'D'
  end

  select
    1                                         as cd_calculo_folha,
    @cd_funcionario                           as cd_funcionario,
    @dt_base_calculo_folha                    as dt_base_calculo_folha,
    @cd_evento                                as cd_evento,
    @qt_hora_evento                           as vl_referencia_calculo,

    case when @cd_tipo_evento = 1 then
      case when @ic_base_calculo='S' 
      then 
        0.00
      else
        @vl_calculo_evento 
      end
    end  
                                             as vl_provento_calculo,

    case when @cd_tipo_evento = 2 then
      case when @ic_base_calculo='S' 
      then 
        0.00
      else
        @vl_calculo_evento 
      end
    end                                       as vl_desconto_calculo,

    @pc_calculo_evento                        as pc_calculo,

    @vl_calculo_evento                        as vl_calculo_folha,

    f.cd_departamento,
    null                                      as cd_seccao,
    @cd_usuario                               as cd_usuario,
    getdate()                                 as dt_usuario,
    f.cd_vinculo_empregaticio                 as cd_vinculo_empregaticio,
    month(@dt_base_calculo_folha)             as mm_calculo_folha,
    year(@dt_base_calculo_folha)              as aa_calculo_folha,
    f.cd_centro_custo,
    @dt_pagto_calculo_folha                   as dt_pagto_calculo_folha,
    'A'                                       as ic_forma_calculo_folha,
    @cd_tipo_calculo_folha                    as cd_tipo_calculo_folha,
    identity(int,1,1)                         as cd_controle,
    @cd_controle_folha                        as cd_controle_folha,
    null                                      as cd_ap,
    @vl_base_calculo                          as vl_base_calculo_evento,
    null                                      as cd_evento_desconto,

    case when isnull(ef.cd_tipo_evento,0) = 1 then
      @qt_hora_evento
    else
      0
    end                                       as vl_ref_provento_calculo,

    case when isnull(ef.cd_tipo_evento,0) = 2 then
      @qt_hora_evento
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
    #Calculo_Folha    

  from
    Funcionario f    with (nolock)         
    left outer join Evento_Folha ef on ef.cd_evento = @cd_evento

  where 
    f.cd_funcionario = @cd_funcionario    

  --select * from #Calculo_Folha
  --select * from Evento_folha ef
   
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


end

