
CREATE PROCEDURE pr_consulta_fornecedor_contato_email

@ic_parametro  as int         = 0,  --1 Fornecedores, outro número contatos
@nm_fornecedor as varchar(50) = '',
@cd_fornecedor as int         = 0   -- para que eu possa somente retornar um Fornecedor quando pesquisar por contato
 
AS
--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 -- Fornecedores
--------------------------------------------------------------------------------------------

begin

select
  f.cd_fornecedor               as 'Codigo',
  f.nm_razao_social             as 'RazaoSocial',
  f.nm_fantasia_fornecedor      as 'NomeFantasia',
  '(' +IsNull(f.cd_ddd,'') + ') ' + IsNull(f.cd_telefone,'') as 'DDDTelefone'
 
from
   Fornecedor f 
where
   IsNull(f.nm_email_fornecedor,'') = '' and
   f.nm_fantasia_fornecedor like @nm_fornecedor + '%'

order by NomeFantasia

end
------------------------------------------
else  -- Pesquisar por contato
------------------------------------------
begin

select
  f.nm_razao_social                     as 'RazaoSocial',
  f.nm_fantasia_fornecedor              as 'NomeFantasia',
  '(' + IsNull(f.cd_ddd,'') + ') ' + IsNull(f.cd_telefone,'')  	  as 
'DDDTelefone',
  fc.cd_contato_fornecedor              as 'Codigo',
  fc.nm_contato_fornecedor              as 'RazaoSocialContato',
  fc.nm_fantasia_contato_forne          as 'NomeFantasiaContato',
  '(' + IsNull(fc.cd_ddd_contato_fornecedor,'') + ') ' + IsNull(fc.cd_telefone_contato_forne,'') as 'DDDTelefoneContato',
  fc.cd_ramal_contato_forneced          as 'RamalContato',
  fc.cd_celular_contato_fornec          as 'CelularContato'

from
   Fornecedor_Contato fc inner join
   Fornecedor         f  on f.cd_fornecedor = fc.cd_fornecedor 

where
   fc.cd_fornecedor = @cd_fornecedor and
   IsNull(fc.cd_email_contato_forneced,'') = ''

order by NomeFantasia

end


