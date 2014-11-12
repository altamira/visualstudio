
CREATE PROCEDURE pr_rel_cliente_status  
@nm_status_cliente as varchar(50),  
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
    sc.nm_status_cliente,  
    ra.nm_ramo_atividade,  
    fi.nm_fonte_informacao  
      
   from  
    cliente cli  
  
  left outer join  
    status_cliente sc  
  on (cli.cd_status_cliente = sc.cd_status_cliente)  
       
  left outer join  
    Ramo_Atividade ra  
  on (cli.cd_ramo_atividade = ra.cd_ramo_atividade)  
  
  left outer join  
    Fonte_Informacao fi  
  on (cli.cd_fonte_informacao = fi.cd_fonte_informacao)  
  
  where   
  (sc.nm_status_cliente = @nm_status_cliente)
  and cli.cd_vendedor = (Case dbo.fn_vendedor(@cd_usuario) When 0 then cli.cd_vendedor else dbo.fn_vendedor(@cd_usuario) END) 
  order by cli.nm_fantasia_cliente
  
