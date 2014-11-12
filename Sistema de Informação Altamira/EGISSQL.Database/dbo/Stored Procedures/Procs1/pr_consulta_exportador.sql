

CREATE  PROCEDURE pr_consulta_exportador

@ic_parametro integer,  
@nm_fantasia_exportador varchar(15),  
@ic_tipo_consulta char(5) = 'F'  

AS  
-------------------------------------------------------------------------------------------  
  if @ic_parametro = 1 --Consulta Todos Exportadores  
-------------------------------------------------------------------------------------------  
  begin   
    Select  
      ex.cd_exportador,  
      ex.nm_fantasia,  
      ex.nm_razao_social,
			ex.cd_pais,
      p.nm_pais,
			--tp.nm_tipo_pessoa,
			ex.cd_ddd,
      ex.cd_telefone,
      ex.cd_siscomex--,
--			cast(ex.ds_exportador as varchar(1500)) as ds_exportador
    from  
      Exportador ex  
      Left Join Tipo_Pessoa tp   
        On ex.cd_tipo_pessoa = tp.cd_tipo_pessoa  
      Left outer join pais p  
        on ex.cd_pais = p.cd_pais  

    order by ex.nm_fantasia
  end  
-------------------------------------------------------------------------------------------  
  else if @ic_parametro = 2 --Consulta Somente Exportador que começa com o nome fantasia informado  
-------------------------------------------------------------------------------------------  
  begin  
    Select distinct 
      ex.cd_exportador,  
      ex.nm_fantasia,  
      ex.nm_razao_social,
			ex.cd_pais,
      p.nm_pais,
			--tp.nm_tipo_pessoa,
      ex.cd_ddd,
			ex.cd_telefone,
      ex.cd_siscomex--,
			--cast(ex.ds_exportador as varchar(1500)) as ds_exportador
    into
      #Exportador
    from  
      Exportador ex  
      Left Join Tipo_Pessoa tp   
        On ex.cd_tipo_pessoa = tp.cd_tipo_pessoa  
      Left outer join pais p  
        on ex.cd_pais = p.cd_pais  
    where   
      (ex.nm_fantasia = @nm_fantasia_exportador and @ic_tipo_consulta = 'F') or  
      (ex.nm_razao_social = @nm_fantasia_exportador and @ic_tipo_consulta = 'R')
  
    order by ex.nm_fantasia
  
  if (select count(cd_exportador) from #Exportador) = 1  
    select * from #Exportador  
  else  
    begin  
    Select distinct 
      ex.cd_exportador,  
      ex.nm_fantasia,  
      ex.nm_razao_social,
      ex.cd_pais,
			p.nm_pais,
			--tp.nm_tipo_pessoa,
      ex.cd_ddd,
			ex.cd_telefone,
      ex.cd_siscomex--,
			--cast(ex.ds_exportador as varchar(1500)) as ds_exportador
    from  
      Exportador ex  
      Left Join Tipo_Pessoa tp   
        On ex.cd_tipo_pessoa = tp.cd_tipo_pessoa  
      Left outer join pais p  
        on ex.cd_pais = p.cd_pais  
    where   
      (ex.nm_fantasia like @nm_fantasia_exportador + '%' and @ic_tipo_consulta = 'F') or  
      (ex.nm_razao_social like @nm_fantasia_exportador + '%' and @ic_tipo_consulta = 'R')
  
    order by ex.nm_fantasia
    end  
  end  
  
-------------------------------------------------------------------------------------------  
  else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum fornecedor  
-------------------------------------------------------------------------------------------  
  begin  
    Select 
      ex.cd_exportador,  
      ex.nm_fantasia,  
      ex.nm_razao_social,
      ex.cd_pais,
			p.nm_pais,
			--tp.nm_tipo_pessoa,
      ex.cd_ddd,
			ex.cd_telefone,
      ex.cd_siscomex--,
			--cast(ex.ds_exportador as varchar(1500)) as ds_exportador
    from  
      (select * from Exportador where 1=2) ex  
      Left Join Tipo_Pessoa tp   
        On ex.cd_tipo_pessoa = tp.cd_tipo_pessoa  
      Left outer join pais p  
        on ex.cd_pais = p.cd_pais  
  
    order by ex.nm_fantasia
  end  
  
-- =============================================    
-- Testando a procedure    
-- =============================================   
/*
exec pr_consulta_exportador
@ic_parametro = 2,  
@nm_fantasia_exportador = 'G',  
@ic_tipo_consulta = 'F'
*/
