
create procedure pr_consulta_data_emissao_nota
------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de Nota de Saida para alterar a data
--                        de emissão da Nota Fiscal
--Data			: 13/01/2003
--Desc. Alteração	: 
-- 28.10.2010 - Ajuste do Número da Nota / Identificação Fiscal - Carlos Fernandes                      
---------------------------------------------------------------------------------
@cd_nota_saida integer,
@dt_inicial    datetime,
@dt_final      datetime
as

--Por Nota Fiscal----------------------------------------------------------------------------------

if @cd_nota_saida > 0 
begin
  select 
    sn.sg_status_nota,
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,
    ns.dt_nota_saida,
    tp.nm_tipo_destinatario,
    ns.nm_fantasia_destinatario as nm_fantasia_nota_saida, 
    ns.vl_total,
    ns.cd_mascara_operacao  
  from
    Nota_Saida ns, Tipo_Destinatario tp, Status_Nota sn
  where
    ns.cd_nota_saida        = @cd_nota_saida and
    ns.cd_tipo_destinatario = tp.cd_tipo_destinatario and
    ns.cd_status_nota       = sn.cd_status_nota   

end
else
begin

if @cd_nota_saida=0 
begin
  select 
    sn.sg_status_nota,
    ns.cd_nota_saida,
    ns.cd_identificacao_nota_saida,
    ns.dt_nota_saida,
    tp.nm_tipo_destinatario,
    ns.nm_fantasia_destinatario as nm_fantasia_nota_saida,
    ns.nm_fantasia_nota_saida,
    ns.vl_total,
    ns.cd_mascara_operacao  
  from
    Nota_Saida ns, Tipo_Destinatario tp, Status_Nota sn
  where
    ns.dt_nota_saida between @dt_inicial and @dt_final and 
    ns.cd_tipo_destinatario = tp.cd_tipo_destinatario  and
    ns.cd_status_nota       = sn.cd_status_nota   
end


end

