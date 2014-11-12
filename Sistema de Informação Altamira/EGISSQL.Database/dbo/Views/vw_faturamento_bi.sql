
CREATE VIEW vw_faturamento_bi
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
--14.03.2006 - Tipo de Mercado                   
--21.04.2006 - Cidade - Carlos Fernandes
--12.04.2010 - Ajuste p/ Conversão de Moeda - Carlos Fernandes
-------------------------------------------------------------------------------------------

as 

--Critérios
--1. Faturamento Bruto - Todas as notas fiscais
--2. Considerando apenas as notas fiscais que possuem valor comercial
--select * from status_nota

  select
    *
  from
    vw_faturamento vw

  where
    ( vw.ic_comercial_operacao = 'S' )      and     --Considerar apenas as operações fiscais de valor comercial
    ( vw.ic_analise_op_fiscal  = 'S' )      and     --Verifica apenas as operações fiscais selecionadas para o BI
    ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

    --( vw.cd_tipo_destinatario = 1 )                 --Nota Fiscal de Destinatário para Cliente
--    and vw.cd_status_nota <> 7 --nao filtra notas canceladas
    
