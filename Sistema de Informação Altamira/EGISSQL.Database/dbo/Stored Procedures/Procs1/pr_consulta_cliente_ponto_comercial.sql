
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_cliente_ponto_comercial
-------------------------------------------------------------------------------
--pr_consulta_cliente_ponto_comercial
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Clientes Ativos no Ponto Comercial
--Data             : 27.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_cliente_ponto_comercial
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from ponto
--select * from cliente_ponto
--select * from cliente

select
  p.cd_ponto,
  p.nm_ponto,
  p.nm_fantasia_ponto,
  p.cd_cep,
  p.nm_endereco_ponto,
  p.cd_numero_endereco,
  p.nm_bairro_ponto,
  pa.nm_pais,
  e.sg_estado,
  cid.nm_cidade,
  
  --Dados do Cliente

  c.cd_cliente,
  c.nm_fantasia_cliente,
  c.nm_razao_social_cliente,
  c.dt_cadastro_cliente,
  Dias = cast( getdate() - c.dt_cadastro_cliente  as int ) ,
  c.cd_cnpj_cliente,
  c.cd_ddd,
  c.cd_telefone
  
from
  Ponto p                          with (nolock) 
  left outer join Cliente_Ponto cp with (nolock) on cp.cd_ponto   = p.cd_ponto
  left outer join Cliente c        with (nolock) on c.cd_cliente  = cp.cd_cliente
  left outer join Pais  pa         with (nolock) on pa.cd_pais    = p.cd_pais
  left outer join Estado e         with (nolock) on e.cd_estado   = p.cd_estado
  left outer join Cidade cid       with (nolock) on cid.cd_cidade = p.cd_cidade
where
  isnull(cp.ic_ativo_cliente_ponto,'N')='S'

order by
  p.nm_ponto

