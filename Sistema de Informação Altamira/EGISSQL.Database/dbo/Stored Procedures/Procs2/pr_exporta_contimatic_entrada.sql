
-------------------------------------------------------------------------------
--sp_helptext pr_exporta_contimatic_entrada
-------------------------------------------------------------------------------
--pr_exporta_contimatic_entrada
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 02.06.2009
--Alteração        : 16.06.2009 - Arredondamento - Carlos Fernandes
--                   24.06.2009 - Desenvolvimento - Carlos Fernandes
-- 20.07.2009 - Ajustes Diversos - Carlos Fernads
-- 20.08.2009 - Verificação das Notas de Importação - Carlos Fernandes
-- 16.10.2009 - Ajuste de campos - Carlos Fernandes
-- 23.10.2009 - Ajuste de Notas iguais Entrada/Saída - Carlos Fernandes
-- 26.10.2009 
-- 05.11.2009 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_exporta_contimatic_entrada
  @dt_inicial      datetime,
  @dt_final        datetime,
  @cd_nota_entrada int = 0

as

--Montagem da Tabela Auxiliar com Nota de Entrada/Saída --> Entrada de Importação

select 
 ns.cd_nota_saida      as cd_nota_entrada,
 ns.cd_cliente         as cd_fornecedor,
 ns.cd_operacao_fiscal as cd_operacao_fiscal,
 ns.cd_serie_nota      as cd_serie_nota_fiscal,
 ns.dt_nota_saida      as dt_entrada,
 'S'                   as ic_tipo_nota
into
  #NotaEntrada

from
  nota_saida ns                             with (nolock) 
  left outer join Operacao_fiscal op        with (nolock) on op.cd_operacao_fiscal        = ns.cd_operacao_fiscal
  left outer join Grupo_Operacao_Fiscal gop with (nolock) on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal

where 
  dt_nota_saida between @dt_inicial and @dt_final and
  --dt_cancel_nota_saida is null and
  cd_nota_saida = case when isnull(@cd_nota_entrada,0) = 0 then cd_nota_saida else  @cd_nota_entrada end and
  isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
  gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS

union all

  select 
    ne.cd_nota_entrada       as cd_nota_entrada,
    ne.cd_fornecedor         as cd_fornecedor,
    ne.cd_operacao_fiscal    as cd_operacao_fiscal,
    ne.cd_serie_nota_fiscal  as cd_serie_nota_fiscal,
    ne.dt_receb_nota_entrada as dt_entrada,
    'E'                      as ic_tipo_nota

  from
    nota_entrada ne                           with (nolock) 
    left outer join Operacao_fiscal op        with (nolock) on op.cd_operacao_fiscal        = ne.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gop with (nolock) on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal

  where 
     ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and  
     ne.cd_nota_entrada = case when isnull(@cd_nota_entrada,0) = 0 then ne.cd_nota_entrada else  @cd_nota_entrada end and
     isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
     gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS


--select * from #NotaEntrada

declare c_nota_entrada cursor for -- select * from nota_saida_item

select 
  cd_nota_entrada,
  cd_fornecedor
from
  #NotaEntrada with(nolock) 
where 
  dt_entrada between @dt_inicial and @dt_final 
 
order by
  cd_nota_entrada

open c_nota_entrada

declare @cd_nota_entrada_c int
declare @cd_fornecedor     int

set     @cd_nota_entrada_c = 0
set     @cd_fornecedor     = 0

declare @cd_item int
set     @cd_item = 0

create table #Tabela (cd_nota_entrada int, cd_fornecedor int, dt_receb_nota_entrada datetime, Coluna varchar(8000))
create table #ValoresICMS (cd_nota_entrada int, 
                           cd_item_icms int, 
                           vl_base_icms_item float, 
                           pc_icms_item float, 
                           vl_icms_item float, 
                           vl_icms_isento_item float, 
                           vl_icms_outros_item float,
                           vl_ipi              float,
                           vl_desp_acess_item  float,
                           cd_fornecedor       int)
 
fetch next from c_nota_entrada into @cd_nota_entrada_c,@cd_fornecedor

while (@@fetch_status <> -1) 
begin

  -----------------------------------------------------------------------------------------
  --Tabela temporária com as alíquotas do ICMS
  -----------------------------------------------------------------------------------------
  --select * from nota_saida_item where cd_nota_saida = 50696
  --select * from nota_saida

  select
    @cd_nota_entrada_c                                as cd_nota_entrada,  
    identity(smallint,1,1)                            as cd_item_icms,

