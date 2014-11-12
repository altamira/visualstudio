
CREATE PROCEDURE pr_rel_cliente_cidade    
@ic_parametro as int,     
@cd_usuario int =0,  
@cd_cidade as varchar(50)    
    
AS    
    
------------------------------------------------------------------------------    
if @ic_parametro = 1  -- Realiza consulta pelo end. principal    
------------------------------------------------------------------------------    
  begin    
    
    select distinct    
      cli.cd_cliente,    
      cli.nm_fantasia_cliente,    
      cli.nm_razao_social_cliente,    
      cli.nm_endereco_cliente,    
      cli.nm_bairro,    
      cli.cd_ddd,    
      cli.cd_telefone,    
      cli.cd_fax,    
      fi.nm_fonte_informacao,    
      ra.nm_ramo_atividade,    
      es.sg_estado,    
      ci.cd_cidade,    
      ci.nm_cidade    
       
    from     
      Cliente cli left outer join     
      Cidade ci on (cli.cd_cidade = ci.cd_cidade) left outer join     
      Estado es on (cli.cd_estado = es.cd_estado) left outer join     
      Ramo_Atividade ra on (cli.cd_ramo_atividade = ra.cd_ramo_atividade) left outer join     
      Fonte_Informacao fi on (cli.cd_fonte_informacao = fi.cd_fonte_informacao)    
    where     
      ((ci.cd_cidade = @cd_cidade) or    
      (@cd_cidade = 0))   and  
      cli.cd_vendedor = (Case dbo.fn_vendedor(@cd_usuario) When 0 then cli.cd_vendedor else dbo.fn_vendedor(@cd_usuario) END)  
    order by    
      ci.nm_cidade,    
      cli.nm_fantasia_cliente    
    
  end    
    
    
------------------------------------------------------------------------------    
else if @ic_parametro = 2  -- Realiza consulta por filtros    
------------------------------------------------------------------------------    
begin    
       
 select     
   *     
 from     
    cidade    
    
end    
    
else    
 return    
    


  
