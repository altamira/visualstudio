
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_calculo_folha_pagamento
-------------------------------------------------------------------------------
--pr_consulta_calculo_folha_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Cálculo da Folha de Pagamento
--Data             : 12.06.2008
--Alteração        : 
--
-- 07.01.2011 - Ajustes diversos / complementos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_calculo_folha_pagamento
@cd_controle_folha     int      = 0,
@dt_inicial            datetime = '',
@dt_final              datetime = '',
@cd_tipo_calculo_folha int      = 0,
@ic_parametro          int      = 0
as

print 'Consulta do Cálculo da Folha de Pagamento'

--select * from tipo_calculo_folha
--select * from calculo_folha

if @ic_parametro = 0
begin

  select
    cf.cd_calculo_folha,
    f.cd_chapa_funcionario,
    f.dt_admissao_funcionario,
    cf.cd_funcionario,
    cf.dt_base_calculo_folha,
    cf.cd_evento,
    cf.vl_referencia_calculo,
    cf.vl_provento_calculo,
    cf.vl_desconto_calculo,
    isnull(cf.vl_provento_calculo,0)-isnull(cf.vl_desconto_calculo,0) as vl_tolal_liquido,
    cf.pc_calculo,
    cf.vl_calculo_folha,
    cf.vl_base_calculo_evento,
    cf.cd_departamento,
    cf.cd_seccao,
    cf.cd_usuario,
    cf.dt_usuario,
    cf.cd_vinculo_empregaticio,
    cf.mm_calculo_folha,
    cf.aa_calculo_folha,
    cf.cd_centro_custo,
    cf.dt_pagto_calculo_folha,
    cf.ic_forma_calculo_folha,
    cf.cd_tipo_calculo_folha,
    f.nm_funcionario,
    ef.nm_evento,
    cgo.nm_cargo_funcionario,
    d.nm_departamento,
    fi.dt_demissao,
    fi.dt_afastamento,    
    ta.nm_tipo_afastamento


  from
    Calculo_Folha cf                          with (nolock) 
    left outer join Funcionario f             with (nolock) on f.cd_funcionario         = cf.cd_funcionario 
    left outer join Evento_Folha ef           with (nolock) on ef.cd_evento             = cf.cd_evento
    left outer join Cargo_Funcionario cgo     with (nolock) on cgo.cd_cargo_funcionario = f.cd_cargo_funcionario 
    left outer join Departamento d            with (nolock) on d.cd_departamento        = f.cd_departamento
    left outer join Funcionario_Informacao fi with (nolock) on fi.cd_funcionario        = f.cd_funcionario
    left outer join Tipo_Afastamento       ta with (nolock) on ta.cd_tipo_afastamento   = fi.cd_tipo_afastamento    

--    left outer join Funcionario_Calculo fc with (nolock) on fcf.cd_funcionario = f.cd_funcionario

  --select * from calculo_folha

  where
    --cf.dt_base_calculo_folha between @dt_inicial and @dt_final and
    cf.cd_controle_folha     = @cd_controle_folha and
    cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha=0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end
    and
    fi.dt_demissao is null    
--     and
--     fi.dt_afastamento is null --or fi.dt_afastamento>@dt_base_calculo_folha

  order by
    f.nm_funcionario,
    ef.cd_evento
    
--select * from calculo_folha
--select * from funcionario

end

--Agrupado

if @ic_parametro = 1
begin
  select
    identity(int,1,1)                      as cd_controle,
    max('N')                               as 'Selecionado', 
    cf.cd_tipo_calculo_folha,
    cf.dt_base_calculo_folha,
    cf.dt_pagto_calculo_folha,
    max(f.cd_chapa_funcionario)             as cd_chapa_funcionario,
    cf.cd_funcionario,
    f.nm_funcionario,
    sum(isnull(cf.vl_referencia_calculo,0)) as vl_referencia_calculo,
    sum(isnull(cf.vl_provento_calculo,0))   as vl_provento_calculo,
    sum(isnull(cf.vl_desconto_calculo,0))   as vl_desconto_calculo,
    sum(isnull(cf.vl_calculo_folha,0))      as vl_calculo_folha,
    sum(isnull(cf.vl_provento_calculo,0)-
        isnull(cf.vl_desconto_calculo,0))   as vl_total_liquido,
    max(cgo.nm_cargo_funcionario)           as nm_cargo_funcionario,
    max(f.dt_admissao_funcionario)          as dt_admissao_funcionario,
    max(d.nm_departamento)                  as nm_departamento
  into
    #Consulta_Pagamento
  from
    Calculo_Folha cf                      with (nolock) 
    left outer join Funcionario f         with (nolock) on f.cd_funcionario         = cf.cd_funcionario 
    left outer join Evento_Folha ef       with (nolock) on ef.cd_evento             = cf.cd_evento
    left outer join Cargo_Funcionario cgo with (nolock) on cgo.cd_cargo_funcionario = f.cd_cargo_funcionario
    left outer join Departamento d        with (nolock) on d.cd_departamento        = f.cd_departamento  
  where
    --cf.dt_base_calculo_folha between @dt_inicial and @dt_final and
    cf.cd_controle_folha     = @cd_controle_folha and
    cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha=0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end
  group by
    cf.cd_tipo_calculo_folha,
    cf.dt_base_calculo_folha,
    cf.dt_pagto_calculo_folha,
    cf.cd_funcionario,
    f.nm_funcionario

  select
    *
  from
    #Consulta_Pagamento
  order by 
    nm_funcionario

end


