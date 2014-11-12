
-------------------------------------------------------------------------------
--sp_helptext pr_rotina_atualizacao_nfe_versao_v200
-------------------------------------------------------------------------------
--pr_rotina_atualizacao_nfe_versao_v200
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Rotina de Atualização no Cliente
--                   Nota Fiscal Eletrônica - versão 2.00
--Data             : 05.10.2010
--Alteração        : 06.10.2010 - 
--
--
------------------------------------------------------------------------------
create procedure pr_rotina_atualizacao_nfe_versao_v200
as

update
  documento_receber
set
  cd_serie_nota_fiscal = 1
where
  cd_serie_nota_fiscal is null
  

update
  parametro_faturamento
set
  cd_serie_nota_fiscal = 1
where
  isnull(cd_serie_nota_fiscal,0)=0

update
  documento_receber
set
  cd_serie_nota_fiscal = 1
where
  isnull(cd_serie_nota_fiscal,0)=0

update
  classificacao_fiscal
set
  ic_base_pis_clas_fiscal = 'N'
where
  ic_base_pis_clas_fiscal is null



--select * from cnae
delete from cnae

--select * from versao_nfe

--0. operação fiscal

--Cálculo do PIS/COFINS

update
  operacao_fiscal
set
  ic_calculo_piscofins = 'S'
where
  ic_calculo_piscofins is null and
  isnull(ic_comercial_operacao,'N') = 'S'

-------------------------------------------------------------------------
--Identificação do Número da Nota Fiscal
-------------------------------------------------------------------------

update
  nota_saida
set
  cd_identificacao_nota_saida = cd_nota_saida
where
  isnull(cd_identificacao_nota_saida,0)=0



--1. sigla do lay-out

update
  versao_nfe
set
  sg_versao_nfe        = '2.00',
  nm_contingencia_nfe  = '“DANFE em Contingência - impresso em decorrência de problemas técnicos”',
  cd_empresa           = dbo.fn_empresa(),
  cd_regime_tributario = 3  --> Quando for simples mudar no cadastro.


--2. ultima nota fiscal

update 
  versao_nfe
set
  cd_nota_saida = ( select top 1 cd_nota_saida from nota_saida order by cd_nota_saida desc )


--select * from serie_nota_fiscal

update
  serie_nota_fiscal
set
  cd_nfe_serie = 1
where
  cd_serie_nota_fiscal = 1



--2. pagamento de frete

--select * from tipo_pagamento_frete

insert into 
  tipo_pagamento_frete
select
  3                       as cd_tipo_pagamento_frete,
  'Terceiros'             as nm_tipo_pagamento_frete,
  'T'                     as sg_tipo_pagamento_frete,
  '3'                     as cd_identifica_nota_fiscal,
  getdate()               as dt_usuario,
  4                       as cd_usuario,
  'N'                     as ic_tipo_pagamento_frete,
  'N'                     as ic_pagar_pagamento_frete,
  cast('' as varchar(15)) as cd_sped_fiscal
  

insert into 
  tipo_pagamento_frete
select
  4                       as cd_tipo_pagamento_frete,
  'Sem Frete'             as nm_tipo_pagamento_frete,
  'SF'                    as sg_tipo_pagamento_frete,
  '9'                     as cd_identifica_nota_fiscal,
  getdate()               as dt_usuario,
  4                       as cd_usuario,
  'N'                     as ic_tipo_pagamento_frete,
  'N'                     as ic_pagar_pagamento_frete,
  cast('' as varchar(15)) as cd_sped_fiscal



--3. Regime Tributário

--regime_tributario
insert into
 regime_tributario
select
  1                  as cd_regime_tributario,
  'Simples Nacional' as nm_regime_tributario,
  'SN'               as sg_regime_tributario,
  4                  as cd_usuario,
  getdate()          as dt_usuario,
  1                  as cd_nfe_regime


insert into
 regime_tributario
select
  2                  as cd_regime_tributario,
  'Simples Nacional - Excesso Sub-Limite de' as nm_regime_tributario,
  'SNE'               as sg_regime_tributario,
  4                  as cd_usuario,
  getdate()          as dt_usuario,
  2                  as cd_nfe_regime

insert into
 regime_tributario
select
  3                  as cd_regime_tributario,
  'Regime Normal' as nm_regime_tributario,
  'RN'               as sg_regime_tributario,
  4                  as cd_usuario,
  getdate()          as dt_usuario,
  3                  as cd_nfe_regime
 

--4. Situação da Operação Simples

--select * from situacao_operacao_simples

insert into
  situacao_operacao_simples
select
  1 as cd_situacao_operacao,
  'Tributada pelo Simples Nacional com Permissão de Crédito' as nm_situacao_operacao,
  '101'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario

insert into
  situacao_operacao_simples
select
  2 as cd_situacao_operacao,
  'Tributada pelo Simples Nacional sem permissão de Crédito' as nm_situacao_operacao,
  '102'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario


insert into
  situacao_operacao_simples
select
  3 as cd_situacao_operacao,
  'Isenção de ICMS no Simples Nacional para faixa de receita bruta' as nm_situacao_operacao,
  '103'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario
 

insert into
  situacao_operacao_simples
select
  4 as cd_situacao_operacao,
  'Tributada Simples Nacional com permissão de crédito com Cob.ICMS por Subst.Tributária' as nm_situacao_operacao,
  '201'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario

insert into
  situacao_operacao_simples
select
  5 as cd_situacao_operacao,
  'Tributada pelo Simples Nacional sem permissão de crédito e com cobrança ICMS por Subst. Tributária' as nm_situacao_operacao,
  '202'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario

insert into
  situacao_operacao_simples
select
  6 as cd_situacao_operacao,
  'Isenção do ICMS no Simples Nacional para faixa de receita bruta e com cobrança do ICMS por ST' as nm_situacao_operacao,
  '203'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario

insert into
  situacao_operacao_simples
select
  7 as cd_situacao_operacao,
  'Imune' as nm_situacao_operacao,
  '300'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario

insert into
  situacao_operacao_simples
select
  8 as cd_situacao_operacao,
  'Não Tributada pelo Simples Nacional' as nm_situacao_operacao,
  '400'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario

insert into
  situacao_operacao_simples
select
  9 as cd_situacao_operacao,
  'ICMS cobrado anteriormente por subst. tributária (substítuido) ou por antecipação' as nm_situacao_operacao,
  '500'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario


insert into
  situacao_operacao_simples
select
  10 as cd_situacao_operacao,
  'Outros' as nm_situacao_operacao,
  '900'     as cd_identificacao_situacao,
  4         as cd_usuario,
  getdate() as dt_usuario


--Origem do Processo

--origem_processo_sefaz
--Origem_Processo_Fisco_NFE

insert into Origem_Processo_Fisco_NFE
select
 1       as cd_origem_processo,
 'SEFAZ' as nm_origem_processo,
 'SEFAZ' as sg_origem_processo,
 '0'     as cd_identificacao_processo,
 4       as cd_usuario,
 getdate() as dt_usuario,
 'S'       as ic_pad_origem_processo


