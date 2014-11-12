
-------------------------------------------------------------------------------
--pr_migracao_Sulzer_Ciap
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 04.11.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_Sulzer_Ciap
as

--select * from sulzer.dbo.ciap

delete from ciap_demonstrativo
delete from ciap_composicao
delete from ciap

select
  identity(int,1,1)                      as cd_ciap,
  isnull(cast([Data Entrada] as datetime),getdate())       as dt_ciap,
  48                                     as qt_mes_ciap,
  [Valor do Imposto]                     as vl_icms_ciap,
  ( select top 1 x.cd_fornecedor
    from
     Fornecedor x
    where
      x.nm_razao_social = c.Fornecedor ) as cd_fornecedor,
  null                                   as cd_operacao_fiscal,
  --cast([Nota Fiscal] as int )            as cd_nota_entrada,
  null                                   as cd_nota_entrada,
  null                                   as cd_serie_nota_fiscal,
  null                                   as cd_nota_entrada_manual,
  null                                   as cd_serie_entrada_manual,
  99                                     as cd_usuario,
  getdate()                              as dt_usuario,
  null                                   as dt_baixa_ciap,

  --Busca o Código do Bem 

  ( select top 1 y.cd_bem
    from
      bem y
    where
      y.cd_patrimonio_bem 
      like '%'+rtrim(cast(c.Patrimonio as varchar))+'%' )        as cd_bem,

  c.fator                                as pc_fator_bem_ciap,
  cast([Nota Fiscal] as varchar(60))     as nm_obs_ciap,
  null                                   as cd_livro_entrada,
  null                                   as cd_livro_saida,
  null                                   as dt_entrada_nota_ciap,
  null                                   as qt_folha_livro_entrada,
  null                                   as qt_folha_livro_saida,
  null                                   as vl_estorno_ciap
  
into
  #Ciap
from
  sulzer.dbo.ciap c
where
  c.Patrimonio is not null
order by
  c.Patrimonio 

insert into
  Ciap
select
  *
from
  #Ciap

drop table #Ciap

select * from Ciap

--Geração do CIAP Demonstrativo

-- select
--   *
-- into
--   #CiapAux  
-- from
--   Ciap
-- 
-- 
-- declare @cd_ciap  int
-- declare @qt_mes   int
-- declare @vl_icms  decimal(25,2)
-- declare @dt_ciap  datetime
-- declare @pc_fator float
-- 
-- while exists ( select top 1 cd_ciap from #CiapAux )
-- begin
-- 
--   select top 1
--     @cd_ciap  = cd_ciap,
--     @qt_mes   = isnull(qt_mes_ciap,0),
--     @vl_icms  = isnull(vl_icms_ciap,0), 
--     @dt_ciap  = dt_ciap,
--     @pc_fator = isnull(pc_fator_bem_ciap,0)
--   from
--     #CiapAux
-- 
--   declare @qt_parcela int
--   set @qt_parcela = 1  
-- 
--   while @qt_parcela <= @qt_mes
--   begin
-- 
--     insert into
--       Ciap_Demonstrativo
--     select
--       @cd_ciap,
--       @qt_parcela,
--       cast(month(@dt_ciap)+@qt_parcela as int),
--       null,
--       1/@qt_mes,
--       isnull(@vl_icms,0)*(1/@qt_mes)*(case when (@pc_fator/100)>0 then (@pc_fator/100) else 1 end),
--       99,
--       getdate()
-- 
--     set @qt_parcela = @qt_parcela +1
--             
--   end
-- 
--   delete from #CiapAux where cd_ciap = @cd_ciap
-- 
-- end 


--select * from Ciap_Demonstrativo

