
-------------------------------------------------------------------------------
--sp_helptext pr_emitir_demonstrativo_pagamento
-------------------------------------------------------------------------------
--pr_emitir_demonstrativo_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Emitir Demonstrativo de Pagamento
--Data             : 12.06.2008
--Alteração        : 
--
-- 07.01.2011 - Ajustes - Carlos / Lázaro 
------------------------------------------------------------------------------
create procedure pr_emitir_demonstrativo_pagamento
@ic_parametro          int      = 0,
@cd_funcionario        int      = 0,
@cd_tipo_calculo_folha int      = 0,
@dt_base_pagamento     datetime = '',
@cd_controle_folha     int      = 0

as

--select * from controle_folha

  declare @cd_empresa      int
  declare @nm_empresa      varchar(60)
  declare @cd_cnpj_empresa varchar(18)

  --select * from egisadmin.dbo.empresa
   
  select
    @cd_empresa      = isnull(e.cd_empresa,0),
    @nm_empresa      = e.nm_empresa,
    @cd_cnpj_empresa = cd_cgc_empresa
  from
    egisadmin.dbo.Empresa e
  where
    e.cd_empresa = dbo.fn_empresa()


if @ic_parametro = 1
begin

  --select * from funcionario
  --select * from cargo_funcionario
   
  select
    '.'                                  as PONTO,
    @dt_base_pagamento                   as DATA_PAGAMENTO,
    @cd_empresa                          as CODIGO_EMPRESA,
    @nm_empresa                          as EMPRESA,
    @cd_cnpj_empresa                     as CNPJ_EMPRESA,
    1                                    as PAGINA,
    f.cd_funcionario                     as CODIGO_FUNCIONARIO,
    f.nm_funcionario                     as FUNCIONARIO,
    f.dt_admissao_funcionario            as ADMISSAO,
    isnull(fi.qt_salario_familia,0)      as QTD_SAL_FAMILIA,
    isnull(fi.qt_ir,0)                   as QT_IR,
    cg.cd_cbo_cargo_funcionario          as CBO,
    cg.nm_cargo_funcionario              as CARGO, 
    null                                 as LOCAL_EMPRESA,
    f.cd_chapa_funcionario               as CHAPA,
    f.cd_banco                           as BANCO,
    f.cd_agencia_funcionario             as AGENCIA,
    f.cd_conta_funcionario               as CONTA_CORRENTE,
    d.nm_departamento                    as DEPARTAMENTO,
    cc.nm_centro_custo                   as CENTRO_CUSTO,
    f.nm_setor_funcionario               as SETOR,
    null                                 as SECCAO,
    cast('' as varchar)                  as MENSAGEM,
    isnull(fc.vl_total_provento,0)       as TOTAL_PROVENTOS,
    isnull(fc.vl_total_desconto,0)       as TOTAL_DESCONTOS,
    isnull(fc.vl_total_liquido,0)        as TOTAL_LIQUIDO,
    isnull(fe.vl_funcionario_evento,0)   as SALARIO_BASE,
    isnull(fc.vl_salario_inss,0)         as SALARIO_INSS,
    isnull(fc.vl_base_fgts,0)            as BASE_FGTS,
    isnull(fc.vl_fgts,0)                 as FGTS_MES,
    isnull(fc.vl_base_irrf,0)            as BASE_IRRF,
    isnull(fc.vl_faixa_irrf,0)           as FAIXA_IRRF,
    --''                                   as EXTENSO,
    '***(' + dbo.fn_valor_extenso(fc.vl_total_liquido) + ')***'        as 'EXTENSO',

    rtrim(ltrim(cast(day(cf.dt_pagto_calculo_folha) as varchar)+'/'+
          m.nm_mes+'/'+cast(year(cf.dt_pagto_calculo_folha) as varchar)))

                                         as REFERENCIA,

    --Eventos

    cf.cd_evento                         as CODIGO_EVENTO,
    ef.nm_evento                         as EVENTO,
    cf.vl_referencia_calculo             as VALOR_REFERENCIA,
    cf.vl_provento_calculo               as VALOR_PROVENTO,
    cf.vl_desconto_calculo               as VALOR_DESCONTO,
    cf.vl_ref_provento_calculo,
    cf.vl_ref_desconto_calculo,
    cf.nm_evento_provento,
    cf.nm_evento_desconto,

    case when ef.cd_tipo_evento = 1 then
       cf.cd_evento
    else
       0
    end                                          as cd_evento_provento,

    case when ef.cd_tipo_evento = 2 then
      cf.cd_evento
    else
      0
    end                                          as cd_evento_desconto,


    tcf.nm_tipo_calculo_folha,                                            --LAZARO
    sf.nm_situacao_funcionario                                            --Lazaro
    --cf.dt_base                                                         --LAZARO 


