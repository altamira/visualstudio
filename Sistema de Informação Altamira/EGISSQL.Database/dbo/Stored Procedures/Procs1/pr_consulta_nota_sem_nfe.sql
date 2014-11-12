
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_nota_sem_nfe
-------------------------------------------------------------------------------
--pr_consulta_nota_sem_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : David Becker
--Banco de Dados   : Egissql
--Objetivo         : Consulta / Relatório por Forma de Pagamento
--Data             : 01.09.2009
--Alteração        : 
--
--
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_nota_sem_nfe

  @ic_parametro       int = 0,
  @cd_nota_consulta   int = 0,
 -- @ic_tipo_nota       varchar(10),
  @dt_inicial         datetime,
  @dt_final           datetime

as

--traz todos os registros
if @ic_parametro = 0
begin
	Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_entrada,
    dt_nota_entrada,
    nm_fantasia_destinatario,
    opf.cd_operacao_fiscal,
    opf.cd_mascara_operacao,
	  ic_nfe_nota_entrada,
    vl_total_nota_entrada    
	 From  nota_entrada ne 
      left outer join operacao_fiscal opf       (nolock) on opf.cd_operacao_fiscal       = ne.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

     where isnull (ic_nfe_nota_entrada, 'N')='N' and 
--         nm_tipo_operacao_fiscal = @ic_tipo_nota and 
           dt_nota_entrada BETWEEN @dt_inicial AND @dt_final 

	UNION
  Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    case when isnull(cd_identificacao_nota_saida,0)<>0 then cd_identificacao_nota_saida else cd_nota_saida end cd_nota_saida,
    dt_nota_saida,
    nm_fantasia_destinatario, 
    opf.cd_operacao_fiscal, 
    opf.cd_mascara_operacao,
	  ic_nfe_nota_saida, 
    vl_total
  From nota_saida ns 
      left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

  where
    isnull (ic_nfe_nota_saida, 'N')='N' and 
--  nm_tipo_operacao_fiscal = @ic_tipo_nota and 
--    nm_tipo_operacao_fiscal = case when @ic_tipo_nota = 0 then @ic_tipo_nota
--                            else @ic_tipo_nota end and

    dt_nota_saida BETWEEN @dt_inicial AND @dt_final

order by cd_nota_entrada

end

-- Traz apenas o registro selecionado
if @ic_parametro = 1
begin
	Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_entrada,
    dt_nota_entrada,
    nm_fantasia_destinatario,
	  opf.cd_operacao_fiscal,
    opf.cd_mascara_operacao,
    ic_nfe_nota_entrada,
    vl_total_nota_entrada    
	 From  nota_entrada ne
      left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

   where ic_nfe_nota_entrada = 'N' and 
         cd_nota_saida = @cd_nota_consulta 
--         nm_tipo_operacao_fiscal = @ic_tipo_nota
	UNION
  Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_saida, 
    dt_nota_saida,
    nm_fantasia_destinatario, 
    opf.cd_operacao_fiscal, 
    opf.cd_mascara_operacao,
	  ic_nfe_nota_saida, 
    vl_total
  From nota_saida ns 
    left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
    left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

  where
    ic_nfe_nota_saida = 'N' and
--    nm_tipo_operacao_fiscal = case when @ic_tipo_nota = 0 then @ic_tipo_nota
  --                          else @ic_tipo_nota end and
    cd_nota_saida = case when @cd_nota_consulta = 0 then cd_nota_saida                
                              else @cd_nota_consulta end 
--order by cd_nota_saida

end

if @ic_parametro = 2
begin
	Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_entrada,
    dt_nota_entrada,
    nm_fantasia_destinatario,
    opf.cd_operacao_fiscal,
    opf.cd_mascara_operacao,
	  ic_nfe_nota_entrada,
    vl_total_nota_entrada    
	 From  nota_entrada ne 
      left outer join operacao_fiscal opf       (nolock) on opf.cd_operacao_fiscal       = ne.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

     where isnull (ic_nfe_nota_entrada, 'N')='N' and 
         nm_tipo_operacao_fiscal = 'entrada' and
         dt_nota_entrada BETWEEN @dt_inicial and @dt_final 


	UNION
  Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_saida, 
    dt_nota_saida,
    nm_fantasia_destinatario, 
    opf.cd_operacao_fiscal, 
    opf.cd_mascara_operacao,
	  ic_nfe_nota_saida, 
    vl_total
  From nota_saida ns 
      left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

  where
    isnull (ic_nfe_nota_saida, 'N')='N' and 
         nm_tipo_operacao_fiscal = 'entrada' and
         dt_nota_saida BETWEEN @dt_inicial and @dt_final and
         cd_nota_saida = case when @cd_nota_consulta = 0 then cd_nota_saida                
                               else @cd_nota_consulta end 
end


