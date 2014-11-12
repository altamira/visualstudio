
CREATE PROCEDURE pr_consulta_nota_entrada_fornecedor

--------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2003
--------------------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--------------------------------------------------------------------------------------------------------------------
--Autor(es)		 : Carlos Cardoso Fernandes
--Banco de Dados	 : EGISSQL
--Objetivo		 : Consultar Notas de Entrada por Fornecedor
--Data		      	 : 18/03/2003
--Alteração	    	 : Daniel C. Neto.
--Desc. Alteração	 : Consertado cabeçalho, tirado filtro de nm_comprador is not null.                      
--                         23/09/2003 - Rafael M. Santiago
--			   Colocado para trazer os dados de serviço.
-- 24.05.2005              Revisão - Carlos/Rafael              

--	    	           16/08/2005 - Wellington Souza Fagundes
--                         Acréscimo na consulta com uma tabela denominada Transportadora, tendo uma ligação com a
--                         tabela fornecedor através do campo cd_transportadora e o relacionamento entre a tabela 
--			   Nota_Entrada_Item e Lote_Produto, através do campo cd_lote_produto
--
-- 14.10.2005 - Colocação do Código da CFOP - Carlos Fernandes
-- 14.08.2006 - Consulta de Serviços - Carlos Fernades         
-- 10/10/2006 - Incluido plano de compra e centro de custo - Daniel C. Neto.
-- 07/03/2007 - Incluido para mostar no parametro 3, o destinatário, seja ele cliente ou fornecedor
-- 18.06.2007 - Série/Sub-Série - Carlos Fernandes
-- 23.08.2007 - Verificação de duplicidade - carlos Fernandes
-- 19.12.2007 - Criação de uma coluna com a Quantidade Total dos Produtos - itens da Nota - Carlos Fernandes
-- 23.01.2008 - Mostrar o código do Fornecedor - Carlos Fernandes.
-- 30.01.2008 - Ajustes Gerais - Carlos Fernandes
-- 17.05.2010 - Condição de Pagamento - Carlos Fernandes
-- 21.06.2010 - Ajustes Diversos - Carlos Fernandes
-- 
--------------------------------------------------------------------------------------------------------------------

@ic_parametro          integer     = 0,
@cd_fornecedor         integer     = 0,
@cd_nota_entrada       integer     = 0,
@dt_inicial	       datetime    = 0,
@dt_final 	       datetime    = 0,
@cd_tipo_destinatario  integer     = 0,
@ic_saldo_nota_entrada char(1)     = 'S',
@ic_tipo_pesquisa      char(1)     = 'F',
@nm_fantasia_produto   varchar(50) = ''

AS

--------------------------------------------------------
IF @ic_parametro = 1 /* Consulta Fornecedor */
--------------------------------------------------------
BEGIN 

SELECT
  distinct
  f.cd_fornecedor                 AS 'CodFornecedor',
  f.nm_razao_social	          AS 'Fornecedor',
  f.cd_ddd			  AS 'DDD',
  f.cd_telefone                   AS 'Telefone',
  f.nm_fantasia_fornecedor        AS 'Fantasia',
  ne.dt_nota_entrada              AS 'Emissao',
  ne.cd_nota_entrada              AS 'Nota',
  ne.dt_receb_nota_entrada        AS 'DataEntrada',
  ne.cd_operacao_fiscal           AS 'CodigoCFOP',
  opf.cd_mascara_operacao         as 'CFOP',
  ne.vl_total_nota_entrada        AS 'Total',
  max(co.nm_fantasia_comprador)   AS 'Comprador',
  tr.cd_transportadora	          AS 'CodTransportadora',
  tr.nm_transportadora	          AS 'NomeTransportadora', 
 
  (select COUNT(*)
   from Nota_Entrada_Item x with (nolock) 
   where 
     x.cd_nota_entrada    = ne.cd_nota_entrada and
     x.cd_fornecedor      = ne.cd_fornecedor and
     x.cd_operacao_fiscal = ne.cd_operacao_fiscal)  as 'Itens',

  (select COUNT(cd_documento_pagar)
   from Documento_Pagar x with (nolock) 
   where x.cd_nota_fiscal_entrada = ne.cd_nota_entrada and
         x.cd_fornecedor = ne.cd_fornecedor)     AS 'Duplicatas',

  (select sum ( isnull(x.qt_item_nota_entrada,0) ) 
  from Nota_Entrada_Item x with (nolock) 
  where x.cd_nota_entrada    = ne.cd_nota_entrada and
        x.cd_fornecedor      = ne.cd_fornecedor and
        x.cd_operacao_fiscal = ne.cd_operacao_fiscal)  AS 'Qtd_Itens',
 
  max(isnull(cp.nm_condicao_pagamento,''))             as nm_condicao_pagamento