--select * from situacao_funcionario 
--select * from Funcionario_Calculo
--select * from Calculo_Folha
--select * from funcionario  
from     
  Funcionario f                              with (nolock) 
  left outer join Cargo_Funcionario    cg    with (nolock) on cg.cd_cargo_funcionario         = f.cd_cargo_funcionario
  left outer join Departamento         d     with (nolock) on d.cd_departamento               = f.cd_departamento
  left outer join Centro_Custo         cc    with (nolock) on cc.cd_centro_custo              = f.cd_centro_custo
  left outer join Situacao_Funcionario sf    with (nolock) on sf.cd_situacao_funcionario      = f.cd_situacao_funcionario
  left outer join Funcionario_Evento   fe    with (nolock) on fe.cd_funcionario               = f.cd_funcionario and
                                                              isnull(fe.ic_ativo_calculo,'S') = 'S'

  left outer join Evento_Folha         efs   with (nolock) on efs.cd_evento                  = fe.cd_evento 
  left outer join Natureza_Evento      ne    with (nolock) on ne.cd_natureza_evento          = efs.cd_natureza_evento 
  left outer join Funcionario_Calculo  fc    with (nolock) on fc.cd_funcionario              = f.cd_funcionario   and
                                                            fc.dt_base_calculo             = @dt_base_pagamento and
                                                            fc.cd_controle_folha           = @cd_controle_folha 
                                                      

  left outer join Calculo_Folha cf           with (nolock) on cf.cd_funcionario          = f.cd_funcionario 
  inner join Evento_Folha ef                 with (nolock) on ef.cd_evento               = cf.cd_evento
  left outer join Mes m                      with (nolock) on m.cd_mes                   = month(cf.dt_pagto_calculo_folha)             
  left outer join funcionario_informacao fi  with (nolock) on fi.cd_funcionario          = f.cd_funcionario
  left outer join Tipo_Calculo_Folha  tcf    with (nolock) on tcf.cd_tipo_calculo_folha  = @cd_tipo_calculo_folha  --LAZARO

--select * from funcionario_informacao
--SELECT * FROM MES 
where
  cf.cd_controle_folha = @cd_controle_folha and
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end and
  isnull(sf.ic_processo_calculo,'S') = 'S'         and
  isnull(fe.vl_funcionario_evento,0)>0             and
--  isnull(ef.ic_salario_evento,'N') = 'S'           and
  cf.dt_pagto_calculo_folha   = @dt_base_pagamento and
  cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 

order by d.nm_departamento,f.nm_setor_funcionario,F.cd_chapa_funcionario,cf.cd_evento
end

------------------------------------------------------------------------------
--DADOS DOS EVENTOS
------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  --select * from calculo_folha

  select
    cf.cd_funcionario,
    cf.dt_pagto_calculo_folha,
    cf.cd_evento               as CODIGO_EVENTO,
    ef.nm_evento               as EVENTO,
    cf.vl_referencia_calculo   as VALOR_REFERECIA,
    cf.vl_provento_calculo     as VALOR_PROVENTO,
    cf.vl_desconto_calculo     as VALOR_DESCONTO
     
  from
    Calculo_Folha cf           with (nolock) 
    inner join Evento_Folha ef with (nolock) on ef.cd_evento = cf.cd_evento
  where
    cf.cd_funcionario        = case when @cd_funcionario = 0 then cf.cd_funcionario else @cd_funcionario end and
    dt_pagto_calculo_folha   = @dt_base_pagamento                                                      and
    cf.cd_tipo_calculo_folha = case when @cd_tipo_calculo_folha = 0 then cf.cd_tipo_calculo_folha else @cd_tipo_calculo_folha end 
    
