
CREATE PROCEDURE pr_consulta_documento_emissao_Pagar
--------------------------------------------------------------------------------
-- pr_consulta_documento_emissao_Pagar
--------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                       2004
--------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta informações das duplicatas geradas no sistema
--Data			: 20.03.2003
--Alteração             : Fabio - Desconsiderar no resumo de faturamento x documentos a receber notas canceladas
--                      : 25/03/2003 - Inclusão do Campo Portador que, depois de a stp alterada no dia 20/03, sumiu - ELIAS
--                      : 25/03/2003 - Inclusão do Campo de vl_faturamento_comercial que havia sido incluído em
--                                     versão diferente desta STP na SMC - ELIAS
--                      : 07/07/2004 - Acerto para buscar corretamente o Valor Faturado - ELIAS
--                      : 15/07/2004 - Estava filtrando indevidamente os títulos devolvidos, passa a mostrá-los - ELIAS
--                      : 05/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 01/09/2005 - Relacionamento entre as tabelas Cliente - Cliente_Grupo e acréscimo do campo
--                                     nm_cliente_grupo - WELLINGTON SOUZA FAGUNDES
--                      : 27/01/2006 - Inclusão do  d.dt_cancelamento_documento is null   -  Wilder Mendes de Souza
--                      : 23.03.2007 - Revisão - Carlos Fernandes
-- 20.04.2010 - Coluna do Pedido/Nota Fiscal - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------------
@cd_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

AS

declare @ic_comercial char(1) 

set @ic_comercial = 'S'

If @cd_parametro = 1
Begin

  select

    d.cd_identificacao_document                                    as 'Documento',
    d.dt_emissao_documento_paga                                    as 'Emissao',
    d.dt_vencimento_documento                                      as 'Vencimento',
    cast(str(isnull(d.vl_saldo_documento_pagar,0),25,2)   as numeric(25,2))  as 'Saldo',
    cast(str(isnull(d.vl_documento_pagar,0),25,2) as numeric(25,2))          as 'Valor-Pagar',
--  cast(str(Nota_entrada.vl_total_nota_entrada,25,2) as numeric(25,2))     as 'Vlr-Nfe',
    cast(str(isnull(nep.vl_parcela_nota_entrada,0),25,2) as numeric(25,2))     as 'Vlr-Nfe',
    Nota_entrada.cd_nota_entrada                                   as 'N.Nfe',
--    c.nm_fantasia_fornecedor                                       as 'Destinatario',

    case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
         when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
         when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
         when (isnull(vw.nm_fantasia, '') <> '') then cast(vw.nm_fantasia as varchar(50))  
        end                             as 'Nome-Fornecedor',                 


--    vw.nm_fantasia                                                 as 'Nome-Fornecedor',
   
    Case when isnull(Nota_entrada.vl_total_nota_entrada,0) > isnull(d.vl_documento_pagar,0)then
                     Round(isnull(nep.vl_parcela_nota_entrada,0) - isnull(d.vl_documento_pagar,0),2)
    
         when isnull(d.vl_documento_pagar,0) > isnull(Nota_entrada.vl_total_nota_entrada,0)then   
                    Round(isnull(d.vl_documento_pagar,0) - isnull(nep.vl_parcela_nota_entrada,0),2)
       else
          0 
    end     as 'Dif'


         
    
  from
    documento_pagar d  with (nolock)                     --   d ficou documentos a pagar
    left outer join vw_destinatario vw on vw.cd_destinatario = d.cd_fornecedor and
                                          vw.cd_tipo_destinatario = d.cd_tipo_destinatario
--    left outer join
--    fornecedor c                                         --    c ficou fornecedor
--  on
--    c.cd_fornecedor = d.cd_fornecedor

  left outer join
    Portador p
  on
    p.cd_portador = d.cd_portador
  
  left outer join
    Nota_entrada  

  on
    d.cd_nota_fiscal_entrada = Nota_entrada.cd_nota_entrada      and  	
    --d.cd_operacao_fiscal     = Nota_entrada.cd_operacao_fiscal   and
    d.cd_fornecedor          = Nota_entrada.cd_fornecedor        and
    d.cd_serie_nota_fiscal   = Nota_entrada.cd_serie_nota_fiscal 

  left outer join
    Nota_entrada_parcela nep on  nep.cd_ident_parc_nota_entr = d.cd_identificacao_document and
                                 nep.cd_fornecedor           = d.cd_fornecedor             
  
  where
