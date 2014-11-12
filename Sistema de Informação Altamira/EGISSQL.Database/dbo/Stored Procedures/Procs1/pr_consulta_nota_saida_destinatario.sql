
--sp_helptext pr_consulta_nota_saida_destinatario

CREATE PROCEDURE pr_consulta_nota_saida_destinatario

----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2007
----------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
----------------------------------------------------------------------------------------------------
--Autor(es)		 : Carlos Cardoso Fernandes
--Banco de Dados	 : EGISSQL
--Objetivo		 : Consultar Notas de Saída por Destinatário
--Data		      	 : 16.06.2007
--Alteração	    	 : Carlos Fernandes
--Desc. Alteração	 : 28.10.2007 - Verificação - Carlos Fernandes
-- 17.05.2010 - Condição de Pagamento - Carlos Fernandes
-- 11.11.2010 - Ajuste da Nota - Carlos Fernandes
-- 07.12.2010 - Ajustes Diversos - Carlos / Fagner
--------------------------------------------------------------------------------------------------------------------

@ic_parametro          integer     = 0,
@cd_cliente            integer     = 0,
@cd_nota_saida         integer     = 0,
@dt_inicial	       datetime    = 0,
@dt_final 	       datetime    = 0,
@cd_tipo_destinatario  integer     = 0,
@ic_saldo_nota_saida   char(1)     = 'S',
@ic_tipo_pesquisa      char(1)     = 'F',
@nm_fantasia_produto   varchar(50) = ''

AS

---------------------------------------------------------------------------------------------
IF @ic_parametro = 3 /* Consulta de Notas do Cliente para emissão de nota de saida */
---------------------------------------------------------------------------------------------
BEGIN

--select * from nota_saida_item

SELECT 
  Distinct
  identity( int, 1, 1 )                         as Item,
  0                                             as ic_selecionado,
  ns.cd_identificacao_nota_saida,
  nsi.cd_nota_saida,
  ns.dt_nota_saida,
  nsi.cd_operacao_fiscal,
  op.cd_mascara_operacao,
  op.nm_operacao_fiscal,
  nsi.cd_item_nota_saida,
  nsi.qt_item_nota_saida,
  um.sg_unidade_medida,
  nsi.vl_unitario_item_nota,
  nsi.vl_total_item,
  isNull(p.cd_mascara_produto  ,s.cd_mascara_servico)                as cd_produto,
  isnull(p.nm_fantasia_produto,s.nm_servico)                         as nm_produto,
  nsi.nm_produto_item_nota,

  --Saldo dos Itens

  isnull(nsi.qt_item_nota_saida,0) - (
    select
      isnull(sum(onsi.qt_item_nota_saida),0)
    from
      Nota_Saida_Item onsi with (nolock) 
      Inner Join Nota_Saida ons on ons.cd_nota_saida = onsi.cd_nota_saida 
    Where
      onsi.cd_nota_saida_origem      = nsi.cd_nota_saida and 
      onsi.cd_item_nota_origem = nsi.cd_item_nota_saida  and
      ons.dt_cancel_nota_saida is null
  )                                                                 as qt_saldo_item_nota_saida,

  isnull(nsi.qt_item_nota_saida,0) - (
    select
      isnull(sum(onsi.qt_item_nota_saida),0)
    from
      Nota_Saida_Item onsi
      Left Join Nota_Saida ons on ons.cd_nota_saida = onsi.cd_nota_saida
    Where
      onsi.cd_nota_saida_origem      = nsi.cd_nota_saida and 
      onsi.cd_item_nota_origem = nsi.cd_item_nota_saida  and      ons.dt_cancel_nota_saida is null
  )                                                                as qt_selec_item_nota_saida,

  isnull(nsi.cd_nota_saida_origem,0)  as cd_nota_saida_origem,
  isnull(nsi.cd_item_nota_origem,0)   as cd_item_nota_origem

--select * from nota_saida_item

INTO
  #Notas

FROM
  Nota_Saida_Item nsi                   with (nolock) 
  left outer join Nota_Saida ns         with (nolock) on ns.cd_nota_saida         = nsi.cd_nota_saida                  
  left outer join Produto P             with (nolock) on nsi.cd_produto           = p.cd_produto  
  left outer join Servico s             with (nolock) on nsi.cd_servico           = s.cd_servico
  left outer join Operacao_Fiscal op    with (nolock) on op.cd_operacao_fiscal    = nsi.cd_operacao_fiscal
  left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida     = nsi.cd_unidade_medida

WHERE
  isnull(op.ic_saldo_op_fiscal,'N')    = 'S' and --Controle de Saldo
  case
    when isnull(@ic_tipo_pesquisa,'F') = 'F' then p.nm_fantasia_produto
    when isnull(@ic_tipo_pesquisa,'F') = 'C' then p.cd_mascara_produto
    when isnull(@ic_tipo_pesquisa,'F') = 'D' then p.nm_produto
  end like
  case
    when isnull(@ic_tipo_pesquisa,'F') = 'F' then case when isnull(@nm_fantasia_produto,'')='' then p.nm_fantasia_produto else @nm_fantasia_produto end
    when isnull(@ic_tipo_pesquisa,'F') = 'C' then case when isnull(@nm_fantasia_produto,'')='' then p.cd_mascara_produto else @nm_fantasia_produto end
    when isnull(@ic_tipo_pesquisa,'F') = 'D' then case when isnull(@nm_fantasia_produto,'')='' then p.nm_produto else @nm_fantasia_produto end
  end + '%' and
  ns.cd_cliente = @cd_cliente and
  ns.cd_tipo_destinatario = case 
                              when isnull(@cd_tipo_destinatario,0) = 0 then
                                ns.cd_tipo_destinatario
                              else
                                @cd_tipo_destinatario
                            end 
  and
  ns.dt_nota_saida between case 
                               when isnull(@cd_nota_saida,0)=0 then 
                                 @dt_inicial 
                               else 
                                 ns.dt_nota_saida
                             end and 
                             case 
                               when isnull(@cd_nota_saida,0)=0 then 
                                 @dt_final
                               else 
                                 ns.dt_nota_saida 
                             end and

   nsi.cd_nota_saida = case when isnull(@cd_nota_saida,0)=0 then nsi.cd_nota_saida else @cd_nota_saida end

ORDER BY
  ns.dt_nota_saida,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida

if isnull(@ic_saldo_nota_saida,'S') = 'S'
begin
  /* Mostrando Somente as Notas com saldo */
  Select * from #Notas Where qt_saldo_item_nota_saida > 0 --order by item
end
else
begin
  /* Mostrando Somente as Notas fechadas */
  Select * from #Notas Where qt_saldo_item_nota_saida = 0 --order by item
end

END