end


--Cabeçalho

if @ic_parametro = 3
begin

  --select * from funcionario
  --select * from cargo_funcionario
   
  select
    '.'                                  as PONTO,
    @cd_empresa                          as CODIGO_EMPRESA,
    @nm_empresa                          as EMPRESA,
    @cd_cnpj_empresa                     as CNPJ_EMPRESA,
    1                                    as PAGINA,
    f.cd_funcionario                     as CODIGO_FUNCIONARIO,
    f.nm_funcionario                     as FUNCIONARIO,
    cf.cd_cbo_cargo_funcionario          as CBO,
    null                                 as LOCAL_EMPRESA,
    f.cd_chapa_funcionario               as CHAPA,
    f.cd_banco                           as BANCO,
    f.cd_agencia_funcionario             as AGENCIA,
    f.cd_conta_funcionario               as CONTA_CORRENTE,
    d.nm_departamento                    as DEPARTAMENTO,
    cc.nm_centro_custo                   as CENTRO_CUSTO,
    f.nm_setor_funcionario               as SETOR,
    null                                 as SECCAO,
    cast('' as varchar)                  as MENSAGEM,
    isnull(fc.vl_total_provento,0)       as TOTAL_PROVENTOS,
    isnull(fc.vl_total_desconto,0)       as TOTAL_DESCONTOS,
    isnull(fc.vl_total_liquido,0)        as TOTAL_LIQUIDO,
    isnull(fe.vl_funcionario_evento,0)   as SALARIO_BASE,
    isnull(fc.vl_salario_inss,0)         as SALARIO_INSS,
    isnull(fc.vl_base_fgts,0)            as BASE_FGTS,
    isnull(fc.vl_fgts,0)                 as FTGS_MES,
    isnull(fc.vl_base_irrf,0)            as BASE_IRFF,
    isnull(fc.vl_faixa_irrf,0)           as FAIXA_IRFF,
    ''                                   as EXTENSO

--select * from Funcionario_Calculo
  
from     
  Funcionario f                           with (nolock) 
  left outer join Cargo_Funcionario    cf with (nolock) on cf.cd_cargo_funcionario         = f.cd_cargo_funcionario
  left outer join Departamento         d  with (nolock) on d.cd_departamento               = f.cd_departamento
  left outer join Centro_Custo         cc with (nolock) on cc.cd_centro_custo              = f.cd_centro_custo
  left outer join Situacao_Funcionario sf with (nolock) on sf.cd_situacao_funcionario      = f.cd_situacao_funcionario
  left outer join Funcionario_Evento   fe with (nolock) on fe.cd_funcionario               = f.cd_funcionario and
                                                           isnull(fe.ic_ativo_calculo,'S') = 'S'

  left outer join Evento_Folha         ef with (nolock) on ef.cd_evento               = fe.cd_evento 
  left outer join Natureza_Evento      ne with (nolock) on ne.cd_natureza_evento      = ef.cd_natureza_evento 
  left outer join Funcionario_Calculo  fc with (nolock) on fc.cd_funcionario          = f.cd_funcionario  and
                                                           fc.dt_base_calculo         = @dt_base_pagamento                                                      

               

where
  f.cd_funcionario = case when @cd_funcionario = 0 then f.cd_funcionario else @cd_funcionario end and
  isnull(sf.ic_processo_calculo,'S') = 'S'      and
  isnull(fe.vl_funcionario_evento,0)>0   
  --and isnull(ef.ic_salario_evento,'N') = 'S'        

end



