
CREATE VIEW vw_inventario_servnews_2006

-----------------------------------------------------------------------------------------  
-- vw_inventario_servnews_2006
-----------------------------------------------------------------------------------------  
-- GBS - Global Business Solution                                                    2002  
-- Stored Procedure : Microsoft SQL Server 2000  
-- Autor(es)        : Alexandre Del Soldato  
-- Banco de Dados   : EgisSql  
-- Objetivo         : Lista Regitro de Invetário de Produto utilizado nos Arquivos Magnéticos  
-- Data             : 22/03/2004  
-- Atualizado       : 14.08.2007 - Acertos Diversos - Carlos Fernandes  
-- 07.11.2008 - Ajuste para ServNews
-----------------------------------------------------------------------------------------  
--   
as  

--select * from migracao.dbo.[2006]
  
  select distinct  
    p.CODIGO,  
    p.FANTASIA                                       as PRODUTO,  
    p.FANTASIA                                       as FANTASIA,  
    '12/31/2006'                                     as DATAINVENTARIO,  
  
    p.QTD                                            as QUANTIDADE,  
    p.QTD * P.UNITARIO                               as VALOR,  
  
    1                                                as CODPOSSE, -- Em propriedade do Informante  
  
   '02973703000121'                                 as CNPJPOSSE,  
    replace('645423963118','.','')                  as IEPOSSE,  
  
    isnull('SP','SP')                                as UFPOSSE,  
    cast('' as char(45))                             as Brancos  
  
  from        
    migracao.dbo.[2006] p
  where
   p.QTD > 0