--  isnull(nota_entrada.cd_nota_entrada,0)<>0 and        
    d.dt_emissao_documento_paga between @dt_inicial and @dt_final and
--  d.cd_cliente = c.cd_cliente                              and
    d.dt_devolucao_documento    is null and
    d.dt_cancelamento_documento is null                      

    -- d.cd_identificacao_document

  order by
     Emissao,
     Documento
  

End

--***********************************************************
--paramentro  = 2
--***********************************************************

If @cd_parametro = 2
Begin

  --Documento pagar
  select
    d.dt_emissao_documento_paga                                       as 'Emissao', 
    count(*)                                                          as 'Documento',
    sum(cast(str(isnull(d.vl_saldo_documento_pagar,0),25,2)  as numeric(25,2))) as 'Saldo',
    sum(cast(str(isnull(d.vl_documento_pagar,0),25,2)        as numeric(25,2))) as 'Valor',
    sum(cast(str(isnull(nep.vl_parcela_nota_entrada,0),25,2) as numeric(25,2))) as 'Vlr-Nfe',
   -- sum(Nota_entrada.cd_nota_entrada)                                 as 'N.Nfe',
    --max(c.nm_fantasia_fornecedor)                                     as 'Nome-Fornecedor',
    
    sum(Case when isnull(Nota_entrada.vl_total_nota_entrada,0) > isnull(d.vl_documento_pagar,0)then
                     Round(isnull(nep.vl_parcela_nota_entrada,0) - isnull(d.vl_documento_pagar,0),2)
    
         when isnull(d.vl_documento_pagar,0) > isnull(Nota_entrada.vl_total_nota_entrada,0)then   
                    Round(isnull(d.vl_documento_pagar,0) - isnull(nep.vl_parcela_nota_entrada,0),2)
       else
          0 
    end)     as 'Dif'    
  
  from
    
    documento_pagar d  with (nolock)                     --   d ficou documentos a pagar
    left outer join
    fornecedor c                                         --    c ficou fornecedor
  on
    c.cd_fornecedor = d.cd_fornecedor

  left outer join
    Portador p
  on
    p.cd_portador = d.cd_portador
  
  left outer join
    Nota_entrada  

  on
    d.cd_nota_fiscal_entrada = Nota_entrada.cd_nota_entrada      and  	
    --d.cd_operacao_fiscal     = Nota_entrada.cd_operacao_fiscal   and
    d.cd_fornecedor          = Nota_entrada.cd_fornecedor        and
    d.cd_serie_nota_fiscal   = Nota_entrada.cd_serie_nota_fiscal 

  left outer join
    Nota_entrada_parcela nep on  nep.cd_ident_parc_nota_entr = d.cd_identificacao_document and
                                 nep.cd_fornecedor           = d.cd_fornecedor             
  
  where
--  isnull(nota_entrada.cd_nota_entrada,0)<>0 and        
    d.dt_emissao_documento_paga between @dt_inicial and @dt_final and
--  d.cd_cliente = c.cd_cliente                              and
    d.dt_devolucao_documento    is null and
    d.dt_cancelamento_documento is null                      

    -- d.cd_identificacao_document

  group by
    d.dt_emissao_documento_paga
  order by
    d.dt_emissao_documento_paga
    --Emissao,
    --Documento
End

--select * from nota_entrada_parcela
-- nota_entrada_parcela        documento_pagar
-->cd_ident_parc_nota_entra == cd_identificacao_document


--------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------
--exec pr_consulta_documento_emissao_Pagar 1,'01/01/2010','12/31/2010'
--------------------------------------------------------------------
 --select 'Dif' = 
--select * from  documento_pagar
--   CASE 
--          WHEN nfe.vl_total_nota_entrada =  0 THEN 'Mfg item - not for resale'
--          WHEN nfe.vl_total_nota_entrada < 50 THEN 'Under $50'
--          WHEN nfe.vl_total_nota_entrada >= 50 and nfe.vl_total_nota_entrada < 250 THEN 'Under $250'
--          WHEN nfe.vl_total_nota_entrada >= 250 and nfe.vl_total_nota_entrada < 1000 THEN 'Under $1000'
--          ELSE 'Over $1000'
--          end as 'tipo',