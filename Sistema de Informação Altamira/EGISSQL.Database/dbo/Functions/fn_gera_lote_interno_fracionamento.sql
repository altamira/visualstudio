---------------------------------------------------------------------------------------    
--sp_helptext fn_gera_lote_interno_fracionamento
---------------------------------------------------------------------------------------    
--GBS - Global Business Solution                                           2005    
---------------------------------------------------------------------------------------    
--Stored Procedure : Microsoft SQL Server 2000    
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EGISSQL 
--Objetivo         : Gerar código do lote    
--    
--Data             : 29/07/2005    
--Atualização      : 
--18.11.2010 - Desenvolvimento para Rotina do Fracionamento - CARLOS FERNANDES
--02.12.2010 - Mudança da Numeração - Carlos Fernandes
--16.12.2010 - Gera o Lote Interno - Carlos Fernandes
---------------------------------------------------------------------------------------  
create function fn_gera_lote_interno_fracionamento
(@cd_laudo                 int     = 0,
 @cd_produto_fracionamento int     = 0,
 @cd_produto               int     = 0 )
    
returns varchar(30)    
    
as    

begin    

 declare @novo_lote varchar(30),    
  @ref              varchar(15),    
  @ano              char(1),    
  @numero           int,    
  @passo            float        
  
  declare @ic_estado_lote char(1)

  set @numero = 0  
      
  declare @num_str varchar(6)  

  if @numero = 0
  begin

    --select * from laudo   

    select
      @numero = cast(substring(cd_lote_interno,4,6) as int )
    from
      laudo with (nolock) 
    where
      cd_laudo = @cd_laudo

    set @num_str = dbo.fn_strzero(IsNull(cast(@numero as int),'1'),6)  

  end     

  --Verifica as quantidades de Fracionamentos dos Produtos

  --select * from lote_numeracao_fracionamento

  select     
    top 1
    @passo          = case when isnull(qt_passo_lote,0)=0 then 1 else qt_passo_lote end
     
  from     
    lote_numeracao_fracionamento with (nolock)     

  where
   cd_laudo                 = @cd_laudo                 and
   cd_produto               = @cd_produto               

   --and cd_produto_fracionamento = @cd_produto_fracionamento 
 
  if @passo = 0 or @passo is null 
  begin
    Set @passo = 1
  end 
 
  set @ref        = 'PS'
  set @novo_lote  =  ( @ref ) + '-' + @num_str + '/' + 'F' + dbo.fn_strzero(@passo,2)   


--select * from guia_fracionamento_item    
--select * from produto_fracionamento

--end  
    
  return (@novo_lote)    
    
end    
    
