
--pr_exportador_data_cadastro
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Anderson Messias da Silva
--Banco de Dados  : EGISSQL
--Objetivo        : Consulta de Exportadores Novos.
--Atualização     : 
---------------------------------------------------

CREATE PROCEDURE pr_exportador_data_cadastro

@data_inicial datetime

AS

select 
  ex.cd_exportador,
  ex.nm_fantasia                                                 as 'NomeFantasia',
  ex.dt_cadastro                                                 as 'DataCadastro',
  ex.cd_ddd                                                      as 'DDD',
  ex.cd_telefone                                                 as 'Telefone',
  c.nm_cidade                                                    as 'Cidade',
  e.sg_estado                                                    as 'Estado',
  ex.ds_exportador_endereco                                      as 'EnderecoEspecial',
  ltrim(rtrim(cast( ex.ds_exportador_endereco as varchar(50) ))) as 'EnderecoEspecialRel'
from
  Exportador ex
  left outer join Cidade c on ex.cd_cidade = c.cd_cidade
  left outer join Estado e on ex.cd_estado = e.cd_estado
where
  ex.dt_cadastro between @data_inicial and getdate()  
order by
  DataCadastro desc,
  NomeFantasia

