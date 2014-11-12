
-------------------------------------------------------------------------------
--pr_controle_produto_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--                   Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 09/12/2006
--Alteração        : 
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_controle_produto_cliente
@cd_cliente int      = 0,
@dt_inicial datetime = '',
@dt_final   datetime = '',
@ic_status  char(1)  = 'T'

as

declare @cd_fornecedor int

--select @cd_fornecedor

--select cd_nota_saida,* from nota_entrada
--select * from nota_entrada_item
--select * from nota_saida_item

select
  f.nm_fantasia_fornecedor                          as Cliente,
  e.cd_nota_entrada                                 as NotaEntrada,
  e.nm_serie_nota_entrada                           as Serie,
  e.dt_receb_nota_entrada                           as Recebimento,
  e.dt_nota_entrada                                 as Entrada,
  ei.cd_item_nota_entrada                           as ItemEntrada,
  ei.nm_produto_nota_entrada                        as DescricaoProduto,
  ei.qt_item_nota_entrada                           as QtdEntrada,
  ei.vl_item_nota_entrada                           as UnitarioEntrada,
  ei.qt_item_nota_entrada * ei.vl_item_nota_entrada as TotalEntrada,
  p.cd_mascara_produto                              as CodigoEntrada,
  p.nm_fantasia_produto                             as FantasiaEntrada,

  --Número da Nota de Saída
  case when isnull(s.cd_identificacao_nota_saida,0)<>0 then
    s.cd_identificacao_nota_saida
  else
    s.cd_nota_saida                              
  end                                               as NotaSaida,

  si.cd_item_nota_saida                             as ItemSaida,
  s.dt_nota_saida                                   as DataSaida,
  si.qt_item_nota_saida                             as QtdSaida,
  si.vl_unitario_item_nota                          as UnitarioSaida,
  si.qt_item_nota_saida * si.vl_unitario_item_nota  as TotalSaida,
  si.nm_fantasia_produto                            as FantasiaSaida,
  ei.qt_item_nota_entrada - si.qt_item_nota_saida   as Saldo,
  vw.nm_fantasia                                    as nm_fantasia_cliente

from
  Nota_Entrada e                      with (nolock) 
  inner join Nota_Entrada_item ei     on ei.cd_fornecedor        = e.cd_fornecedor      and
                                         ei.cd_nota_entrada      = e.cd_nota_entrada    and
                                         ei.cd_operacao_fiscal   = e.cd_operacao_fiscal and
                                         ei.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal
  left outer join Produto p           on p.cd_produto            = ei.cd_produto
  left outer join Nota_Saida s        on s.cd_nota_saida         = e.cd_nota_saida
  left outer join Nota_Saida_Item si  on si.cd_nota_saida        = s.cd_nota_saida and si.cd_produto = ei.cd_produto
  left outer join Fornecedor f        on f.cd_fornecedor         = e.cd_fornecedor
  left outer join operacao_fiscal opf on e.cd_operacao_fiscal    = opf.cd_operacao_fiscal  
  left outer join vw_destinatario vw  on vw.cd_tipo_destinatario = s.cd_tipo_destinatario and 
                                         vw.cd_destinatario      = s.cd_cliente
where
   isnull(e.cd_fornecedor,0) = case @cd_fornecedor when 0  then isnull(e.cd_fornecedor,0) else isnull(@cd_fornecedor,0) end and
   (dbo.fn_data(e.dt_receb_nota_entrada) >= dbo.fn_data(@dt_inicial) and dbo.fn_data(e.dt_receb_nota_entrada)  <= @dt_final) and
   isnull(s.cd_nota_saida,0) = (case @ic_status  
									   when 'A' then
									 	 0 
                              when 'F' then
										 s.cd_nota_saida
									   else 
									    isnull(s.cd_nota_saida,0)
									   end) 
    and opf.ic_retorno_op_fiscal = 'S'    



