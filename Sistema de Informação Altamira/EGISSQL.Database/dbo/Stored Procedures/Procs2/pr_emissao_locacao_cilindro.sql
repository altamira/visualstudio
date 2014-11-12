
CREATE PROCEDURE pr_emissao_locacao_cilindro

@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- lista Contratos não impressos
-------------------------------------------------------------------------------
  begin

    SELECT     'N' as 'Sel',
	       ns.cd_nota_saida, 
	       ns.dt_nota_saida, 
	       ns.vl_total, 
               d.nm_fantasia, 
	       td.nm_tipo_destinatario
    FROM       Nota_Saida ns INNER JOIN
               vw_destinatario d ON ns.cd_tipo_destinatario = d.cd_tipo_destinatario AND ns.cd_cliente = d.cd_destinatario INNER JOIN
               Tipo_Destinatario td ON ns.cd_tipo_destinatario = td.cd_tipo_destinatario
    where ns.dt_nota_saida between @dt_inicial and @dt_final and
          IsNull(ns.ic_locacao_cilindro_nota,'N') = 'N'
   

  end 

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- lista contratos já impressos ( REEMISSÃO)
-------------------------------------------------------------------------------
  begin
   
    SELECT     'N' as 'Sel',
	       ns.cd_nota_saida, 
	       ns.dt_nota_saida, 
	       ns.vl_total, 
               d.nm_fantasia, 
	       td.nm_tipo_destinatario
    FROM       Nota_Saida ns INNER JOIN
               vw_destinatario d ON ns.cd_tipo_destinatario = d.cd_tipo_destinatario AND ns.cd_cliente = d.cd_destinatario INNER JOIN
               Tipo_Destinatario td ON ns.cd_tipo_destinatario = td.cd_tipo_destinatario
    where ns.dt_nota_saida between @dt_inicial and @dt_final and
          IsNull(ns.ic_locacao_cilindro_nota,'N') = 'E'
   

  end

else  
  return
    
