---------------------------------------------------------------------------------------    
--fn_gera_lote_processo    
---------------------------------------------------------------------------------------    
--GBS - Global Business Solution                                           2005    
---------------------------------------------------------------------------------------    
--Stored Procedure : Microsoft SQL Server 2000    
--Autor(es)  : Vagner do Amaral    
--Banco de Dados : EGISSQL ou EGISADMIN    
--Objetivo  : Gerar código do lote    
--    
--Data   : 29/07/2005    
--Atualização  : 24/11/2006 - Incluído customização de lote da trm - Daniel C. Neto.  
---------------------------------------------------------------------------------------  
create function fn_gera_lote_processo
(@data char(2))
    
returns varchar(30)    
    
as    
begin    
 declare @novo_lote varchar(30),    
  @ref varchar(15),    
  @ano char(1),    
  @numero int,    
  @passo float        
  
  declare @ic_estado_lote char(1)
  declare @ic_rateio int  
  
  set @ic_rateio = dbo.fn_ver_uso_custom('LOTE')  
  
 
      
  select     
   @numero         = cast(cd_numero_lote as float),     
   @passo          = qt_passo_lote,    
   @ano            = isnull(ic_ano_lote,'N'),
   @ic_estado_lote = isnull(ic_estado_lote,'N'),       
   @ref            = nm_ref_numero_lote    
     
  from     
   lote_numeracao with (nolock)     
  
  
  
  if @ic_rateio = 1   
  begin  
  
  
    declare @num_str varchar(5)  
    set @num_str = dbo.fn_strzero(IsNull(cast(@numero as int),'1'),5)  
  
    set @novo_lote = ( select e.sg_estado   
         from EGISADMIN.dbo.Empresa emp inner join     
       Estado e on e.cd_estado = emp.cd_estado  
         where emp.cd_empresa = dbo.fn_empresa())

        + 

        '-'      +
        @num_str +
        '/'      + 
        @data  
  
  end   else  
  begin  
    if (@ano = 's') and (len(@ref)>0)    
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)+(@ref)+(@data)    
    else if(@ano = 's') and (len(@ref)=0)    
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)+(@data)    
    else if(@ano = 'n') and (len(@ref)>0)    
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)+(@ref)    
    else   
      set @novo_lote =  cast(((@numero)+(@passo))as varchar)       
   
  end  
    
  return (@novo_lote)    
    
end    
    