if @ic_parametro = 3
begin
	Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_entrada,
    dt_nota_entrada,
    nm_fantasia_destinatario,
    opf.cd_operacao_fiscal,
    opf.cd_mascara_operacao,
	  ic_nfe_nota_entrada,
    vl_total_nota_entrada    
	 From  nota_entrada ne 
      left outer join operacao_fiscal opf       (nolock) on opf.cd_operacao_fiscal       = ne.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

     where isnull (ic_nfe_nota_entrada, 'N')='N' and 
         nm_tipo_operacao_fiscal = 'saida' and
         dt_nota_entrada BETWEEN @dt_inicial and @dt_final 

	UNION
  Select 
    tof.nm_tipo_operacao_fiscal,
    gop.nm_grupo_operacao_fiscal, 
    opf.nm_operacao_fiscal,
    cd_nota_saida, 
    dt_nota_saida,
    nm_fantasia_destinatario, 
    opf.cd_operacao_fiscal, 
    opf.cd_mascara_operacao,
	  ic_nfe_nota_saida, 
    vl_total
  From nota_saida ns 
      left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
      left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
      left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal

  where
    isnull (ic_nfe_nota_saida, 'N')='N' and 
           nm_tipo_operacao_fiscal = 'saida' and
           dt_nota_saida BETWEEN @dt_inicial and @dt_final and
           cd_nota_saida = case when @cd_nota_consulta = 0 then cd_nota_saida                
                                else @cd_nota_consulta end 


end




-- if @ic_parametro = 2
-- begin
-- 	Select 
--     tof.nm_tipo_operacao_fiscal,
--     gop.nm_grupo_operacao_fiscal, 
--     opf.nm_operacao_fiscal,
--     cd_nota_entrada,
--     dt_nota_entrada,
--     nm_fantasia_destinatario,
-- 	  opf.cd_operacao_fiscal,
--     opf.cd_mascara_operacao,
--     ic_nfe_nota_entrada,
--     vl_total_nota_entrada    
-- 	 From  nota_entrada ne
--       left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
--       left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
--       left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal
-- 
--    where ic_nfe_nota_entrada is null and
--          nm_tipo_operacao_fiscal = 'saida'
-- 
-- 	UNION
--   Select 
--     tof.nm_tipo_operacao_fiscal,
--     gop.nm_grupo_operacao_fiscal, 
--     opf.nm_operacao_fiscal,
--     cd_nota_saida, 
--     dt_nota_saida,
--     nm_fantasia_destinatario, 
--     opf.cd_operacao_fiscal, 
--     opf.cd_mascara_operacao,
-- 	  ic_nfe_nota_saida, 
--     vl_total
--   From nota_saida ns 
--     left outer join operacao_fiscal opf(nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
--     left outer join grupo_operacao_fiscal gop (nolock) on gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
--     left outer join tipo_operacao_fiscal tof  (nolock) on tof.cd_tipo_operacao_fiscal  = gop.cd_tipo_operacao_fiscal
-- 
--   where
--     ic_nfe_nota_saida = 'N' and
--     nm_tipo_operacao_fiscal ='saida'
-- --order by cd_nota_saida

------------------------------------------------------------------------------
--Testando a Stored Procedure
------------------------------------------------------------------------------
-- exec dbo.pr_consulta_nota_sem_nfe @ic_tipo_nota = 'saida', @cd_nota_consulta = 500857, @ic_parametro = 0, @dt_inicial = '2009/01/01', @dt_final = '2009/09/03'
------------------------------------------------------------------------------

-- exec dbo.pr_consulta_nota_sem_nfe @ic_tipo_nota = 'saida', @cd_nota_consulta = 500857, @ic_parametro = 0, @dt_inicial = '2009/01/01', @dt_final = '2009/09/30', @ic_tipo = 0

-- Tabelas usadas
--  select * from nota_entrada where cd_nota_saida= 10
--  select * from nota_saida where cd_nota_saida= 500871
--  select * from nota_saida_recibo
--  select * from tipo_operacao_fiscal
-- select * from grupo_operacao_fiscal
------------------------------------------------------------------------------

--Exemplo:
--Mostra as NFe sem protocolos
-- select
--  dt_autorizacao_nota,
--  cd_protocolo_nfe,
--  cd_recibo_nfe_nota_saida, 
--  ns.dt_nota_saida, 
--  nsr.*
-- from 
--   nota_saida ns with (nolock)
--   inner join nota_saida_recibo nsr with (nolock) on nsr.cd_nota_saida = ns.cd_nota_saida
-- where nsr.cd_protocolo_nfe < '0' or nsr.cd_protocolo_nfe is null 
-- and ns.dt_nota_saida between '08/01/2009' and '12/31/2009'
-- order by ns.cd_nota_saida

-- exec dbo.pr_consulta_nota_sem_nfe  @ic_parametro = 0, @dt_inicial = '2009/01/01', @dt_final = '2009/09/30', @ic_tipo_nota ='saida'
-- exec dbo.pr_consulta_nota_sem_nfe  @cd_nota_consulta = 500853, @ic_parametro = 3, @dt_inicial = '2009/01/01', @dt_final = '2009/09/30'