--    max(n.vl_bc_icms)                                 as vl_base_icms_item,


    sum(round(isnull(ns.vl_base_icms_item,0.00),2))   as vl_base_icms_item,


--     sum(round(isnull(    
--     case when isnull(n.cd_destinacao_produto,0)=2
--     then
--       ns.vl_total_item + ns.vl_ipi + ns.vl_desp_acess_item
--     else
--       ns.vl_base_icms_item
--     end,0.00),2))   as vl_base_icms_item,

    isnull(ns.pc_icms,0.00)                           as pc_icms_item,

     sum(round(isnull(ns.vl_icms_item,0.00),2))       as vl_icms_item,

--    max(n.vl_icms)                                    as vl_icms_item,

--     sum(round(isnull(
--     case when isnull(n.cd_destinacao_produto,0)=2
--     then
--       (ns.vl_total_item + ns.vl_ipi + ns.vl_desp_acess_item) * (ns.pc_icms/100)
--     else
--       ns.vl_icms_item
--     end,0.00),2))
--                                                       as vl_icms_item,

    sum(round(isnull(ns.vl_icms_isento_item,0.00),2)) as vl_icms_isento_item,
    sum(round(isnull(ns.vl_icms_outros_item,0.00),2)) as vl_icms_outros_item,
    sum(round(isnull(ns.vl_ipi,0.00),2))              as vl_ipi,
    sum(round(isnull(ns.vl_desp_acess_item,0.00),2))  as vl_desp_acess_item,
    max(n.cd_cliente)                                 as cd_fornecedor 

  into
    #fff

  from 
    nota_saida_item ns            with (nolock)
    left outer join nota_saida n  with (nolock) on n.cd_nota_saida   = ns.cd_nota_saida
    inner join #NotaEntrada e     with (nolock) on e.cd_nota_entrada = n.cd_nota_saida
  
  where
    ns.cd_nota_saida = @cd_nota_entrada_c and 
    e.dt_entrada between @dt_inicial and @dt_final and
    isnull(ns.pc_icms,0.00) > 0.00      and
    n.cd_cliente   = e.cd_fornecedor  and
    e.ic_tipo_nota = 'S' --Saída

  group by
    isnull(ns.pc_icms,0.00)

  order by
    4 desc

--  union all
    --Entrada
    --select * from nota_entrada_item

  select
    @cd_nota_entrada_c                                     as cd_nota_entrada,  
    identity(smallint,1,1)                                 as cd_item_icms,
    sum(round(isnull(ner.vl_bicms_reg_nota_entrada,0.00),2))    as vl_base_icms_item,
    isnull(ner.pc_icms_reg_nota_entrada,0.00)                   as pc_icms_item,
    sum(round(isnull(ner.vl_icms_reg_nota_entrada,0.00),2))     as vl_icms_item,
    sum(round(isnull(ner.vl_icmsisen_reg_nota_entr,0.00),2)) as vl_icms_isento_item,
    sum(round(isnull(ner.vl_icmsoutr_reg_nota_entr,0.00),2))   as vl_icms_outros_item, 
    sum(round(isnull(0,0.00),2))                           as vl_ipi,
    sum(round(isnull(0,0.00),2))                           as vl_desp_acess_item, 
    max(ne.cd_fornecedor)                                  as cd_fornecedor 

  into
    #ffe

  from 
    nota_entrada_item ni            with (nolock)
    left outer join nota_entrada ne with (nolock) on ne.cd_nota_entrada      = ni.cd_nota_entrada    and
                                                     ne.cd_fornecedor        = ni.cd_fornecedor      and
                                                     ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
                                                     ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal

    inner join #NotaEntrada e      with (nolock) on e.cd_nota_entrada      = ni.cd_nota_entrada    and
                                                    e.cd_fornecedor        = ni.cd_fornecedor      and
                                                    e.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
                                                    e.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal

    inner join nota_entrada_item_registro ner with (nolock) on ner.cd_nota_entrada      = ni.cd_nota_entrada      and
                                                               ner.cd_fornecedor        = ni.cd_fornecedor        and
                                                               ner.cd_operacao_fiscal   = ni.cd_operacao_fiscal   and
                                                               ner.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal and
                                                               ner.cd_item_nota_entrada = ni.cd_item_nota_entrada

  where
    ni.cd_nota_entrada = @cd_nota_entrada_c and 
    e.dt_entrada between @dt_inicial and @dt_final   and
    --isnull(ni.pc_icms_nota_entrada,0.00) > 0.00      and
    e.cd_fornecedor  = ne.cd_fornecedor              and
    e.ic_tipo_nota = 'E'                             --Entrada

  group by
    isnull(ner.pc_icms_reg_nota_entrada,0.00)

  order by
    4 desc

  --select * from nota_entrada_item_registro where cd_nota_entrada = 574

