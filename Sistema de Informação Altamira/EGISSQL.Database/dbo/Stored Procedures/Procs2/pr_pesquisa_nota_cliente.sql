--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE pr_pesquisa_nota_cliente
--------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Johnny Mendes de Souza
--Banco de Dados	: EGISSQL
--Objetivo		: Pesquisar Notas fiscais por cliente
--Data			: 18/04/2002
--Alteração		: 14/06/2002 - Daniel C. Neto.
--Desc. Alteração	: Correção de cd_operacao_fiscal para cd_mascara_operacao.
--                      : Incluído flag de Carta de Correção, cd_vendedor, cd_vendedor_interno
--                      :  22/04/2003 - Daniel C. Neto.
--                      :  31/07/2003 - Rafael M. Santiago
--                                     Incluido a descrição da Operação Fiscal
--			:  05.09.2003 - Fabio
--				     - Definir o campo tipo destinatário como padrão 1 - Cliente		
--                      :  01/03/2005 - Incluído filtro para considerar apenas as notas com valor comercial.
--                                      ou não. - Daniel C. Neto.
--                      :  10.05.2005 - Ajuste - Carlos Fernandes
--                      :  02/09/2005 - Relacionamento entre as tabelas Nota_Saida - Cliente através do 
--                                      campo cd_cliente, ligação entre as tabelas Cliente - Cliente_Grupo
--                                      através do campo cd_cliente_grupo e inserção do campo nm_cliente_grupo  
--                         06/10/2006 - Incluído nm_centro_custo - Daniel c. Neto.
-- 09.05.2008 - Incluído flag de comercial na procedure e valor do cancelamento - Carlos Fernandes
-- 17.05.2010 - Condição de Pagamento - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------

@cd_cliente           int,
@dt_inicial           datetime,
@dt_final             datetime,
@cd_tipo_destinatario int     = 1,
@ic_valor_comercial   char(1) = ''

AS

 SELECT     
   ns.dt_nota_saida,
--   ns.cd_nota_saida,

   ns.cd_identificacao_nota_saida,

--    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--             ns.cd_identificacao_nota_saida
--           else
--             ns.cd_nota_saida                              
--    end                                   as cd_nota_saida,

   ns.cd_nota_saida,
   ns.dt_saida_nota_saida,
   ofi.nm_operacao_fiscal,
   ofi.cd_mascara_operacao               as 'cd_operacao_fiscal',
   isNull(ofi.ic_comercial_operacao,'N') as 'ic_comercial_operacao',

   --Valor Total da Nota Fiscal
   case when ns.dt_cancel_nota_saida is null 
   then
      isnull(ns.vl_total,0)
   else
      0.00
   end                                   as vl_total,

   --Valor Total do Cancelamento
   case when ns.dt_cancel_nota_saida is not null 
   then
      isnull(ns.vl_total,0)
   else
      0.00
   end                                   as vl_total_cancelamento,

   case when exists ( select top 1 c.* from Carta_Correcao c with (nolock) 
                      where c.cd_nota_saida = ns.cd_nota_saida ) then 'S'
        else 'N' end as 'ic_carta_correcao', 
  Cast(
    (select 
      sum(nsi.qt_item_nota_saida)
    from
      nota_saida_item nsi with (nolock) 
    where
      nsi.cd_nota_saida = ns.cd_nota_saida 
    and 
      nsi.ic_tipo_nota_saida_item = 'P')

   as int) as 'qt_item_nota_saida',
   Case 
     When Len(sn.nm_status_nota) < 2 then 'Normal' 
     Else sn.nm_status_nota
   End as 'nm_status_nota',
   (select count('x') from Documento_Receber x with (nolock) 
                      where x.cd_nota_saida = ns.cd_nota_saida 
                      group by x.cd_nota_saida) as qt_duplicatas,

   (select x.cd_vendedor from Vendedor x with (nolock) left outer join
    Cliente c on c.cd_cliente = ns.cd_cliente and ns.cd_tipo_destinatario = 1
    where x.cd_vendedor = c.cd_vendedor_interno) as cd_vendedor_interno,
 
   (select x.nm_fantasia_vendedor from Vendedor x with (nolock) left outer join
    Cliente c on c.cd_cliente = ns.cd_cliente and ns.cd_tipo_destinatario = 1
    where x.cd_vendedor = c.cd_vendedor_interno) as nm_vendedor_interno,
   ns.cd_vendedor as 'cd_vendedor_externo', 
   (select x.nm_fantasia_vendedor from Vendedor x with (nolock) 
                                  where x.cd_vendedor = ns.cd_vendedor) as nm_vendedor_externo,
   ns.cd_telefone_nota_saida,
   ns.cd_ddd_nota_saida,
   ns.dt_nota_dev_nota_saida    'DataDevolucao',
   Case 
     when ns.dt_nota_dev_nota_saida is null
     Then ''
     Else ns.nm_mot_cancel_nota_saida
   End 'MotivoDevolucao',
 
   ns.dt_cancel_nota_saida      'DataCancelamento',

   Case
     when ns.dt_cancel_nota_saida is null
     Then ''
     Else ns.nm_mot_cancel_nota_saida
   End 'MotivoCancelamento',
   cg.nm_cliente_grupo,
   (select top 1 x.nm_centro_custo
    from Nota_Saida_Parcela nsp with (nolock) inner join
	 Centro_Custo x on x.cd_centro_custo = nsp.cd_centro_custo
    where nsp.cd_nota_saida = ns.cd_nota_saida and
          IsNull(x.nm_centro_custo,'') <> '') as nm_centro_custo,

   isnull(cp.nm_condicao_pagamento,'')        as nm_condicao_pagamento



 FROM
   Nota_Saida ns                         with (nolock)
   left outer join Operacao_Fiscal ofi   with (nolock) on ofi.cd_operacao_fiscal   = ns.cd_operacao_fiscal 
   Left Outer Join Status_Nota sn        with (nolock) on ns.cd_status_nota        = sn.cd_status_nota 
   left outer join Cliente cl            with (nolock) on ns.cd_cliente            = cl.cd_cliente 
   left outer join Cliente_Grupo cg      with (nolock) on cl.cd_cliente_grupo      = cg.cd_cliente_grupo
   left outer join Condicao_Pagamento cp with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
 WHERE
   ns.cd_cliente = @cd_cliente and 
   ns.dt_nota_saida between @dt_inicial and @dt_final and
   ns.cd_tipo_destinatario = @cd_tipo_destinatario and
   isNull(ofi.ic_comercial_operacao,'N') = ( case when @ic_valor_comercial = 'S' then
                                                'S' else isNull(ofi.ic_comercial_operacao,'N') end ) 
 ORDER by
   ns.dt_nota_saida desc, ns.cd_nota_saida desc


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--Executando
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 

-- go
-- exec pr_pesquisa_nota_cliente 
--@cd_cliente           = 666,
--@dt_inicial           = '2001/01/01',
--@dt_final             = '2005/08/11'
--exec dbo.pr_pesquisa_nota_cliente  @cd_cliente = 1798, @dt_inicial = '2005/01/01', @dt_final = '2005/08/31', @cd_tipo_destinatario = 1, @ic_valor_comercial = 'N'
--exec dbo.pr_pesquisa_nota_cliente  @cd_cliente = 13025, @dt_inicial = '2005/01/01', @dt_final = '2005/08/31', @cd_tipo_destinatario = 1, @ic_valor_comercial = 'N'
