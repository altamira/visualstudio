
CREATE PROCEDURE pr_rel_cliente_regiao
@nm_regiao as varchar(50)

AS

--******************************************************************************************

   select
    cli.cd_cliente,
    cli.nm_fantasia_cliente,
    cli.nm_razao_social_cliente,
    cli.cd_ddd,
    cli.cd_telefone,
    cli.cd_fax,
    re.cd_regiao,
    re.nm_regiao,
    ra.nm_ramo_atividade,
    ci.nm_cidade,
    es.sg_estado
  
    
   from
    cliente cli

  left outer join
    regiao re
  on (cli.cd_regiao = re.cd_regiao)
 
  left outer join
    Ramo_Atividade ra
  on (cli.cd_ramo_atividade = ra.cd_ramo_atividade)

  left outer join
    cidade ci
  on (cli.cd_cidade = ci.cd_cidade)

  left outer join
    estado es
  on (cli.cd_estado = es.cd_estado)

  where 
  (re.nm_regiao = @nm_regiao)

