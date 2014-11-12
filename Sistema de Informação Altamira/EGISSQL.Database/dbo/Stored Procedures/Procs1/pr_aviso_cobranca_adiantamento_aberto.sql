
-------------------------------------------------------------------------------
--sp_helptext pr_aviso_cobranca_adiantamento_aberto
-------------------------------------------------------------------------------
--pr_aviso_cobranca_adiantamento_aberto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Aviso de Cobrança de Adiantamento em aberto
--                   Conforme parâmetro
--Data             : 01.01.2008
--Alteração        : 18.02.2008, checagem da tabela de aprovação
--
--
------------------------------------------------------------------------------
create procedure pr_aviso_cobranca_adiantamento_aberto
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@ic_selecao   int      = 0

as


if @ic_parametro = 0
begin

  declare @qt_dia_retorno_aviso int

  select
    @qt_dia_retorno_aviso = isnull(qt_dia_retorno_aviso,30)
  from
    parametro_prestacao_conta
  where
    cd_empresa = dbo.fn_empresa()

--select @qt_dia_retorno_aviso

--select * from solicitacao_adiantamento

select
 
--   case when sa.dt_solicitacao + @qt_dia_retorno_aviso < getdate() 
--   then
--     1
--   else
--     0
--   end                                                                    as Sel,

  @ic_selecao as Sel,

  case when sa.dt_solicitacao + @qt_dia_retorno_aviso < getdate() 
  then
    'Vencido'
  else
    'Aberto'
  end                                                                    as Status,
  sa.dt_solicitacao + @qt_dia_retorno_aviso                              as Vencimento,
  cast(getdate() - ( sa.dt_solicitacao + @qt_dia_retorno_aviso) as int ) as Dias,
  sa.cd_solicitacao,
  sa.dt_solicitacao,
  sa.cd_funcionario,
  f.nm_funcionario,
  f.nm_email_funcionario,
  d.nm_departamento,
  cc.nm_centro_custo,
  sa.vl_adiantamento,
  av.nm_assunto_viagem,
  sa.dt_aviso_cobranca
from
  solicitacao_adiantamento sa       with (nolock)
  inner join funcionario   f        with (nolock) on f.cd_funcionario     = sa.cd_funcionario
  left outer join Centro_custo cc   with (nolock) on cc.cd_centro_custo   = sa.cd_centro_custo
  left outer join Departamento d    with (nolock) on d.cd_departamento    = sa.cd_departamento
  left outer join Assunto_Viagem av with (nolock) on av.cd_assunto_viagem = sa.cd_assunto_viagem
where
  isnull(sa.cd_prestacao,0) = 0 
  and sa.cd_solicitacao not in ( select cd_solicitacao from solicitacao_adiantamento_aprovacao )
  and sa.dt_aviso_cobranca is null
  --and sa.dt_solicitacao + @qt_dia_retorno_aviso > getdate()
order by
  sa.dt_solicitacao,
  f.nm_funcionario


end


------------------------------------------------------------------------------
--Liberação da Data Envio para Nova Geração
------------------------------------------------------------------------------

if @ic_parametro = 9
begin
  update
    solicitacao_adiantamento
  set
    dt_aviso_cobranca = null
  from
    solicitacao_adiantamento sa
  where
    sa.dt_aviso_cobranca is not null and
    sa.cd_solicitacao not in ( select cd_solicitacao from solicitacao_adiantamento_aprovacao )
   
end

