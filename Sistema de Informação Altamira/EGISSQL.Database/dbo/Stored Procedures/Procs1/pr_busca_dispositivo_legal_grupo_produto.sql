CREATE   PROCEDURE pr_busca_dispositivo_legal_grupo_produto

@cd_grupo_produto int

as

declare @cd_dispositivo_legal_ipi    int
declare @cd_dispositivo_legal_icms   int

declare @ds_dispositivo_legal_ipi    varchar(8000)
declare @ds_dispositivo_legal_icms   varchar(8000)

set @cd_dispositivo_legal_ipi  = 0
set @cd_dispositivo_legal_icms = 0

-- Dispositivo Legal da Classificação Fiscal

select @cd_dispositivo_legal_ipi  = isnull(gpf.cd_dispositivo_legal_ipi,0),
       @cd_dispositivo_legal_icms = isnull(gpf.cd_dispositivo_legal_icms,0) 
from
   Grupo_Produto_Fiscal gpf
where
   gpf.cd_grupo_produto = @cd_grupo_produto

-- Dispositivo Legal do IPI

if @cd_dispositivo_legal_ipi>0
begin
  select 
    @ds_dispositivo_legal_ipi = dl.ds_dispositivo_legal 
  from
    dispositivo_legal dl
  where
    dl.cd_dispositivo_legal    = @cd_dispositivo_legal_ipi
end

if @cd_dispositivo_legal_icms>0
begin
  select 
    @ds_dispositivo_legal_icms = dl.ds_dispositivo_legal 
  from
    dispositivo_legal dl
  where
    dl.cd_dispositivo_legal    = @cd_dispositivo_legal_icms
end

select @ds_dispositivo_legal_ipi  as 'DispositivoIPI',
       @ds_dispositivo_legal_icms as 'DispositivoICMS'


