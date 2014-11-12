
CREATE VIEW vw_faturamento_exportacao_bi
--------------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2003
--------------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Autor		   : Fabio Cesar Magalhães
--Objetivo	   : Notas Fiscais Canceladas para consultas do BI
--Data             : 22.01.2004
--Atualizado       : 07/07/2004 - Desconsiderar o filtro de tipo de destinatário - ELIAS
--                   08/09/2004 - Passado filtro de cd_tipo_operacao_fiscal = 2 para o vw_faturamento - Daniel C. Neto.
--26.06.2005 - Verificação do Flag da Operação Fiscal para identificar se as Notas Fiscais referente a CFOP
--             devem ser apresentadas na Consulta 
--             Checagem do flag ic_analise_op_fiscal='S' - Carlos Fernandes.
--                 : 31.01.2006  
-------------------------------------------------------------------------------------------

as 

--Critérios
--1. Faturamento Bruto - Todas as notas fiscais
--2. Considerando apenas as notas fiscais que possuem valor comercial

  select
    vw.*
  from
    vw_faturamento vw
    left outer join cliente c       on c.cd_cliente = vw.cd_cliente
    left outer join tipo_mercado tm on tm.cd_tipo_mercado = c.cd_tipo_mercado
  where
    ( vw.ic_comercial_operacao = 'S' )      and     --Considerar apenas as operações fiscais de valor comercial
    ( vw.ic_analise_op_fiscal = 'S' )       and     --Verifica apenas as operações fiscais selecionadas para o BI
    ( vw.cd_tipo_operacao_fiscal = 2 )      and     --Desconsiderar notas de entrada
    isnull(tm.ic_exportacao_tipo_mercado,'N')='S'
    --( vw.cd_tipo_destinatario = 1 )                 --Nota Fiscal de Destinatário para Cliente
    
