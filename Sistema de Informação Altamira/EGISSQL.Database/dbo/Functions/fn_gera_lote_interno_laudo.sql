---------------------------------------------------------------------------------------    
--sp_helptext fn_gera_lote_interno_laudo   
---------------------------------------------------------------------------------------    
--GBS - Global Business Solution                                           2005    
---------------------------------------------------------------------------------------    
--Stored Procedure : Microsoft SQL Server 2000    
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EGISSQL 
--Objetivo         : Gerar código do lote    
--    
--Data             : 29/07/2005    
--Atualização      : 24/11/2006 - Incluído customização de lote da trm - Daniel C. Neto.  
---------------------------------------------------------------------------------------  
create function fn_gera_lote_interno_laudo
(@data char(2))
    
returns varchar(30)    
    
as    
begin    

 declare @novo_lote varchar(30),    
  @ref              varchar(15),    
  @ano              char(1),    
  @numero           int,    
  @passo            float        
  
  declare @ic_estado_lote char(1)
 
 
      
  select     
   @numero         = cast(isnull(cd_numero_lote,0) as float),     
   @passo          = isnull(qt_passo_lote,1),    
   @ano            = isnull(ic_ano_lote,'N'),
   @ic_estado_lote = isnull(ic_estado_lote,'N'),       
   @ref            = nm_ref_numero_lote    
     
  from     
   lote_numeracao with (nolock)     
  
  
    declare @num_str varchar(6)  

    set @num_str = dbo.fn_strzero(IsNull(cast(@numero+@passo as int),'1'),6)  
  
--     set @novo_lote = ( select e.sg_estado   
--          from EGISADMIN.dbo.Empresa emp inner join     
--        Estado e on e.cd_estado = emp.cd_estado  
--          where emp.cd_empresa = dbo.fn_empresa())
-- 
--         + 
-- 
--         '-'      +
--         @num_str +
--         '/'      + 
--         @data  
  
--   end   else  
--   begin  

    if (@ano = 'S') and (len(@ref)>0)    
       set @novo_lote  =  (@ref)+'-'+@num_str+'/'+@data    
    else if(@ano = 'S') and (len(@ref)=0)    
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)+(@data)    
    else if(@ano = 'N') and (len(@ref)>0)    
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)+(@ref)    
    else   
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)       
   
--end  
    
  return (@novo_lote)    
    
end    
    
