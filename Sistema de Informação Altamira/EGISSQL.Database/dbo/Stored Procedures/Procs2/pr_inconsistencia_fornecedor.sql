
--pr_inconsistencia_Fornecedor
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Francisco/Daniel Carrasco
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar fornecedores com dados incorretos no cadastro
--Data			: 02/09/03
--Alteração		: <Data de Atualização>
--Desc. Alteração	: <Descrição da Alteração>
---------------------------------------------------
CREATE PROCEDURE pr_inconsistencia_fornecedor
AS
  
select
    f.cd_fornecedor,
    f.nm_fantasia_fornecedor,
     f.nm_razao_social,
     --f.cd_cnpj_fornecedor,
     f.cd_cep,
     e.sg_estado,
     f.cd_inscestadual as inscestadual,
     f.cd_cnpj_fornecedor,
     case when dbo.fn_valida_CNPJ('CNPJ',f.cd_cnpj_fornecedor) = 'INVALIDO' then 'INVALIDO' else '' end as cnpj_cod_cnpj_fornecedor,
     case when len(f.cd_cep) < 8 then 'X' else '' end as CEP_INCORRETO,
     case when f.cd_ddd = '' then 'X' else '' end as SEM_DDD,
     case when Rtrim(Ltrim(cd_telefone)) = '-' and len(cd_telefone) < 7 then 'X' else '' end as SEM_FONE,
     case when f.nm_fantasia_fornecedor like '%desativ%' or 
     f.nm_fantasia_fornecedor like '%falid%' or
     f.nm_fantasia_fornecedor like '%fechad%' then 'x' else '' end as inativar,
     case when f.ic_inscestadual_valida = 'S' then 'VALIDO' 
     when f.ic_inscestadual_valida = 'N' then 'INVALIDO'
     else
       null
     end as cd_inscestadual

 from
   fornecedor f

   left outer join
   Estado e on e.cd_estado = f.cd_estado and e.cd_pais = f.cd_pais

  where
  (( len(f.cd_cep) < 8 ) or
   ( f.cd_ddd = '' ) or
   ( Rtrim(Ltrim(f.cd_telefone)) = '-' ) or
   ( len(f.cd_telefone) < 7 ))
 or 
	(( f.cd_tipo_pessoa = 1 ) and
  ( dbo.fn_valida_CNPJ('CNPJ',f.cd_cnpj_fornecedor) = 'INVALIDO'))

  order by f.nm_razao_social