--select * from nota_entrada_item

FROM
  
   
  Nota_Entrada ne       with (nolock)                                          LEFT OUTER JOIN  
  Fornecedor f          ON ne.cd_fornecedor = f.cd_fornecedor 		       LEFT OUTER JOIN
  
  Transportadora tr     ON f.cd_transportadora = tr.cd_transportadora          LEFT OUTER JOIN
 
  Nota_Entrada_Item nei ON  nei.cd_nota_entrada    = ne.cd_nota_entrada AND
  	  		    nei.cd_fornecedor      = ne.cd_fornecedor AND
		            nei.cd_operacao_fiscal = ne.cd_operacao_fiscal      LEFT OUTER JOIN 

  Pedido_Compra pc      ON nei.cd_pedido_compra  = pc.cd_pedido_compra          LEFT OUTER JOIN 
  Comprador co          ON pc.cd_comprador       = co.cd_comprador              left outer join 
  Operacao_Fiscal opf   ON ne.cd_operacao_fiscal = opf.cd_operacao_fiscal     
  left outer join Condicao_Pagamento cp with (nolock) on cp.cd_condicao_pagamento = ne.cd_condicao_pagamento
 
WHERE
  ((ne.cd_fornecedor = @cd_fornecedor) OR (@cd_fornecedor = 0)) AND
   (ne.dt_receb_nota_entrada BETWEEN @dt_inicial AND @dt_final) and 
    nei.cd_fornecedor = f.cd_fornecedor 

--and 
--    co.nm_fantasia_comprador is not null

GROUP BY
  ne.cd_nota_entrada,
  ne.cd_fornecedor,
  ne.dt_nota_entrada,
  ne.dt_receb_nota_entrada,
  ne.cd_operacao_fiscal,
  opf.cd_mascara_operacao,
  ne.vl_total_nota_entrada,
--  co.nm_fantasia_comprador,
  f.nm_razao_social,
  f.nm_fantasia_fornecedor,
  f.cd_fornecedor,
  f.cd_telefone,
  f.cd_ddd,
  tr.cd_transportadora, 
  tr.nm_transportadora

END

ELSE

--------------------------------------------------------
IF @ic_parametro = 2 /* Consulta Itens Nota */
--------------------------------------------------------
BEGIN

SELECT 
  Distinct
  nei.cd_fornecedor,
  nei.cd_nota_entrada,
  nei.cd_item_nota_entrada,
  nei.qt_item_nota_entrada,
  nei.cd_produto,
  isNull(P.cd_mascara_produto,s.cd_mascara_servico)       as cd_mascara_produto,
  isnull(p.nm_fantasia_produto,s.nm_servico)              as nm_produto_fornecedor,
  --isnull(P.nm_produto,cast(s.ds_servico as Varchar(60)) ) as Desc_Produto,
  nei.nm_produto_nota_entrada                             as Desc_Produto,
  nei.cd_pedido_compra,
  nei.cd_item_pedido_compra,
  nei.vl_item_nota_entrada,
  nei.vl_total_nota_entr_item,
  nei.qt_pesbru_nota_entrada, 
  LP.cd_lote_produto,
  LP.nm_lote_produto,
  cc.nm_centro_custo,
  plc.nm_plano_compra,
  isnull(nei.qt_area_produto,0)                                      as qt_area_produto,
  isnull(nei.qt_area_produto,0) * isnull(nei.qt_item_nota_entrada,0) as qt_total_area

FROM
	Nota_Entrada_Item nei with (nolock) 
	LEFT OUTER JOIN Produto P 		with (nolock) ON nei.cd_produto 	= p.cd_produto  
	LEFT OUTER JOIN Servico s 		with (nolock) ON nei.cd_servico 	= s.cd_servico
	LEFT OUTER JOIN Lote_Produto LP 	with (nolock) ON nei.cd_lote_produto 	= lp.cd_lote_produto 
        left outer join Centro_Custo 	cc 	with (nolock) on cc.cd_centro_custo = nei.cd_centro_custo
        left outer join Plano_Compra 	plc 	with (nolock) on plc.cd_plano_compra = nei.cd_plano_compra

--select * from nota_entrada_item

WHERE
  nei.cd_nota_entrada = @cd_nota_entrada AND
  nei.cd_fornecedor   = @cd_fornecedor

ORDER BY
  nei.cd_item_nota_entrada
END

--------------------------------------------------------
IF @ic_parametro = 3 /* Consulta de Notas do fornecedor para emissão de nota de saida */
--------------------------------------------------------
BEGIN

