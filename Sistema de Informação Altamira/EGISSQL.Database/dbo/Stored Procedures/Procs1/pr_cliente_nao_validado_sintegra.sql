
-------------------------------------------------------------------------------
--pr_cliente_nao_validado_sintegra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de clientes que não foram validados no sintegra
--Data             : 15.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_cliente_nao_validado_sintegra
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_cliente int = 0
as

declare @qt_dia_validade_consulta int

select
  @qt_dia_validade_consulta = qt_dia_validade_consulta
from
  parametro_sintegra
where
  cd_empresa = dbo.fn_empresa()

--select * from cliente
--select * from cliente_sintegra

--Cliente não Pesquisado

select
  c.cd_cliente               as Codigo,
  e.sg_estado                as Sigla,
  c.nm_fantasia_cliente      as Fantasia,
  c.nm_razao_social_cliente  as RazaoSocial,
  sc.nm_status_cliente       as Status, 
  c.cd_suframa_cliente       as Suframa,
  c.cd_reparticao_origem     as RepOrigem,
  c.dt_cadastro_cliente      as DataCadastro,
  tp.nm_tipo_pessoa          as TipoPessoa,
  c.cd_cnpj_cliente          as Cnpj,
  c.cd_inscestadual          as IE,
  cast(null as datetime )    as Validado,
  cast(0    as int)          as Dias
into
  #AuxCli1
from
  Cliente c 
  left outer join status_cliente sc on sc.cd_status_cliente = c.cd_status_cliente
  left outer join tipo_pessoa    tp on tp.cd_tipo_pessoa    = c.cd_tipo_pessoa
  left outer join estado         e  on e.cd_estado          = c.cd_estado and
                                       e.cd_pais            = c.cd_pais
where
  c.cd_cliente = case when @cd_cliente=0 then c.cd_cliente else @cd_cliente end and
  c.cd_cliente not in ( select cd_cliente from cliente_sintegra )  
order by
  c.nm_fantasia_cliente


--Cliente pesquisados com data superior a quantidade de dias de validade

select
  c.cd_cliente               as Codigo,
  e.sg_estado                as Sigla,
  c.nm_fantasia_cliente      as Fantasia,
  c.nm_razao_social_cliente  as RazaoSocial,
  sc.nm_status_cliente       as Status, 
  c.cd_suframa_cliente       as Suframa,
  c.cd_reparticao_origem     as RepOrigem,
  c.dt_cadastro_cliente      as DataCadastro,
  tp.nm_tipo_pessoa          as TipoPessoa,
  c.cd_cnpj_cliente          as Cnpj,
  c.cd_inscestadual          as IE,
  cs.dt_cliente_sintegra     as Validado,
  datediff(day,cs.dt_cliente_sintegra,getdate() ) as Dias  

into
  #AuxCli2
from
  Cliente c 
  inner join Cliente_Sintegra    cs on cs.cd_cliente        = c.cd_cliente
  left outer join status_cliente sc on sc.cd_status_cliente = c.cd_status_cliente
  left outer join tipo_pessoa    tp on tp.cd_tipo_pessoa    = c.cd_tipo_pessoa
  left outer join estado         e  on e.cd_estado          = c.cd_estado and
                                       e.cd_pais            = c.cd_pais
where
  cs.dt_cliente_sintegra + @qt_dia_validade_consulta <= getdate() and
  c.cd_cliente = case when @cd_cliente=0 then c.cd_cliente else @cd_cliente end 
order by
  c.nm_fantasia_cliente


select * 
into #Resultado from #AuxCli1 
Union
select * from #AuxCli2 



--Mostra a Tabela Final
select * from #Resultado order by fantasia
