
CREATE  PROCEDURE pr_busca_dispositivo_legal_classificacao_fiscal
@cd_classificacao_fiscal int = 0,
@cd_estado               int = 0,
@sg_estado               char(2)

as

declare @cd_dispositivo_legal        int
declare @cd_dispositivo_legal_estado int
declare @cd_dispositivo_legal_ipi int

set nocount on

if @sg_estado <> ''
  select 
    @cd_estado = cd_estado
  from
    estado with (nolock) 
  where
    cd_pais   = 1 and -- Brasil
    sg_estado = @sg_estado

-- Dispositivo Legal da Classificação Fiscal

set @cd_dispositivo_legal=0

select 
  @cd_dispositivo_legal     = isnull(cf.cd_dispositivo_legal,0), --Dispositivo Legal para todos os estados
  @cd_dispositivo_legal_ipi = IsNull(cf.cd_dispositivo_legal_ipi,0)
from
   classificacao_fiscal cf with (nolock) 
where
   cf.cd_classificacao_fiscal = @cd_classificacao_fiscal

-- Dispositivo Legal da Classificação do Estado

set @cd_dispositivo_legal_estado = 0

select @cd_dispositivo_legal_estado = isnull(cfe.cd_dispositivo_legal,0)
from
   classificacao_fiscal_estado cfe with (nolock) 
where
   cfe.cd_classificacao_fiscal = @cd_classificacao_fiscal and
   cfe.cd_estado               = @cd_estado


-- Verifica o Código do Dispositivo Legal do Estado
if @cd_dispositivo_legal_estado > 0 and @cd_dispositivo_legal_estado <> @cd_dispositivo_legal
begin
   set @cd_dispositivo_legal = @cd_dispositivo_legal_estado
end

--Foi criada a questão da temporária devido a problema na forma que o SQL foi planejado
select top 1
  case @cd_dispositivo_legal
    when 0 then
     cast('' as text)
   else
     dlicms.ds_dispositivo_legal
  end as ds_dispositivo_legal,
  cast('' as text) as ds_dispositivo_legal_ipi
into
  #Dispositivo

from
  dispositivo_legal dlicms with (nolock) 

where
  dlicms.cd_dispositivo_legal = @cd_dispositivo_legal

update #Dispositivo
set ds_dispositivo_legal_ipi =   ( case @cd_dispositivo_legal_ipi
                                     when 0 then
                                       cast('' as text)
                                     else
                                       dlipi.ds_dispositivo_legal
                                     end )
from
  #Dispositivo, dispositivo_legal dlipi

where
  dlipi.cd_dispositivo_legal = @cd_dispositivo_legal_ipi

select * from #Dispositivo

set nocount off


