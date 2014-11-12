
-------------------------------------------------------------------------------
--sp_helptext pr_pagamento_folha_funcionario
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 01.01.2008
--Alteração        : 
--
-- 29.01.2011 - Revisão - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_pagamento_folha_funcionario
@cd_controle_folha int = 0
as

if @cd_controle_folha > 0
begin

--Select * from funcionario

  select
    f.cd_funcionario,
    f.nm_funcionario,
    f.cd_chapa_funcionario,
    d.nm_departamento,
    cc.nm_centro_custo,
    case when isnull(fd.cd_banco,0)>0 then
      fd.cd_banco 
    else
      f.cd_banco
    end                            as cd_banco,
    case when isnull(fd.nm_agencia_deposito,'')<>'' then
      fd.nm_agencia_deposito
    else
      f.cd_agencia_funcionario
    end                            as cd_agencia_funcionario,
    case when isnull(fd.nm_conta_deposito,'')<>'' then
      fd.nm_conta_deposito
    else
      fd.nm_conta_deposito
    end                            as cd_conta_funcionario,
    
    case when isnull(fd.cd_cpf_deposito,'')<>'' then
     fd.cd_cpf_deposito
    else
      f.cd_cpf_funcionario
    end                            as cd_cpf_funcionario,

    fd.nm_favorecido_deposito,

    isnull(fc.vl_total_liquido,0)  as vl_total_liquido,
    tcf.nm_tipo_calculo_folha,
    cf.dt_base

  from
    Funcionario f                           with (nolock) 
    left outer join Departamento d          with (nolock) on d.cd_departamento         = f.cd_departamento
    left outer join Centro_Custo cc         with (nolock) on cc.cd_centro_custo        = f.cd_centro_custo
    left outer join Funcionario_Calculo fc  with (nolock) on fc.cd_funcionario         = f.cd_funcionario
    left outer join Controle_Folha      cf  with (nolock) on cf.cd_controle_folha      = fc.cd_controle_folha
    left outer join Tipo_Calculo_Folha  tcf with (nolock) on tcf.cd_tipo_calculo_folha = cf.cd_tipo_calculo_folha
    left outer join Funcionario_Deposito fd with (nolock) on fd.cd_funcionario         = f.cd_funcionario

  where
    fc.cd_controle_folha = @cd_controle_folha

  order by
    f.nm_funcionario  

--select * from funcionario_calculo
--select * from controle_folha

end

