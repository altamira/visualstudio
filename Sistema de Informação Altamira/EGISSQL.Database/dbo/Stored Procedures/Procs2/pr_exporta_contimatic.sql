
-------------------------------------------------------------------------------  
--sp_helptext pr_exporta_contimatic  
-------------------------------------------------------------------------------  
--pr_exporta_contimatic  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2009  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Douglas de Paula Lopes  
--Banco de Dados   : Egissql  
--Objetivo         :   
--Data             : 02.06.2009  
--Alteração        : 16.06.2009 - Arredondamento - Carlos Fernandes  
-- 18.08.2009 - Contas Contábeis - Carlos Fernandes  
-- 05.10.2009 - Ajustes Diversos - Carlos Fernandes  
-- 16.10.2009 - Verificação da Série / Espécie - Carlos Fernandes
-- 20.10.2009 - Ajustes Diversos - Carlos Fernandes
-- 26.10.2009 - 02 CFOP 's - Carlos Fernandes
-- 29.01.2010 - Verificação do lay-out - Carlos Fernandes
------------------------------------------------------------------------------  
create procedure pr_exporta_contimatic  
  @dt_inicial    datetime,  
  @dt_final      datetime,  
  @cd_nota_saida int = 0  
  
as  
  
declare c_nota_saida cursor for -- select * from nota_saida_item  
  
select   
  distinct
  cd_nota_saida  
from  
  nota_saida with(nolock)   
where   
  dt_nota_saida between @dt_inicial and @dt_final and  
  --dt_cancel_nota_saida is null and  
  cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then cd_nota_saida else  @cd_nota_saida end  
order by  
  cd_nota_saida  
  
open c_nota_saida  
  
declare @cd_nota_saida_c int  
set     @cd_nota_saida_c = 0  
  
declare @cd_item int  
set     @cd_item = 0  
  
create table #Tabela (cd_nota_saida int,
                      Coluna        varchar(8000))  

create table #ValoresICMS (cd_nota_saida       int, 
                           cd_operacao_fiscal  int, 
                           cd_item_icms        int, 
                           vl_base_icms_item   float,
                           pc_icms_item        float, 
                           vl_icms_item        float, 
                           vl_icms_isento_item float, 
                           vl_icms_outros_item float,
                           cd_item             int)  
   
fetch next from c_nota_saida into @cd_nota_saida_c  
  
while (@@fetch_status <> -1)   
begin  
  
  -----------------------------------------------------------------------------------------  
  --Tabela temporária com as alíquotas do ICMS  
  -----------------------------------------------------------------------------------------  
  
  select  
    @cd_nota_saida_c                                  as cd_nota_saida,    
    ns.cd_operacao_fiscal,
    cast(1 as int )                                   as cd_item_icms,
    sum(round(isnull(ns.vl_base_icms_item,0.00),2))   as vl_base_icms_item,  
    isnull(ns.pc_icms,0.00)                           as pc_icms_item,  
    sum(round(isnull(ns.vl_icms_item,0.00),2))        as vl_icms_item,  

--     sum(case when ( opf.cd_mascara_operacao = '5.405' or opf.cd_mascara_operacao = '6.405' ) 
--     then
--       0.00
--     else
--       round(isnull(ns.vl_icms_isento_item,0.00),2)
--     end)                                              as vl_icms_isento_item,  

    sum(round(isnull(ns.vl_icms_isento_item,0.00),2)) as vl_icms_isento_item,
    sum(round(isnull(ns.vl_icms_outros_item,0.00),2)) as vl_icms_outros_item,
    identity(smallint,1,1)                            as cd_item
   
  into  
    #fff  
  
  from   
    nota_saida_item ns with(nolock)  
    left outer join operacao_fiscal opf on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where  
    ns.cd_nota_saida = @cd_nota_saida_c 
    --and isnull(ns.pc_icms,0.00) > 0.00   
  group by  
    --@cd_nota_saida_c,    
    ns.cd_operacao_fiscal,
    isnull(ns.pc_icms,0.00)

  order by  
    4 desc  
  
  insert into #ValoresICMS  
    select * from #fff  
  
  drop table #fff  
  
  fetch next from c_nota_saida into @cd_nota_saida_c  
  
