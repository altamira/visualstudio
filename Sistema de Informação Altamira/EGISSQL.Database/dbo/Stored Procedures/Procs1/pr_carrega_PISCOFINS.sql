

CREATE  PROCEDURE pr_carrega_PISCOFINS  
  @dt_base datetime  

-----------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
-----------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EgisSQL
--Objetivo		: Carregar PIS/COFINS 
--Data		        : 01.05.2004
--                        17/12/2004 - Acerto para colocar no padrão. - Daniel C. Neto.
--                      : 04.05.2006 - Ajustes - Carlos Fernandes
-- 11.12.2009 - Verificação da Rotina - Carlos Fernandes
-- 24.02.2010 - Ajustes - Carlos Fernandes
-- 08.06.2010 - Ajustes Diversos - Carlos Fernandes/Luis Fernando
-----------------------------------------------------------------------------------

as  
Begin  
  declare @cd_pis    int,  
          @cd_cofins int,  
          @pc_pis    money,  
          @pc_cofins money  
  
           
  --Impostos que serão retidos na fonte  
  --PIS  
  Select top 1 @cd_pis    = cd_imposto from imposto with (nolock) where sg_imposto = 'PIS'    order by cd_imposto  

  --COFINS  
  Select top 1 @cd_cofins = cd_imposto from imposto with (nolock) where sg_imposto = 'COFINS' order by cd_imposto  
  
  --Seleciona a primeira alíquota vigente apartir da data de saída da nota  
  --PIS  

  Select   
    top 1  
    @pc_pis = IsNull(pc_imposto,0)  
  from   
    Imposto_Aliquota   with (nolock) 
  where   
    cd_imposto = @cd_pis and  
    dt_imposto_aliquota <= @dt_base  
  order by   
    dt_imposto_aliquota desc  
  
  --COFINS  
  Select   
    top 1  
    @pc_cofins = IsNull(pc_imposto,0)  
  from   
    Imposto_Aliquota with (nolock)    
  where   
    cd_imposto = @cd_cofins and  
    dt_imposto_aliquota <= @dt_base  
  order by   
    dt_imposto_aliquota desc  
  
  Select   
    @pc_pis    as PIS,  
    @pc_cofins as COFINS  
  
end  


