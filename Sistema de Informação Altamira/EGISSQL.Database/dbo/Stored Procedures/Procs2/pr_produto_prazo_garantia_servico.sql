
-------------------------------------------------------------------------------
--pr_produto_prazo_garantia_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : produtos com Prazo de garantia vencido 
--Data             : 12/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_produto_prazo_garantia_servico
@cd_mascara_produto varchar(30),
@nm_fantasia_produto varchar(20),
@dt_inicial datetime,
@dt_final datetime
AS

Select 
      dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
      p.cd_produto, 
      p.nm_produto, 
      p.nm_fantasia_produto,
      nsi.cd_nota_saida,
      nsi.dt_nota_saida,
      p.qt_dia_garantia_produto,
      ((nsi.dt_nota_saida) + (p.qt_dia_garantia_produto)) as dt_Vencimento,
      ns.ic_dev_nota_saida,
      ns.dt_cancel_nota_saida,
      cast((GETDATE() - ((ns.dt_nota_saida) + (p.qt_dia_garantia_produto))) as int) as Dias,
      o.ic_comercial_operacao

From 
      Produto p left outer join
      Nota_Saida_Item nsi on nsi.cd_produto = p.cd_produto left outer join 
      Nota_Saida ns on ns.cd_nota_saida = nsi.cd_nota_saida left outer join
      Operacao_Fiscal O on o.cd_operacao_fiscal = ns.cd_operacao_fiscal

Where 
     ns.dt_cancel_nota_saida is null and IsNull(ns.ic_dev_nota_saida,'N') = 'N' and o.ic_comercial_operacao = 'S' and
     ns.dt_nota_saida between @dt_inicial and @dt_final and


     IsNull(p.cd_mascara_produto,'') like 
      case 
       when @cd_mascara_produto <> '' then 
         @cd_mascara_produto + '%' 
       else 
         IsNull(p.cd_mascara_produto,'') 
       end


and

      IsNull(p.nm_fantasia_produto,'') like 
      case 
       when @nm_fantasia_produto <> '' then 
         @nm_fantasia_produto + '%'
       else 
         IsNull(p.nm_fantasia_produto,'') 
       end
Order By p.nm_fantasia_produto


