
-------------------------------------------------------------------------------
--sp_helptext pr_deposito_prestacao_conta_fornecedor
-------------------------------------------------------------------------------
--pr_deposito_prestacao_conta_fornecedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--                   Carlos Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mostrar os Adiantamentos para Depósito após Prestação 
--                   de Contas
--Data             : 09/05/2007
--Alteração        : 05.11.2007 - Não mostrar acertos de Cartão de Crédito
--14.11.2007 - Matrícula do Funcionário
--25.11.2007 - Somente mostrar as prestações de contas após a Aprovação - Carlos Fernandes
--30.11.2007 - Acerto de verificação de Aprovação - Carlos Fernandes
--20.06.2008 - Filtro para separação do Fornecedor - Carlos Fernandes
--11.08.2008 - Verificação após o ajuste da prestação de Contas - Carlos Fernandes
--01.09.2008 - Ajuste porque não estava mostrando a prestação - Carlos Fernandes
-------------------------------------------------------------------------------------------
create procedure pr_deposito_prestacao_conta_fornecedor
@dt_inicial datetime = '',
@dt_final   datetime = '',
@ic_tipo    char(1)  = 'A' --Analítico
                           --Sintético

as

--select * from parametro_prestacao_conta


declare @ic_aprovacao char(1)

select
  @ic_aprovacao = isnull(ic_gera_email_aprovacao,'N')
from
  parametro_prestacao_conta  
where
  cd_empresa = dbo.fn_empresa()

  --select * from prestacao_conta

  select 
    pc.cd_prestacao,
    pc.dt_prestacao,
    isnull(case
      when pc.vl_prestacao < 0 then
        isnull(pc.vl_prestacao,0) *(-1)
      else
        isnull(pc.vl_prestacao,0)
    end,0)                                    as vl_prestacao,
    f.cd_funcionario,
    f.cd_chapa_funcionario,
    f.nm_funcionario,
    case
      when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
        ''
      else
        isnull(b.nm_banco,'')                     
    end                                       as nm_banco,
    case
      when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
        ''
      else
        isnull(f.cd_agencia_funcionario,'')       
    end                                       as cd_agencia_funcionario,
    case
      when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
        ''
      else
        isnull(f.cd_conta_funcionario,'')         
    end                                       as cd_conta_funcionario,
    isnull(d.nm_departamento,'')              as nm_departamento,
    isnull(cc.nm_centro_custo,'')             as nm_centro_custo,
    pc.ic_tipo_deposito_prestacao,
    case
      when isnull(pc.ic_tipo_deposito_prestacao,'E') = 'E' then
        'Empresa'
      else
        'Funcionário'
    end                                       as nm_tipo_deposito_prestacao,
    m.sg_moeda  
  into
    #DepositoPrestacao

  from
    Prestacao_Conta pc                       with (nolock) 
    left  join Prestacao_Conta_Aprovacao pca with (nolock) on pca.cd_prestacao   = pc.cd_prestacao
    left  join Funcionario f                 with (nolock) on f.cd_funcionario   = pc.cd_funcionario  
    left  join Departamento d                with (nolock) on d.cd_departamento  = pc.cd_departamento
    left  join Centro_Custo cc               with (nolock) on cc.cd_centro_custo = pc.cd_centro_custo
    left  join Banco b                       with (nolock) on b.cd_banco         = f.cd_banco 
    left  join Moeda m                       with (nolock) on m.cd_moeda         = isnull(pc.cd_moeda,1)
  where
    pc.dt_prestacao between @dt_inicial and @dt_final and
    isnull(pc.cd_cartao_credito,0) = 0                and
    pc.dt_conf_fornecedor     is null                 and
    pc.dt_pagamento_prestacao is not null             and
    pc.ic_tipo_deposito_prestacao = 'F'               and
    isnull(pc.vl_prestacao,0)>0                       and
    isnull(pca.ic_aprovado,'N')=case when @ic_aprovacao = 'S' then 'S' else isnull(pca.ic_aprovado,'N') end
    --Somente funcionários portanto a conta contábil tem que ser zero.
    and isnull(f.cd_conta,0)<>0
  order by
    isnull(pc.ic_tipo_deposito_prestacao,'E') Desc,
    pc.dt_prestacao      

--select * from prestacao_conta
-------------------------------------------------------------------------------
--Analítico
-------------------------------------------------------------------------------

if @ic_tipo = 'A' 
begin
  select
    pc.*
  from
    #DepositoPrestacao pc   
  order by
    isnull(pc.ic_tipo_deposito_prestacao,'E') Desc,
    pc.dt_prestacao      
end

-------------------------------------------------------------------------------
--Sintético
-------------------------------------------------------------------------------
   
if @ic_tipo = 'S' 
begin
  select
    max(pc.cd_prestacao)               as cd_prestacao,
    max(pc.dt_prestacao)               as dt_prestacao,
    sum(pc.vl_prestacao)               as vl_prestacao,
    pc.cd_funcionario,
    max(pc.cd_chapa_funcionario)       as cd_chapa_funcionario,
    max(pc.nm_funcionario)             as nm_funcionario,
    max(pc.nm_banco)                   as nm_banco,
    max(pc.cd_agencia_funcionario)     as cd_agencia_funcionario,
    max(pc.cd_conta_funcionario)       as cd_conta_funcionario,
    max(pc.nm_departamento)            as nm_departamento,
    max(pc.nm_centro_custo)            as nm_centro_custo,
    max(pc.ic_tipo_deposito_prestacao) as ic_tipo_deposito_prestacao,
    max(pc.nm_tipo_deposito_prestacao) as nm_tipo_deposito_prestacao,
    max(pc.sg_moeda)                   as sg_moeda

  into
    #DepositoAgrupado
  from
    #DepositoPrestacao pc   
  group by
    pc.cd_funcionario

  select
    pc.*
  from
    #DepositoAgrupado pc   
  order by
    isnull(pc.ic_tipo_deposito_prestacao,'E') Desc,
    pc.dt_prestacao      
  
end


-------------------------------------------------------------------------------