--  select * from #fff

  insert into #ValoresICMS
    select * from #fff

  insert into #ValoresICMS
    select * from #ffe

--select * from #fff
--select * from #ffe

  drop table #fff
  drop table #ffe

  fetch next from c_nota_entrada into @cd_nota_entrada_c,@cd_fornecedor

end


close      c_nota_entrada
deallocate c_nota_entrada

--select * from #ValoresICMS order by cd_nota_saida, pc_icms_item
--Mostra a Tabela temporária

--select * from #ValoresICMS order by cd_fornecedor, cd_nota_entrada

--------------------------------------------------------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------------
--print 'pp'

declare x_nota_entrada cursor for -- select * from nota_saida_item

select 
  cd_nota_entrada,
  cd_fornecedor

from
  #NotaEntrada with(nolock) 

where 
  dt_entrada between @dt_inicial and @dt_final 
 
order by
  cd_nota_entrada

open x_nota_entrada
 
fetch next from x_nota_entrada into @cd_nota_entrada_c,@cd_fornecedor


while (@@fetch_status <> -1) 
begin
        --select * from vw_exporta_entrada_contmatic

	select
	  cd_nota_entrada,
          cd_fornecedor,
          dt_receb_nota_entrada,
          cast(
	  isnull(cast(TIPOREGISTRO  as varchar(02)),'') +
	  isnull(cast(DDMMNF        as varchar(04)),'') +
	  isnull(cast(DDMMESNF      as varchar(04)),'') +
	  isnull(cast(DIAINTEGRACAO as varchar(02)),'') +
	  isnull(cast(ESPECIE       as char(03)),'') +
	  isnull(cast(SERIE         as char(03)),'000') +
	  isnull(replicate('0',6 - len(Rtrim(ltrim(cast(NUM_NOTA_INICIAL as varchar(6))))))+ cast(Rtrim(ltrim(cast(NUM_NOTA_INICIAL as varchar(6)))) as varchar(6)),'') +
	  isnull(replicate('0',6 - len(Rtrim(ltrim(cast(NUM_NOTA_FINAL as varchar(6))))))  + cast(Rtrim(ltrim(cast(NUM_NOTA_FINAL as varchar(6))))   as varchar(6)),'') +
	  case when isnull(rtrim(ltrim(cast(NATUREZA as varchar(05)))),'1.102') = '' then
	    '1.102'
	  else
	     isnull(rtrim(ltrim(cast(NATUREZA as varchar(05)))),'1.102') 
	  end +

	  isnull(dbo.fn_mascara_valor_duas_casas_F(VALOR_CONTABIL),'') +

	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item    from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 1),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item         from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 1),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item         from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 1),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item  from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 1),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item  from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 1),0.00)),'') +

	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 2),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 2),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 2),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 2),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 2),0.00)),'') +

	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 3),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 3),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 3),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 3),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 3),0.00)),'') +

	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 4),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 4),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 4),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 4),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 4),0.00)),'') +

	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_base_icms_item   from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 5),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_FF(isnull((select top 1 pc_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 5),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_item        from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 5),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_isento_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 5),0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull((select top 1 vl_icms_outros_item from #ValoresICMS where cd_nota_entrada = c.cd_nota_entrada and cd_fornecedor = c.cd_fornecedor and cd_item_icms = 5),0.00)),'') +

	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(BASE_IPI,0.00)),'')       +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(IPI,0.00)),'')            +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(ISENTAS_IPI,0.00)),'')    +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(OUTRAS_IPI,0.00)),'')     +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(IPI_NAO_APRO,0.00)),'')   +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(ICMS_FONTE,0.00)),'')     +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(DESCONTONF,0.00)),'')     +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(VLRVISTA,0.00)),'')       +
	  isnull(dbo.fn_mascara_valor_duas_casas_F (isnull(VLRPRAZO,0.00)),'')       + 
	  isnull(dbo.fn_mascara_valor_duas_casas_F (ISENTO_PIS),'')                  +
	  isnull(cast(isnull(CONTRIBUINTE,0) as varchar(1)),'0')                     +
	  isnull(cast(isnull(TIPONOTA,'00')  as varchar(2)),'00')                    +
	  --isnull(replicate('0',2 - len(cast(isnull(COD_CONTAB, '0') as varchar(2)))) + cast(isnull(COD_CONTAB, '0') as varchar(2)),'0') +
	  --isnull(replicate(' ',14 - len(cast(isnull(OBSLIVRE, '') as varchar(14)))) + cast(isnull(OBSLIVRE, '' )    as varchar(14)),'') +
          COD_CONTAB + 
          OBSLIVRE  + 
	  cast(dbo.fn_limpa_mascara_cnpj_J(CGC_CPF) as char(14)) +    
	  cast(dbo.fn_mascara_ie_F(INSCESTADUAL)    as char(16)) +
          cast(ltrim(rtrim(isnull(RAZAO,'')))       as char(35)) +
          cast(ltrim(rtrim(isnull(CTACTBL,'')))     as char(18)) + 
	  --isnull(replicate(' ', 35 - len(cast(isnull(RAZAO, '') as varchar(35)))) + cast(isnull(RAZAO, '') as varchar(35)),'') +
	  --isnull(replicate(' ', 18 - len(cast(isnull(CTACTBL, '') as varchar(18)))) + cast(isnull(CTACTBL, '') as varchar(18)),'') +
	  isnull(cast(UF as varchar(2)),'SP') +
	  --isnull(replicate('0', 4 - len(rtrim(ltrim(cast(isnull(NUNMUNICP, '') as varchar(4)))))) + cast(isnull(NUNMUNICP, '') as varchar(4)),'') +
          NUNMUNICP + 
          isnull(dbo.fn_mascara_valor_duas_casas_F (DESCONTO),'0') +
          isnull(dbo.fn_mascara_valor_duas_casas_F (PVV),'0')      +
	  --isnull(DESCONTO,'0') +
	  --isnull(PVV,'0') +
	  replicate(' ',26) as char(595))                    as COLUNA 

	into
	  #temp

	from
	  vw_exporta_entrada_contmatic c with(nolock)

	where 
	  cd_nota_entrada = @cd_nota_entrada_c and
          cd_fornecedor   = @cd_fornecedor     and
          dt_receb_nota_entrada between @dt_inicial and @dt_final 


	order by
	  cd_nota_entrada

	select 
	  cd_nota_entrada,
          cd_fornecedor,
          dt_receb_nota_entrada,
	  rtrim(ltrim(cast(isnull(TIPOREGISTRO,'R2') as char(02)))) + 
          vago_1           +
          NCM +