end  
  
close      c_nota_saida  
deallocate c_nota_saida  


--Mostra a tabela auxiliar
  
--select * from #ValoresICMS order by cd_nota_saida, pc_icms_item  

--Agrupado

select
  cd_nota_saida,
  cd_operacao_fiscal,
  --pc_icms_item,
  count(*)           as Qtd
into
  #Ajuste

from
  #ValoresICMS
group by
  cd_nota_saida,
  cd_operacao_fiscal
  --pc_icms_item
order by
  cd_nota_saida
  

--select * from #Ajuste
  
-----------------------------------------------------------------------------------------  
--Atualiza o Item  
-----------------------------------------------------------------------------------------  

update
  #ValoresICMS
set
  --cd_item_icms = case when (x.cd_item-1)>0 then x.cd_item-1 else 1 end
  cd_item_icms = x.cd_item

from
  #ValoresICMS x
where
  x.cd_nota_saida in ( select
                         cd_nota_saida 
                       from
                         #Ajuste
                       where
                         cd_operacao_fiscal = x.cd_operacao_fiscal and
                         Qtd>1 )

--select * from #ValoresICMS order by cd_nota_saida, pc_icms_item  


-- declare @cd_item_icms int 
-- declare @cd_nota      int
-- declare @pc_icms      float
-- declare @cd_operacao  int
-- 
-- select
--    * 
-- into
--    #AJuste
-- from #ValoresICMS 
-- order by 
--   cd_nota_saida, 
--   pc_icms_item  
-- 
-- set @cd_nota     = 0
-- set @cd_operacao = 0
-- set @pc_icms     = 0
-- 
-- while exists ( select top 1 cd_nota_saida from #Ajuste )
-- begin
--    
-- 
--   select top 1
--     @cd_nota     = cd_nota_saida,
--     @cd_operacao = cd_operacao_fiscal,
--     @pc_icms     = pc_icms_item
--   from #Ajuste 
--  
--   delete from #Ajuste
--   where
--     @cd_nota     = cd_nota_saida      and
--     @cd_operacao = cd_operacao_fiscal and
--     @pc_icms     = pc_icms_item
-- 
-- end
-- 
-----------------------------------------------------------------------------------------  
--  
-----------------------------------------------------------------------------------------  
  
declare c_nota_saida cursor for -- select * from nota_saida_item  
select   
  distinct
  cd_nota_saida  
from  
  nota_saida with (nolock)   
where   
  dt_nota_saida between @dt_inicial and @dt_final and  
  --dt_cancel_nota_saida is null and  
  cd_nota_saida = case when isnull(@cd_nota_saida,0) = 0 then cd_nota_saida else  @cd_nota_saida end  
order by  
  cd_nota_saida  
  
open c_nota_saida  
   
fetch next from c_nota_saida into @cd_nota_saida_c  
  
  
while (@@fetch_status <> -1)   
begin  

 --Agrupa notas por CFOP

 select
   cd_nota_saida,
   max(dt_nota_saida)            as dt_nota_saida,
   max(TIPOREGISTRO)             as TIPOREGISTRO,
   max(DDMMNF)                   as DDMMNF,
   max(DDMMESNF)                 as DDMMESNF,
   max(DIAINTEGRACAO)            as DIAINTEGRACAO,
   max(ESPECIE)                  as ESPECIE,
   max(SERIE)                    as SERIE,
   max(NUM_NOTA_INICIAL)         as NUM_NOTA_INICIAL,
   max(NUM_NOTA_FINAL)           as NUM_NOTA_FINAL,
   max(NATUREZA)                 as NATUREZA,
   sum(VALOR_CONTABIL)           as VALOR_CONTABIL,
   max(BASE_ICMS_1)              as BASE_ICMS_1,
   max(nm_destinacao_produto)    as nm_destinacao_produto,
   sum(VALOR_CONSISTENCIA)       as VALOR_CONSISTENCIA,
   sum(ALIQ_ICMS_1)              as ALIQ_ICMS_1,
   sum(ICMS_1)                   as ICMS_1,
   sum(ISENTAS_ICMS_1)           as ISENTAS_ICMS_1,
   sum(OUTRAS_ICMS_1)            as OUTRAS_ICMS_1,
   sum(BASE_ICMS_2)              as BASE_ICMS_2,
   sum(ALIQ_ICMS_2)              as ALIQ_ICMS_2,
   sum(ICMS_2)                   as ICMS_2,
   sum(ISENTAS_ICMS_2)           as ISENTAS_ICMS_2,
   sum(OUTRAS_ICMS_2)            as OUTRAS_ICMS_2,
   sum(BASE_ICMS_3)              as BASE_ICMS_3,
   sum(ALIQ_ICMS_3)              as ALIQ_ICMS_3,
   sum(ICMS_3)                   as ICMS_3,
   sum(ISENTAS_ICMS_3)           as ISENTAS_ICMS_3,
   sum(OUTRAS_ICMS_3)            as OUTRAS_ICMS_3,
   sum(BASE_ICMS_4)              as BASE_ICMS_4,
   sum(ALIQ_ICMS_4)              as ALIQ_ICMS_4,
   sum(ICMS_4)                   as ICMS_4,
   sum(ISENTAS_ICMS_4)           as ISENTAS_ICMS_4,
   sum(OUTRAS_ICMS_4)            as OUTRAS_ICMS_4,
   sum(BASE_ICMS_5)              as BASE_ICMS_5,
   sum(ALIQ_ICMS_5)              as ALIQ_ICMS_5,
   sum(ICMS_5)                   as ICMS_5,
   sum(ISENTAS_ICMS_5)           as ISENTAS_ICMS_5,
   sum(OUTRAS_ICMS_5)            as OUTRAS_ICMS_5,
   sum(BASE_IPI)                 as BASE_IPI,
   sum(IPI)                      as IPI,
   sum(ISENTAS_IPI)              as ISENTAS_IPI,
   sum(OUTRAS_IPI)               as OUTRAS_IPI,
   sum(IPI_NAO_APRO)             as IPI_NAO_APRO,
   sum(ICMS_FONTE)               as ICMS_FONTE,
   sum(DESCONTONF)               as DESCONTONF,
   sum(VLRVISTA)                 as VLRVISTA,
   sum(VLRPRAZO)                 as VLRPRAZO,
   sum(ISENTO_PIS)               as ISENTO_PIS,
   max(TIPONOTA)                 as TIPONOTA,
   max(CONTRIBUINTE)             as CONTRIBUINTE,
   max(COD_CONTAB)               as COD_CONTAB,
   max(OBSLIVRE)                 as OBSLIVRE,
   max(CGC_CPF)                  as CGC_CPF,
   max(INSCESTADUAL)             as INSCESTADUAL,
   max(RAZAO)                    as RAZAO,
   max(CTACTBL)                  as CTACTBL,
   max(UF)                       as UF,
   max(NUNMUNICP)                as NUNMUNICP,
   max(desconto)                 as desconto,
   max(pvv)                      as pvv,
   max(VAGO)                     as VAGO,
   cd_operacao_fiscal,
   max(cd_grupo_operacao_fiscal) as cd_grupo_operacao_fiscal,
   max(cd_tipo_operacao_fiscal)  as cd_tipo_operacao_fiscal,
   max(cd_mascara_operacao)      as cd_mascara_operacao

 into  
   #tempCFOP  

 from  
   vw_exporta_saida_contmatic c with(nolock)  
  
 where   
   cd_nota_saida = @cd_nota_saida_c  

 group by
   cd_nota_saida,
   cd_operacao_fiscal
 
  
 select  

   cd_nota_saida,  

   isnull(cast(TIPOREGISTRO  as char(2)),'') +  
   isnull(cast(DDMMNF        as char(4)),'') +  
   isnull(cast(DDMMESNF      as char(4)),'') +  
   isnull(cast(DIAINTEGRACAO as char(02)),'') +  
   isnull(cast(ESPECIE       as char(03)),'') +  
   isnull(cast(SERIE         as char(03)),'') +  
   isnull(replicate('0',6 - len(Rtrim(ltrim(cast(NUM_NOTA_INICIAL as varchar(6))))))  + cast(Rtrim(ltrim(cast(NUM_NOTA_INICIAL as varchar(6)))) as varchar(6)),'') +  
   isnull(replicate('0',6 - len(Rtrim(ltrim(cast(NUM_NOTA_FINAL   as varchar(6))))))  + cast(Rtrim(ltrim(cast(NUM_NOTA_FINAL as varchar(6))))   as varchar(6)),'') +  

   case when isnull(rtrim(ltrim(cast(NATUREZA as varchar(120)))),'5.102') = '' then  
     '5.102'  
   else  
      isnull(rtrim(ltrim(cast(NATUREZA as varchar(120)))),'5.102')   
   end+  

   isnull(dbo.fn_mascara_valor_duas_casas_F(VALOR_CONTABIL),'') +  

--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_1),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_1),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_1),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_1),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_1),0.00)),'') +  
-- 
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_2),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_2),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_2),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_2),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_2),0.00)),'') +  
-- 
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_3),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_3),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_3),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_3),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_3),0.00)),'') +  
-- 
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_4),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_4),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_4),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_4),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_4),0.00)),'') +  
-- 
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_5),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_5),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_5),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_5),0.00)),'') +  
--    isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and pc_icms_item = ALIQ_ICMS_5),0.00)),'') +  

   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 1 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 1 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 1 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 1 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 1 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  

   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 2 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 2 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 2 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 2 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 2 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  

   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 3 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 3 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 3 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 3 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 3 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  

   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 4 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 4 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 4 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 4 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 4 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  

   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 5 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 5 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 5 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 5 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_saida = c.cd_nota_saida and cd_item_icms = 5 and cd_operacao_fiscal = c.cd_operacao_fiscal ),0.00)),'') +  

   isnull(dbo.fn_mascara_valor_duas_casas_F (BASE_IPI),'')     +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (IPI),'')          +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (ISENTAS_IPI),'')  +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (OUTRAS_IPI),'')   +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (IPI_NAO_APRO),'') +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (ICMS_FONTE),'')   +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (DESCONTONF),'')   +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (VLRVISTA),'')     +  
   isnull(dbo.fn_mascara_valor_duas_casas_F (VLRPRAZO),'')     +   
   isnull(dbo.fn_mascara_valor_duas_casas_F (ISENTO_PIS),'')   +  
   isnull(cast(isnull(CONTRIBUINTE,0) as char(1)),'0')      +  
   isnull(cast(isnull(TIPONOTA,'00')  as char(2)),'00')     +  

   cast(COD_CONTAB as char(2))+
   cast(OBSLIVRE as char(14))  +

