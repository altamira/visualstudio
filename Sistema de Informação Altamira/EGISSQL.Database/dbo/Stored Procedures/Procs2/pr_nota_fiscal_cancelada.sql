
--CREATE PROCEDURE pr_nota_fiscal_cancelada
------------------------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda
------------------------------------------------------------------------------------------------------
-- Stored Procedure : SQL Server
-- Autor(es)        : Fabio
-- Banco de Dados   : EGISSQL
-- Objetivo         : Apresenta informações sobre as Canceladas de Notas Fiscais
-- Data             : 03.02.2003
-- Atualização      : 24/03/2003 - Inclusão deste cabeçalho com histórico das modificaçõs - ELIAS
--                    24/03/2003 - Acerto no parâmetro 3 - Campo de Motivo - ELIAS
--                    02/02/2004 - Inclusão de Novos Campos - Fantasia,Descrição - Chico 
-- 22/04/2004 - Modificado toda a estrutura da procedure - Daniel C. Neto.
--            - Colocado parâmetro para trazer mês corrente, mês anterior e agrupar valores. - Daniel C. Neto.
-- 21/05/2004 - Acertado campos da tabela temporária para permitirem nulos (TODOS CAMPOS) - ELIAS
-- 19/08/2004 - Tirado filtro de dt_nota_saida < @dt_inicial e filtrado
-- por data emissao no faturamento de mês anterior.
-- a própria view vai tratar esses casos. - Daniel C. Neto.
--                     08.09.2004 - Faltou a verificação das quantidades devolvidas e foram feitas alterações na View
--                                  de faturamento pelo Daniel. Igor Gama
-- 16/12/2004 - Modificado filtro de data de emissão para data de devolução. - Daniel C. Neto.
-- 12/01/2005 - Acerto - Daniel C. Neto.
-- 19.02.2009 - Estado do Cliente na Consulta - Carlos Fernandes
-- 16.04.2009 - Ajuste do Veículo/Motorista - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_nota_fiscal_cancelada
@dt_inicial datetime,
@dt_final   datetime

AS

select
--  n.cd_nota_saida		          as 'NotaFiscal',

  case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
            n.cd_identificacao_nota_saida
          else
            n.cd_nota_saida                              
    end                             as 'NotaFiscal',

  n.dt_nota_saida        	    as 'DataNF',
  n.vl_total                        as 'ValorTotal',
  ofi.cd_mascara_operacao	    as 'CFOP',
  n.dt_cancel_nota_saida	    as 'Cancelamento',
  n.nm_mot_cancel_nota_saida  as 'Motivo', 
  t.nm_tipo_destinatario      as 'TipoDestinatario',
  n.nm_fantasia_destinatario  as 'Cliente',
  p.nm_fantasia_vendedor	    as 'Vendedor'
from
  Nota_Saida n                with (nolock)  
  left outer join
  Operacao_Fiscal ofi 
    on ofi.cd_operacao_fiscal = n.cd_operacao_fiscal 
    left outer join
  Vendedor p 
    on n.cd_vendedor = p.cd_vendedor 
    left outer join
  Tipo_Destinatario t on IsNull(n.cd_tipo_destinatario, 7) = t.cd_tipo_destinatario
where
  n.dt_nota_saida between @dt_inicial and @dt_final and
  n.cd_status_nota = 7 --Status de Cancelada
order by
  n.dt_nota_saida desc
  
  
