
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias Pereira da Silva
--Banco de Dados: EgisSql
--Objetivo: Campos Impressos na NF relativos ao Desconto
--          do ICMS quando ZFM
--Data: ???/
--Atualizado: 04/08/2003 - Considerado a Redução de BC e Valores de Frete e Seguro - ELIAS
--            18/02/2004 - Retirada instrução group by ue estava gerando mais do que 
--                         registro como resultado - ELIAS
--            08/09/2005 - Incluido o Valor de PIS E COFINS - Rafael Santiago
--            23.05.2006 - Verificação do Cálculo de PIS/COFINS - Carlos Fernandes
-- 29.10.2008 - Cálculo do Desconto Promocional - Carlos Fernandes
-------------------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_desconto_zona_franca
@ic_parametro        int         = 0,
@nm_fantasia_empresa varchar(20) = '',
@cd_nota_fiscal      int         = 0

as  

  declare @cd_destinacao_produto     int    
  declare @pc_desconto_icms          float    
  declare @ic_mostra_icms_corpo_nota char(1)    
  declare @vl_desconto               decimal(25,2)   
  declare @vl_desconto2              decimal(25,2)   
  declare @vl_desconto_promocional   decimal(25,2)
  declare @ic_zfm                    char(1) 
  
  declare @cd_pis     int,      
          @cd_cofins  int,      
          @pc_pis     money,      
          @pc_cofins  money      
  
  set @vl_desconto  = 0.00
  set @vl_desconto2 = 0.00
  set @vl_desconto_promocional = 0.00

  --Impostos que serão retidos na fonte      
  --PIS      
  Select top 1 @cd_pis    = cd_imposto from imposto where sg_imposto = 'PIS'    order by cd_imposto      
  
  --COFINS      
  Select top 1 @cd_cofins = cd_imposto from imposto where sg_imposto = 'COFINS' order by cd_imposto      
   
  --PIS      
  
  Select       
    top 1      
    @pc_pis = IsNull(pc_imposto,0)      
  from       
    Imposto_Aliquota with (nolock)       
  where       
    cd_imposto = @cd_pis and      
    dt_imposto_aliquota <= (select dt_nota_saida from Nota_Saida where cd_nota_saida = @cd_nota_fiscal)      
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
    dt_imposto_aliquota <= (select dt_nota_saida from Nota_Saida where cd_nota_saida = @cd_nota_fiscal)      
  order by       
    dt_imposto_aliquota desc    
       
      
 select     
  @pc_desconto_icms = isnull(pc_desc_icms_zona_franca,0)     
 from     
  parametro_faturamento with (nolock)      
 where     
  cd_empresa = dbo.fn_empresa()    
    
  -- Localiza o Estado do Cliente, o Perc. de Desconto e a Destinação    

  select    
    @cd_destinacao_produto = n.cd_destinacao_produto,       
    @ic_mostra_icms_corpo_nota =    
  (case ep.ic_mostra_icms_corpo_nota    
      when 'S' then    
        'S'    
      else    
        IsNull(c.ic_zona_franca_icms,'N')     
     end),
    @ic_zfm = isnull(c.ic_zona_franca_icms,'N')    
  from    
    Estado e,    
    Nota_Saida n,    
    Estado_Parametro ep,    
    Cidade c    
  where    
    n.cd_nota_saida        = @cd_nota_fiscal and    
    n.sg_estado_nota_saida = e.sg_estado and    
    e.cd_estado            = ep.cd_estado and    
    e.cd_pais              = 1 and  -- Brasil      
    c.nm_cidade            = n.nm_cidade_nota_saida and    
    c.cd_estado            = e.cd_estado    
    
  -- É listado um Total somente quando Industrialização/Revenda, Estado é    
  -- Zona Franca e ic_mostra_icms_corpo_nota = 'S'    

  if (((@cd_destinacao_produto = 1) or     
       (@cd_destinacao_produto = 3)) and (@ic_mostra_icms_corpo_nota = 'S'))    
    begin    
     
      select @vl_desconto = isnull(vl_desconto_nota_saida,0)    
      from Nota_Saida with (nolock)    
      where cd_nota_saida = @cd_nota_fiscal    
  
       
      select @vl_desconto2 = isnull(vl_desconto_nota_saida,0)    
      from Nota_Saida with (nolock)    
      where cd_nota_saida = @cd_nota_fiscal    
    
      select     
        @vl_desconto = isnull(case when (isnull(min(pc_reducao_icms),0) = 0) then    
                         ((sum((isnull(vl_total_item,0) + isnull(vl_frete_item,0) + isnull(vl_seguro_item,0) + isnull(vl_desp_acess_item,0))) - @vl_desconto) * (@pc_desconto_icms)/100)    
--                          sum((((isnull(vl_total_item,0) + isnull(vl_frete_item,0) + isnull(vl_seguro_item,0) + isnull(vl_desp_acess_item,0)) * (@pc_desconto_icms)/100)))    
                        else    
                          sum((((isnull(vl_total_item,0) + isnull(vl_frete_item,0) + isnull(vl_seguro_item,0) + isnull(vl_desp_acess_item,0)) * (isnull(pc_reducao_icms,100)/100)) * (@pc_desconto_icms/100)))    
    
    
                       end,0)    ,

        @vl_desconto_promocional = sum( isnull(qt_item_nota_saida,0) * isnull(vl_unitario_item_nota,0) * (isnull(pc_desconto_item,0)/100) )

      from    
        Nota_Saida_Item with (nolock)    
      where    
        cd_nota_saida = @cd_nota_fiscal    

