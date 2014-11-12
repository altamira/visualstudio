
-------------------------------------------------------------------------------
--sp_helptext pr_nota_fiscal_servico_eletronica
-------------------------------------------------------------------------------
--pr_nota_fiscal_servico_eletronica
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 11.06.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_nota_fiscal_servico_eletronica
@cd_nota_saida int = 0
as

--select * from nota_saida_item

declare @cd_parcela_nota_saida int
declare @ds_servico            varchar(8000)
declare @vl_liquido            decimal(25,2)
declare @nm_parcela            varchar(100)

create table
 #NF
 (cd_nota_saida int,
  ds_obs_nota   ntext )


insert into #NF 
  select 
    @cd_nota_saida,
    --cast('' as varchar)
    cast(isnull(ns.ds_obs_compl_nota_saida,'') as ntext )
  from
    Nota_Saida ns
  where
    ns.cd_nota_saida = @cd_nota_saida
  
--Itens da Nota Fiscal


--Valor Líquido
select
  @vl_liquido = 0.0

set @ds_servico = 'Valor Líquido '+cast(@vl_liquido as varchar)+' '+char(13)

--Parcela

select
  *
into
  #Parcela
from
  Nota_Saida_Parcela
where
  cd_nota_saida = @cd_nota_saida


while exists ( select top 1 cd_parcela_nota_saida from #Parcela )
begin
  select top 1
    @cd_parcela_nota_saida = cd_parcela_nota_saida,
    @nm_parcela            = 'Parcela : '+cd_ident_parc_nota_saida +' Vencimento: '+cast(dt_parcela_nota_saida as varchar)+' Valor: '+cast(vl_parcela_nota_saida as varchar)+char(13)     
  from
    #Parcela

  set @ds_servico = @ds_servico + @nm_parcela

  delete from #Parcela
  where
   cd_nota_saida         = @cd_nota_saida and
   cd_parcela_nota_saida = @cd_parcela_nota_saida    

end
  
-- update
--   #NF
-- set
--   ds_obs_nota = ds_obs_nota + cast(@ds_servico as text )
-- from
--   #NF n

-- select 
--   @cd_nota_saida                     as Nota,
--   @ds_servico                        as Observacao

--select * from nota_saida_parcela


select
  cd_nota_saida as Nota,
  ds_obs_nota   as Observacao

from
  #NF

