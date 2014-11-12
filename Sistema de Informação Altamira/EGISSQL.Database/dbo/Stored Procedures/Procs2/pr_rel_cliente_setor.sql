

CREATE PROCEDURE pr_rel_cliente_setor  
@nm_setor as varchar(50),
@cd_usuario int = 0
  
AS  
  
--******************************************************************************************  
  
   select  
    cli.cd_cliente,  
    cli.nm_fantasia_cliente,  
    cli.nm_razao_social_cliente,  
    cli.cd_ddd,  
    cli.cd_telefone,  
    cli.cd_fax,  
    ra.nm_ramo_atividade,  
    ci.nm_cidade,  
    es.sg_estado,  
    setor.nm_setor_cliente  
      
   from  
    cliente_contato cc  
  
     
  left outer join  
    cliente cli  
  on (cc.cd_cliente = cli.cd_cliente)  
  
  left outer join   
    setor_cliente setor  
  on (cc.cd_setor_cliente = setor.cd_setor_cliente)  
     
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
  (setor.nm_setor_cliente = @nm_setor)  
  and cli.cd_vendedor = (Case dbo.fn_vendedor(@cd_usuario) When 0 then cli.cd_vendedor else dbo.fn_vendedor(@cd_usuario) END) 
  

  