--   isnull(replicate('0',2 - len(cast(isnull(COD_CONTAB, '0') as varchar(2)))) + cast(isnull(COD_CONTAB, '0') as varchar(2)),'0') +  
--   isnull(replicate(' ',14 - len(cast(isnull(OBSLIVRE, '') as varchar(14)))) + cast(isnull(OBSLIVRE, '' ) as varchar(14)),'') +  

   cast(dbo.fn_limpa_mascara_cnpj_J(CGC_CPF) as char(14)) +      
   --dbo.fn_mascara_ie_F(INSCESTADUAL)  +  

   cast(INSCESTADUAL as char(16))       +   
   cast(RAZAO        as char(35)) +
   cast(CTACTBL as char(18)) + 
 
  --isnull(replicate(' ', 35 - len(cast(isnull(RAZAO, '') as varchar(35)))) + cast(isnull(RAZAO, '') as varchar(35)),'') +  
   --isnull(replicate(' ', 18 - len(cast(isnull(CTACTBL, '') as varchar(18)))) + cast(isnull(CTACTBL, '') as varchar(18)),'') +  

   isnull(cast(UF as char(2)),'SP') +  
   --isnull(replicate('0', 4 - len(rtrim(ltrim(cast(isnull(NUNMUNICP, '') as varchar(4)))))) + cast(isnull(NUNMUNICP, '') as varchar(4)),'') +  
   cast(NUNMUNICP as char(4)) +
   isnull(DESCONTO,'0') +  
   isnull(PVV,'0')      +  
   replicate(' ',26)                    as COLUNA   
  
 into  
   #temp  

 from  
