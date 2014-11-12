
CREATE PROCEDURE pr_consulta_nota_sem_vendedor
@dt_inicial    datetime,
@dt_final      datetime,
@cd_nota_saida int = 0


AS

----------------------
if @cd_nota_saida = 0
----------------------

begin
  SELECT    
    ns.dt_nota_saida, 
--    ns.cd_nota_saida, 

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
            ns.cd_identificacao_nota_saida
          else
            ns.cd_nota_saida                              
    end                   as cd_nota_saida,

    ns.vl_total, 
    op.cd_mascara_operacao + ' - ' + op.nm_operacao_fiscal as 'CFOP', 
    td.nm_tipo_destinatario,     
    vw.nm_fantasia as nm_fantasia_destinatario    
  FROM  
    Nota_Saida ns               with (nolock) 
  INNER JOIN Operacao_Fiscal op ON 
    ns.cd_operacao_fiscal = op.cd_operacao_fiscal
  left outer join vw_Destinatario vw on
    vw.cd_destinatario=ns.cd_cliente and vw.cd_tipo_destinatario=ns.cd_tipo_destinatario
  left outer join Tipo_Destinatario td on
    td.cd_tipo_destinatario=ns.cd_tipo_destinatario
  WHERE
    ns.dt_nota_Saida between @dt_inicial and @dt_final and
    ns.dt_cancel_nota_saida is null and
    op.ic_comercial_operacao = 'S' and
    IsNull(ns.cd_vendedor,0) = 0
end

else

begin
  SELECT    
    ns.dt_nota_saida, 
    ns.cd_nota_saida, 
    ns.vl_total, 
    op.cd_mascara_operacao + ' - ' + op.nm_operacao_fiscal as 'CFOP', 
    td.nm_tipo_destinatario,     
    vw.nm_fantasia as nm_fantasia_destinatario    
  FROM  
    Nota_Saida ns 
  INNER JOIN Operacao_Fiscal op ON 
    ns.cd_operacao_fiscal = op.cd_operacao_fiscal
  left outer join vw_Destinatario vw on
    vw.cd_destinatario=ns.cd_cliente and vw.cd_tipo_destinatario=ns.cd_tipo_destinatario
  left outer join Tipo_Destinatario td on
    td.cd_tipo_destinatario=ns.cd_tipo_destinatario
  WHERE
    ns.cd_nota_saida = @cd_nota_saida and
    ns.dt_cancel_nota_saida is null   and
    op.ic_comercial_operacao = 'S'    and
    IsNull(ns.cd_vendedor,0) = 0
end