SELECT 
  Distinct
  identity( int, 1, 1 ) as Item,
  nei.cd_fornecedor, 
  nei.cd_nota_entrada,
  ne.dt_nota_entrada,
  nei.cd_operacao_fiscal,
  op.cd_mascara_operacao,
  op.nm_operacao_fiscal,
  nei.cd_item_nota_entrada,
  nei.qt_item_nota_entrada,
  um.sg_unidade_medida,
  nei.vl_item_nota_entrada,
  nei.vl_total_nota_entr_item,
  nei.cd_produto,
  isNull(P.cd_mascara_produto,s.cd_mascara_servico)                  as cd_mascara_produto,
  isnull(p.nm_fantasia_produto,s.nm_servico)                         as nm_produto_fornecedor,
  nei.nm_produto_nota_entrada,
  isnull(nei.qt_area_produto,0)                                      as qt_area_produto,
  isnull(nei.qt_area_produto,0) * isnull(nei.qt_item_nota_entrada,0) as qt_total_area,

  isnull(nei.qt_item_nota_entrada,0) - (
    select
      isnull(sum(nsi.qt_item_nota_saida),0)
    from
      Nota_Saida_Item nsi     with (nolock) 
      Left Join Nota_Saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
    Where
      nsi.cd_nota_entrada      = nei.cd_nota_entrada      and 
      nsi.cd_item_nota_entrada = nei.cd_item_nota_entrada and
      ns.cd_cliente            = nei.cd_fornecedor        and
      ns.dt_cancel_nota_saida is null
  )                                                                   as qt_saldo_item_nota_entrada,


  isnull(nei.qt_item_nota_entrada,0) - (
    select
      isnull(sum(nsi.qt_item_nota_saida),0)
    from
      Nota_Saida_Item nsi     with (nolock) 
      Left Join Nota_Saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
    Where
      nsi.cd_nota_entrada      = nei.cd_nota_entrada      and 
      nsi.cd_item_nota_entrada = nei.cd_item_nota_entrada and
      ns.cd_cliente            = nei.cd_fornecedor        and
      ns.dt_cancel_nota_saida is null
  )                                                                   as qt_selec_item_nota_entrada,

  ne.nm_serie_nota_entrada,
  ne.nm_especie_nota_entrada

INTO
  #Notas
FROM
  Nota_Entrada_Item nei with (nolock) 
  left outer join Nota_Entrada ne       with (nolock) on ne.cd_nota_entrada       = nei.cd_nota_entrada and
                                                         ne.cd_serie_nota_fiscal  = nei.cd_serie_nota_fiscal
  left outer join Produto P             with (nolock) on nei.cd_produto           = p.cd_produto  
  left outer join Servico s             with (nolock) on nei.cd_servico           = s.cd_servico
  left outer join Lote_Produto LP       with (nolock) on nei.cd_lote_produto      = lp.cd_lote_produto 
  left outer join Centro_Custo 	cc      with (nolock) on cc.cd_centro_custo       = nei.cd_centro_custo
  left outer join Plano_Compra 	plc     with (nolock) on plc.cd_plano_compra      = nei.cd_plano_compra
  left outer join Operacao_Fiscal op    with (nolock) on op.cd_operacao_fiscal    = nei.cd_operacao_fiscal
  left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida     = nei.cd_unidade_medida
--left outer join Serie_Nota_Fiscal snf on snf.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal

WHERE
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
  nei.cd_fornecedor = @cd_fornecedor and
  ne.cd_tipo_destinatario = case 
                              when isnull(@cd_tipo_destinatario,0) = 0 then
                                ne.cd_tipo_destinatario
                              else
                                @cd_tipo_destinatario
                            end 
  and
  ne.dt_nota_entrada between case 
                               when isnull(@cd_nota_entrada,0)=0 then 
                                 @dt_inicial 
                               else 
                                 ne.dt_nota_entrada 
                             end and 
                             case 
                               when isnull(@cd_nota_entrada,0)=0 then 
                                 @dt_final
                               else 
                                 ne.dt_nota_entrada 
                             end and
   nei.cd_nota_entrada = case when isnull(@cd_nota_entrada,0)=0 then nei.cd_nota_entrada else @cd_nota_entrada end
   and isnull(nei.ic_controle_saldo,'S')='S'
ORDER BY
  ne.dt_nota_entrada,
  nei.cd_nota_entrada,
  nei.cd_item_nota_entrada

if isnull(@ic_saldo_nota_entrada,'S') = 'S'
begin
  /* Mostrando Somente as Notas com saldo */
  Select * from #Notas Where qt_saldo_item_nota_entrada > 0
end
else
begin
  /* Mostrando Somente as Notas fechadas */
  Select * from #Notas Where qt_saldo_item_nota_entrada = 0
end

END

