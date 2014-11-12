
CREATE VIEW vw_programacao_contrato_produto
------------------------------------------------------------------------------------
--sp_helptext vw_programacao_contrato_produto
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Consulta da Programação do Produto
--
--Data                  : 06.11.2008
--Atualização           : 10.04.2009 - Complemento das informações - Carlos Fernandes
--------------------------------------------------------------------------------------------
as

--select * from contrato_fornecimento
--select * from contrato_fornecimento_item
--select * from Contrato_Fornecimento_item_mes

  select
    cf.cd_contrato_fornecimento,
    isnull(cf.cd_vendedor,c.cd_vendedor) as cd_vendedor,
    c.cd_cliente,
    c.cd_vendedor_interno,
    c.nm_fantasia_cliente,
    p.cd_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida,
    i.dt_vigencia_inicial,
    i.dt_vigencia_final,
    m.cd_ano,
    m.cd_mes,
    m.qt_contrato_fornecimento,
    i.vl_unitario_item_contrato,
    ( m.qt_contrato_fornecimento * i.vl_unitario_item_contrato ) as vl_total_item_contrato,
    m.dt_prevista_contrato,
    datepart(dw,m.dt_prevista_contrato)                          as DiaSemana
  from
    Contrato_Fornecimento_item i                     with (nolock)
    inner join contrato_fornecimento cf              with (nolock) on cf.cd_contrato_fornecimento   = i.cd_contrato_fornecimento
    left outer join Cliente          c               with (nolock) on c.cd_cliente                  = cf.cd_cliente
    left outer join Produto      p                   with (nolock) on p.cd_produto                  = i.cd_produto
    left outer join Unidade_Medida um                with (nolock) on um.cd_unidade_medida          = p.cd_unidade_medida
    left outer join Contrato_Fornecimento_item_mes m with (nolock) on m.cd_contrato_fornecimento    = i.cd_contrato_fornecimento and
                                                                      m.cd_item_contrato            = i.cd_item_contrato
  where
    isnull(m.qt_liberacao,0) = 0

 
