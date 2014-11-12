
--sp_helptext pr_programacao_contrato_fornecimento

-------------------------------------------------------------------------------
--pr_programacao_contrato_fornecimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Programação de Entrega do Contrato de Fornecimento
--Data             : 07.11.2006
--Alteração        : 
-----------------------------------------------------------------------------------
create procedure pr_programacao_contrato_fornecimento
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_cliente   int      = 0,
@cd_produto   int      = 0

-----------------------------------------------------------------------------------
--Parâmetro 
-----------------------------------------------------------------------------------
--0 => Analítico
--1 => Diária
--2 => Semanal
--3 => Mensal
--4 => Anual
-----------------------------------------------------------------------------------

as

--select * from contrato_fornecimento
--select * from contrato_fornecimento_item
--select * from contrato_fornecimento_item_mes

select 
  cfim.cd_ano,
  cfim.cd_mes,
  m.nm_mes,
  Semana = ( datepart(week,cfim.dt_prevista_contrato) ),
  cfim.dt_prevista_contrato,
  cfim.qt_contrato_fornecimento,
  c.nm_fantasia_cliente,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  cfim.qt_liberacao,
  cfim.dt_liberacao,
  cf.cd_contrato_fornecimento,
  cf.dt_contrato_fornecimento,
  v.nm_fantasia_vendedor
--into
--  #ContratoF

from
  Contrato_Fornecimento cf
  inner join Cliente                    c        on c.cd_cliente                  = cf.cd_cliente
  inner join Contrato_Fornecimento_Item cfi      on cfi.cd_contrato_fornecimento  = cf.cd_contrato_fornecimento
  inner join Produto                    p        on p.cd_produto                  = cfi.cd_produto
  left outer join Unidade_Medida        um       on um.cd_unidade_medida          = p.cd_unidade_medida
  inner join 
    Contrato_Fornecimento_Item_Mes      cfim     on cfim.cd_contrato_fornecimento = cfi.cd_contrato_fornecimento and
                                                    cfim.cd_item_contrato         = cfi.cd_item_contrato
  left outer join Mes                   m        on m.cd_mes                      = cfim.cd_mes
  left outer join Vendedor              v        on v.cd_vendedor                 = cf.cd_vendedor
where
  cfim.cd_ano between year(@dt_inicial)  and year(@dt_final) and
  cfim.cd_mes between month(@dt_inicial) and year(@dt_final) and
  cf.cd_cliente  = Case when isnull( @cd_cliente, 0 )=0 then cf.cd_cliente  else @cd_cliente end and
  cfi.cd_produto = Case when isnull( @cd_produto, 0 )=0 then cfi.cd_produto else @cd_produto end

order by
  cfim.cd_ano ,cfim.cd_mes, cfim.dt_prevista_contrato 

--select
--select * from mes
--select * from ano