--       group by    
--         pc_reducao_icms            
    
                                    
      select    
        sum( case when @ic_zfm = 'S' then isnull(vl_total_item,0)
             else
              isnull(qt_item_nota_saida,0) * isnull(vl_unitario_item_nota,0)
             end )      as 'VALORTOTAL',    

        @pc_desconto_icms                   as 'PERCDESC',    

        case when @ic_zfm = 'S' then
          @vl_desconto      
        else
          case when @vl_desconto_promocional>0
           then  
             @vl_desconto_promocional
           else
             0.00
           end
        end    as 'VALORDESC',    

--        sum( isnull(qt_item_nota_saida,0) * isnull(vl_unitario_item_nota,0))-

--         sum( case when @ic_zfm = 'S' 
--              then 
--               isnull(vl_total_item,0)
--              else
--               (isnull(qt_item_nota_saida,0) * isnull(vl_unitario_item_nota,0)
--               - ( isnull(qt_item_nota_saida,0) * 
--                   isnull(vl_unitario_item_nota,0) * 
--                   isnull(pc_desconto_item,0)/100 ))
--              end 
--              - (case when @vl_desconto>0 
--                 then @vl_desconto 
--                 else 0.00
--                 end )
--             )          as 'TOTALLIQUIDO',    

        sum( isnull(vl_total_item,0) )
             - (case when @vl_desconto>0 and @ic_zfm ='S' 
                then @vl_desconto 
                else 0.00
                end )           as 'TOTALLIQUIDO',

        '----------------'      as 'TRACO1',    
        '----------------'      as 'TRACO2',    
        'DESC. '+ltrim(str(@pc_desconto_icms,3,0))+'% ICMS ===>'         as 'MSGDESCONTO',    
        'TOTAL LÍQUIDO ===>'                                             as 'MSGTOTAL',  
        'PIS '+ltrim(cast(@pc_pis as varchar(10)))+'% ===>'              as 'MSGPIS',    
        cast(((sum(vl_total_item) - @vl_desconto2) * (@pc_pis / 100))    as decimal(25,2))as 'VLPIS',  
        'COFINS '+ltrim(str(@pc_cofins,3,0))+'% ===>'                    as 'MSGCOFINS',  
        cast(((sum(vl_total_item) - @vl_desconto2) * (@pc_cofins / 100)) as decimal(25,2))as 'VLCOFINS',  
        @vl_desconto2,  

        case when @vl_desconto_promocional>0 then 'SUB-TOTAL              : '
        else '' end                                       as 'MSGSUBTOTAL',  
        case when @vl_desconto_promocional>0 then '* DESCONTO PROMOCIONAL : '                              
        else '' end        as 'MSGDESCONTOPROMOCIONAL',  
        case when @vl_desconto_promocional>0 then 'TOTAL DOS PRODUTOS     : ' 
        else ''
        end                                     as 'MSGTOTALLIQUIDO'  
  
          
      from    
        Nota_Saida_Item with (nolock)    
      where    
        cd_nota_saida = @cd_nota_fiscal    and
        (@ic_zfm = 'S' or @vl_desconto_promocional>0)
      
--      group by    
--        pc_reducao_icms    
    
    
    end    
  else    
    begin    
    
      select    
        null   as 'VALORTOTAL',    
        null   as 'PERCDESC',    
        null   as 'VALORDESC',    
        null   as 'TOTALLIQUIDO',    
        null   as 'MSGDESCONTO', 
        null   as 'MSGDESCONTOPROMOCIONAL',
        null   as 'MSGSUBTOTAL',
        null   as 'MSGTOTALLIQUIDO',
        null   as 'MSGTOTAL',  
        null   as 'MSGPIS',  
        null   as 'VLPIS',  
        null   as 'MSGCOFINS',  
        null   as 'VLCOFINS',     
        null   as 'TRACO1',    
        null   as 'TRACO2'            
    end      
  