-- 	  replicate(' ',8) + 
-- 	  isnull(replicate('0', 10 - len(cast(isnull(rtrim(ltrim(replace(NCM,'.',''))), '0000000000') as varchar(10)))) + cast(isnull(ltrim(rtrim(replace(NCM,'.',''))), '0000000000') as varchar(10)),'') +
	  cast(isnull(rtrim(ltrim(DESCRICAO)), '') as varchar(25)) + isnull(replicate(' ',25 - len(cast(isnull(rtrim(ltrim(DESCRICAO)), ' ') as varchar(25)))),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F(isnull(Base_IPI,0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F(isnull(IPI,0.00)),'') +
	  isnull(dbo.fn_mascara_valor_duas_casas_F(isnull(Isento_IPI,0.00)),'000000000000') + replicate(' ',50) as Coluna

	into
	  #temp2

	from
	  vw_exporta_entrada_contmatic_dipi c with(nolock)

	where 
	  cd_nota_entrada = @cd_nota_entrada_c and
          cd_fornecedor   = @cd_fornecedor     and
          dt_receb_nota_entrada between @dt_inicial and @dt_final 

	order by
	  cd_nota_entrada

        
        insert into #tabela select * from #temp
        insert into #tabela select * from #temp2

        drop table #temp
        drop table #temp2

  fetch next from x_nota_entrada into @cd_nota_entrada_c,@cd_fornecedor

end

close      x_nota_entrada
deallocate x_nota_entrada


select
  cd_nota_entrada,
  cd_fornecedor,
  dt_receb_nota_entrada,
  Coluna,
  substring(coluna,1,198)   as Parte1,
  substring(coluna,199,199) as Parte2,
  substring(coluna,398,199) as Parte3

into
  #Cabecalho

from 
  #tabela

--order by
--  dt_receb_nota_entrada 

 
--------------------------------------------------------------------------------------------------------------------------------

select * from #Cabecalho

drop table #tabela
drop table #Cabecalho
drop table #ValoresICMS

