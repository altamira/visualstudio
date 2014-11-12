


CREATE   PROCEDURE pr_busca_dispositivo_operacao_fiscal

@cd_operacao_fiscal int = 0

as

declare @cd_dispositivo_legal_ipi    int
declare @cd_dispositivo_legal_icms   int

declare @ds_dispositivo_legal_ipi    varchar(8000)
declare @ds_dispositivo_legal_icms   varchar(8000)

set @cd_dispositivo_legal_ipi  = 0
set @cd_dispositivo_legal_icms = 0

-- Dispositivo Legal da Operacao_Fiscal

select @cd_dispositivo_legal_ipi  = isnull(ofi.cd_dispositivo_legal_ipi,0),
       @cd_dispositivo_legal_icms = isnull(ofi.cd_dispositivo_legal_icms,0) 
from
   Operacao_Fiscal ofi with (nolock) 
where
   ofi.cd_operacao_fiscal = @cd_operacao_fiscal

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


--Mostra o Código Final


-- select @cd_dispositivo_legal_ipi  as cd_dispositivo_legal_ipi,
--        @cd_dispositivo_legal_icms as cd_dispositivo_legal_icms


-- -- Dispositivo Legal do IPI
-- 
-- if @cd_dispositivo_legal_ipi>0
-- begin
--   select 
--     @ds_dispositivo_legal_ipi = dl.ds_dispositivo_legal 
--   from
--     dispositivo_legal dl with (nolock) 
--   where
--     dl.cd_dispositivo_legal    = @cd_dispositivo_legal_ipi
-- end
-- 
-- if @cd_dispositivo_legal_icms>0
-- begin
--   select 
--     @ds_dispositivo_legal_icms = dl.ds_dispositivo_legal 
--   from
--     dispositivo_legal dl with (nolock) 
--   where
--     dl.cd_dispositivo_legal    = @cd_dispositivo_legal_icms
-- end

-- select @ds_dispositivo_legal_ipi  as 'DispositivoIPI',
--        @ds_dispositivo_legal_icms as 'DispositivoICMS'
-- 
-- select top 1
--   @cd_dispositivo_legal_ipi                  as cd_dispositivo_legal_ipi,
--   @cd_dispositivo_legal_icms                 as cd_dispositivo_legal_icms,
--   cast('' as text )                          as 'DispositivoIPI',
--   cast('' as text )                          as 'DispositivoICMS'
-- 
-- into
--   #Dispositivo
-- 
-- --IPI
-- 
-- update
--   #Dispositivo
-- set
--   DispositivoIPI  = dipi.ds_dispositivo_legal
--   --DispositivoICMS = dicms.ds_dispositivo_legal
-- from
--   #Dispositivo, Dispositivo_Legal dipi
-- where
--   dipi.cd_dispositivo_legal  = @cd_dispositivo_legal_ipi 
-- 
-- --ICMS
-- 
-- update
--   #Dispositivo
-- set
-- --  DispositivoIPI  = dipi.ds_dispositivo_legal,
--   DispositivoICMS = dicms.ds_dispositivo_legal
-- from
--   #Dispositivo, Dispositivo_Legal dicms
-- where
--   dicms.cd_dispositivo_legal = @cd_dispositivo_legal_icms
-- 
-- select * from #Dispositivo
-- 
-- drop table #Dispositivo


