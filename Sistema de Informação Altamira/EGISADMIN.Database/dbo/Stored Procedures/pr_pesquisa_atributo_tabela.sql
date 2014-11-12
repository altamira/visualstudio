
-------------------------------------------------------------------------------
--pr_pesquisa_atributo_tabela
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_pesquisa_atributo_tabela
@ic_parametro int = 1,
@nm_atributo varchar(40)
as

select

  Isnull(b.nm_banco_dados,
			'EgisSQL - Base Operacional do Cliente') as Banco,
  t.nm_tabela               as Tabela,
  a.nm_atributo             as Atributo,
  a.ds_atributo             as Descricao,
  n.nm_natureza_atributo    as Natureza,
  Isnull(a.qt_tamanho_atributo,0)     					as Tamanho,
  Isnull(a.qt_decimal_atributo,0)     					as 'Decimal',
  Isnull(a.nm_mascara_atributo,'Sem Máscara')     	as Mascara,
  (case isNull(a.ic_atributo_obrigatorio, 'N') 
		when 'N' then
			'Não'	
      else
         'Sim' 
   end) as Obrigatorio,
  (case isNull(  a.ic_atributo_chave, 'N') 
		when 'N' then
			'Não'	
      else
         'Sim' 
   end)  as Chave,
    
  (case isNull(  a.ic_chave_estrangeira, 'N') 
		when 'N' then
			'Não'	
      else
         'Sim' 
   end)as Estrangeira,
  Cast(isnull(a.ds_campo_help,'Sem descrição de ajuda') as varchar(4000)) as 'Help'  
from
  Atributo a 
  left outer join tabela t            on t.cd_tabela            = a.cd_tabela
  left outer join banco_dados b       on b.cd_banco_dados       = t.cd_banco_dados
  left outer join natureza_atributo n on n.cd_natureza_atributo = a.cd_natureza_atributo
where
  isnull(a.nm_atributo,'') like cast((Case @ic_parametro 
												when 1 then
												  (Case isnull(@nm_atributo,'') when '' then isnull(a.nm_atributo,'') else isnull(@nm_atributo,'') end)
												else
													isnull(a.nm_atributo,'')
 												end)	as varchar)+ '%' and 
  isnull(a.ds_atributo,'') like cast( (Case @ic_parametro 
												when 2 then
												  (Case isnull(@nm_atributo,'') when '' then isnull(a.ds_atributo,'') else isnull(@nm_atributo,'') end)
												else
													isnull(a.ds_atributo,'')
												end)	as varchar)	+ '%' 	 and
  isnull(a.ds_campo_help,'') like cast( (Case @ic_parametro 
												when 3 then
												  (Case isnull(@nm_atributo,'') when '' then isnull(a.ds_campo_help,'') else isnull(@nm_atributo,'') end)
												else
													isnull(a.ds_campo_help,'')
												end)	as varchar)	+ '%' 	
										        
order by
  banco,t.nm_tabela  
  
--select * from banco_dados  
--select * from tabela
--select * from atributo
--select * from natureza_atributo

--sp_help atributo