--   vw_exporta_saida_contmatic c with(nolock)  
   #tempCFOP c with (nolock) 
  
 where   
   cd_nota_saida = @cd_nota_saida_c  

 order by  
   cd_nota_saida  

--  select * from #TempCFOP
--  select * from vw_exporta_saida_contmatic where cd_nota_saida = 579
   
 select   
   cd_nota_saida,  
   rtrim(ltrim(cast(isnull(TIPOREGISTRO,'R2') as char(02)))) +   
   cast( Vago_1 as char(08))                                 + 
   cast( NCM    as char(10))+
-- 
--           replicate(' ',8) +     
--           isnull(replicate('0', 08 - len(cast(isnull(rtrim(ltrim(replace(NCM,'.',''))), '00000000') as varchar(08)))) + cast(isnull(ltrim(rtrim(replace(NCM,'.',''))), '00000000') as varchar(08)),'') +    
-- 
--           '  '+  
--   cast(isnull(rtrim(ltrim(DESCRICAO)), '') as varchar(25)) + isnull(replicate(' ',25 - len(cast(isnull(rtrim(ltrim(DESCRICAO)), ' ') as varchar(25)))),'') +  
   cast(isnull(rtrim(ltrim(DESCRICAO)),'') as char(25))                                                    +
   cast(isnull(dbo.fn_mascara_valor_duas_casas_F(isnull(Base_IPI,0.00)),'') as char(12))               +  
   cast(isnull(dbo.fn_mascara_valor_duas_casas_F(isnull(IPI,0.00)),'') as char(12))                    +  
   cast(isnull(dbo.fn_mascara_valor_duas_casas_F(isnull(Isento_IPI,0.00)),'000000000000') as char(12) )+
   cast(replicate(' ',50) as char(50))                                                    as Coluna  

 into  
   #temp2  
  
 from  
   vw_exporta_saida_contmatic_dipi c with(nolock)  
  
 where   
   cd_nota_saida = @cd_nota_saida_c  
 order by  
   cd_nota_saida  
  
          
        insert into #tabela select * from #temp  
        insert into #tabela select * from #temp2  
  
        drop table #temp  
        drop table #temp2  
        drop table #tempCFOP
  
  fetch next from c_nota_saida into @cd_nota_saida_c  
  
end  
  
close      c_nota_saida  
deallocate c_nota_saida  
  
  
select  
  cd_nota_saida,  
  Coluna,  
  substring(coluna,1,198)   as Parte1,  
  substring(coluna,199,199) as Parte2,  
  substring(coluna,398,199) as Parte3  
into  
  #Cabecalho  
  
from   
  #tabela  
    
    
--------------------------------------------------------------------------------------------------------------------------------  
  
select * from #Cabecalho  
  
drop table #tabela  
drop table #Cabecalho  
drop table #ValoresICMS  
  
