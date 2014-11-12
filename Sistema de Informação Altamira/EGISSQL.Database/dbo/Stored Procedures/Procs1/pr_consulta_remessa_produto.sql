
-------------------------------------------------------------------------------
--pr_consulta_remessa_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--                   Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Remessa de produtos
--Data             : 09/12/2006
--Alteração        : 28.03.2007 - Acertos Diversos 
--                 : 31.05.2007 - Verificação da Quantidade - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_remessa_produto
@cd_tipo_requisicao   int = 0,
@cd_produto           int = 0,
@cd_tipo_destinatario int = 0,
@cd_destinatario      int = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = '',
@ic_status            char(1)

as


--select * from tipo_requisicao_faturamento
--select * from tipo_destinatario
--select * from requisicao_faturamento
--select * from requisicao_faturamento_item
--select cd_requisicao_faturamento,* from nota_saida

--select * from requisicao_faturamento
--select * from requisicao_faturamento_item
--select * from tipo_destinatario
--select cd_tipo_destinatario,* from nota_saida where cd_nota_saida = 47098
--select * from vendedor

select
  identity(int, 1,1)                as Codigo,
     trf.nm_tipo_requisicao         as 'TipoRemessa',
     rf.cd_requisicao_faturamento   as 'NRequisicao',
     irf.cd_item_req_fat            as 'Item Requisicao',
--     nsi.cd_nota_saida              as 'Nota',

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida                              
  end                                               as 'Nota',


  td.nm_tipo_destinatario        as 'TipoDestinatario',

     case when isnull(rf.nm_fantasia_requisicao_fa,'')<>'' then
        rf.nm_fantasia_requisicao_fa
     else
        case when isnull(ns.nm_fantasia_nota_saida,'')<>'' then
           ns.nm_fantasia_nota_saida
        else
          (case isnull(ns.cd_tipo_destinatario,0)
         when 0 then
	      	''
         when 1 then
	        c.nm_fantasia_cliente
         when 2 then
           f.nm_fantasia_fornecedor
         when 3 then
	        v.nm_fantasia_vendedor
         else
		     'Não Identificado'
         end)
       end
     end                             as Destinatario,

   --select * from requisicao_faturamento where cd_requisicao_faturamento = 223
   --select nm_fantasia_nota_saida,cd_cliente,cd_fornecedor,* from nota_saida where cd_nota_saida = 47628

	(case ns.cd_tipo_destinatario
   when 1 then
		ns.cd_cliente
	when 2 then
		isnull(ns.cd_fornecedor,ns.cd_cliente)
	when 3 then
		ns.cd_vendedor
   else
		0
   end)                                                          as CodigoDestinatario,

   ns.dt_nota_saida                                              as DataNotaSaida,
   irf.cd_produto,
   p.cd_mascara_produto                                          as CodigoProduto,
   p.nm_fantasia_produto                                         as Produto,
   isnull(nsi.nm_produto_item_nota, p.nm_produto)                as DescricaoProduto,
   isnull(irf.qt_requisicao_faturamento,0)                       as QtdRequisicao,
	isnull(nsi.qt_item_nota_saida,irf.qt_requisicao_faturamento)  as QtdNotaSaida,
	nsi.vl_unitario_item_nota                                     as ValorNOtaSaida,
	(nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota)          as TotalNotaSaida,
	ns.dt_nota_saida + isnull(opf.qt_prazo_operacao_fiscal,0)     as PrevisaoRetorno,

 	nei.cd_nota_entrada                                           as NotaEntrada,
 	nei.qt_item_nota_entrada                                      as QtdNotaEntrada,
 	nei.vl_item_nota_entrada                                      as ValorNotaEntrada,
 	(nei.qt_item_nota_entrada * nei.vl_item_nota_entrada)         as TotalNotaEntrada,
   ne.dt_nota_entrada                                            as DataEntrada,
   u.nm_fantasia_usuario                                         as Solicitante,
   opf.cd_mascara_operacao                                       as CFOP,
   opf.nm_operacao_fiscal                                        as DescricaoCFOP 

into #Consulta
from
  	Requisicao_Faturamento rf with (nolock) 
  	left outer join Requisicao_Faturamento_item irf with (nolock) on irf.cd_requisicao_faturamento = rf.cd_requisicao_faturamento
  	left outer join Tipo_Requisicao_faturamento trf with (nolock) on trf.cd_tipo_requisicao        = rf.cd_tipo_requisicao 
  	left outer join Nota_Saida_item nsi             with (nolock) on nsi.cd_requisicao_faturamento             = rf.cd_requisicao_faturamento and irf.cd_item_req_fat = nsi.cd_item_requisicao 
   left join Nota_Saida ns                         with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
   left outer join Operacao_Fiscal opf             with (nolock) on opf.cd_operacao_fiscal        = rf.cd_operacao_fiscal
  	left outer join Produto p                       with (nolock) on p.cd_produto                  = irf.cd_produto
   left outer join Nota_Entrada ne                 with (nolock) on ne.cd_nota_saida              = ns.cd_nota_saida
   left outer join Nota_Entrada_Item nei           with (nolock) on ne.cd_nota_entrada            = nei.cd_nota_entrada  and nei.cd_item_nota_saida = nsi.cd_item_nota_saida 
  	left outer join Cliente c                       with (nolock) on c.cd_cliente                  = ns.cd_cliente
  	left outer join Fornecedor F                    with (nolock) on f.cd_fornecedor               = ns.cd_fornecedor
	left outer join Vendedor V                      with (nolock) on v.cd_vendedor                 = ns.cd_cliente
   left outer join Tipo_Destinatario td            with (nolock) on td.cd_tipo_destinatario       = rf.cd_tipo_destinatario 
   left outer join Egisadmin.dbo.Usuario u         with (nolock) on u.cd_usuario                  = rf.cd_usuario_solicitante

where
--	irf.cd_requisicao_faturamento = 10
	(rf.dt_requisicao_faturamento between @dt_inicial and @dt_final ) and
  	isnull(rf.cd_tipo_requisicao,0) = (case @cd_tipo_requisicao
													when 0 then 
														isnull(rf.cd_tipo_requisicao,0)
													else 
														@cd_tipo_requisicao 
												 	end) and

	isnull(irf.cd_produto  ,0) =(case isnull(@cd_produto,0) 
										  when 0 then
												isnull(irf.cd_produto,0)
										  else
												isnull(@cd_produto,0)
										  end) and

	isnull(@cd_destinatario,0) = (case isnull(@cd_tipo_destinatario,0)
   											when 1 then
													isnull(ns.cd_cliente,0)
												when 2 then
													isnull(ns.cd_fornecedor,ns.cd_cliente)
												when 3 then
													isnull(ns.cd_vendedor,0)
   											else
													0	
  												end) and 

   isnull(ne.cd_nota_entrada,0) = (case @ic_status  
									   when 'A' then
									 	 0 
                              when 'F' then
										 ne.cd_nota_entrada
									   else 
									    isnull(ne.cd_nota_entrada,0)
									   end) 
order by
  rf.cd_requisicao_faturamento,
  irf.cd_item_req_fat


Select  * from #Consulta

Drop Table #Consulta
