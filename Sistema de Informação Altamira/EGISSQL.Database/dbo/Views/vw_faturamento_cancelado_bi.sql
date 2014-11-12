
CREATE VIEW vw_faturamento_cancelado_bi
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2003
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server 2000
--Autor		   : Fabio Cesar Magalhães
--Objetivo	   : Notas Fiscais Canceladas para consultas do BI
--Data             : 22.01.2004
--Atualizado       : 
-- 08/09/2004 - Tirado filtro de cd_tipo_operacao_fiscal = 2 ( Passado para a vw_faturamento_cancelado )
--            - Tirado filtro de destinatario 
--            - Daniel C. Neto.
-- 05.06.2006 - Conceito do Cliente - Carlos Fernandes
-------------------------------------------------------------------------------------------
as 

--Critérios
--2. Considerando apenas as notas fiscais que possuem valor comercial
--3. Considerando apenas as notas fiscais canceldas
--4. Desconsiderando as notas fiscais de entrada

  select
    vw.*
  from
    vw_faturamento_cancelado vw
  where
    ( vw.ic_comercial_operacao = 'S' )      and     --Considerar apenas as operações fiscais de valor comercial
    ( vw.ic_analise_op_fiscal  = 'S' )      and     --Verifica apenas as operações fiscais selecionadas para o BI
    ( vw.cd_tipo_operacao_fiscal = 2 )      --and     --Desconsiderar notas de entrada

--    ( vw.cd_tipo_operacao_fiscal = 2 )  and     --Desconsiderar notas de entrada
--    ( vw.cd_tipo_destinatario = 1 )  
