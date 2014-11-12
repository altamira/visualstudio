
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_preparacao_implantacao_nfe
-------------------------------------------------------------------------------
--pr_geracao_preparacao_implantacao_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : NOTA FISCAL ELETRÔNICA
--
--                   Preparação de Implantação de Nota Fiscal Eletrônica
--                   Dados Padrão

--Data             : 23.06.2009 
--Alteração        : 12.08.2009 - Ajustes diversos para atualizar a tabela de tributacao
--                   25.02.2010 - Ajustes / complementos de Campos - Carlos / Luis
--
------------------------------------------------------------------------------------------------
create procedure pr_geracao_preparacao_implantacao_nfe
@ic_parametro int = 0
as

select @ic_parametro as ic_parametro

--Versao da Tabela de Nota Fiscal eletronica

delete from versao_nfe

insert into versao_nfe 
select
  *
from 
  nfe.dbo.versao_nfe


--País

--select * from pais

update
  pais
set
  cd_bacen_pais = 1058
where
  cd_pais = 1

--Atualização do Código do IBGE do Estado

select 
    UF,
    NOME_UF
into
  #estado

from
  nfe.dbo.ibge_cidade
group by
    UF,
    NOME_UF

select * from #Estado order by NOME_UF

select
  UF as cd_ibge_estado,
  e.sg_estado,
  e.cd_ibge_estado
from
  egissql.dbo.estado e
  inner join #estado i on i.NOME_UF = e.nm_estado

update
  egissql.dbo.estado
set
  cd_ibge_estado = UF
from
  egissql.dbo.estado e
  inner join #estado i on i.NOME_UF = e.nm_estado


drop table #estado
  

--Atualização do Código do IBGE da Cidade

--select * from ibge_cidade
--select * from egissql.dbo.cidade

select
  [Município] as cd_ibge_cidade,
  [Município_Nome] as nm_cidade
into
  #Cidade
from
  nfe.dbo.ibge_cidade
group by
  [Município],
  [Município_Nome]

select
 * 
from #Cidade

update
  egissql.dbo.cidade
set
  cd_cidade_ibge = x.cd_ibge_cidade
from
  egissql.dbo.cidade c
  inner join #Cidade x on x.nm_cidade = c.nm_cidade
  
drop table #Cidade


--select * from cidade
--cd_cidade_ibge


--Forma de Pagamento

delete from egissql.dbo.forma_condicao_pagamento
 
insert into
   egissql.dbo.forma_condicao_pagamento
select
  *
from
  nfe.dbo.forma_condicao_pagamento

--Atualizar as Condições de Pagamento

update
  condicao_pagamento
set
  cd_forma_condicao = 2


--Modalidade de cálculo do ICMS

insert into
   egissql.dbo.modalidade_calculo_icms
select
  *
from
  nfe.dbo.modalidade_calculo_icms

--Modalidade de cálculo do ICMS Subs.Trib

insert into
   egissql.dbo.modalidade_calculo_icms_strib
select
  *
from
  nfe.dbo.modalidade_calculo_icms_strib

--Tributação IPI

insert into
   egissql.dbo.tributacao_ipi
select
  *
from
  nfe.dbo.tributacao_ipi

--Tributação PIS

insert into
   egissql.dbo.tributacao_pis
select
  *
from
  nfe.dbo.tributacao_pis

--Tributação COFINS

insert into
   egissql.dbo.tributacao_cofins
select
  *
from
  nfe.dbo.tributacao_cofins


--select * from tipo_validacao
--Tipo de Validação

insert into
   egissql.dbo.tipo_validacao
select
  *
from
  nfe.dbo.tipo_validacao


--Atualiza a Série da Nota Fiscal

--select * from serie_nota_fiscal

update
  serie_nota_fiscal
set
  ic_ativa_serie_nota_fiscal = 'S',
  qt_serie_nota_fiscal       = 1

--select * from modalidade_servico

--Atualizando a tabela de tributacao

--select * from tributacao

update
  tributacao
set
 cd_modalidade_icms = 4,
 --cd_modalidade_icms_st =   
 cd_tributacao_ipi  = 1,
 cd_tributacao_pis  = 1,
 cd_tributacao_cofins = 1 

--select * from modalidade_calculo_icms

