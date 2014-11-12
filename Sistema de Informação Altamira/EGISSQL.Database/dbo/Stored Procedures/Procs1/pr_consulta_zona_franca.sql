------------------------------------------------------------------
--pr_consulta_zona_franca
------------------------------------------------------------------
--GBS - Global Business Solution Ltda                         2004
------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : André Hatiro Asano/Elias
--Banco de Dados       : EGISSQL
--Objetivo             : Consulta de todas as notas fiscais que são emitidas para
--                       Zona Franca de Manaus
--Data                 : 29/10/2002
--Atualizado           : 23/06/2003 - Adição de Campos à Consulta (Parâmetro 1) - DUELA
--                     : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-----------------------------------------------------------------------------------------
create procedure pr_consulta_zona_franca

@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime,
@cd_nota_saida int
as
-------------------------------------------------------------------------------
if @ic_parametro = 1     -- Carrega as informações da nota saída
-------------------------------------------------------------------------------
  begin
    select

--      n.cd_nota_saida		as 'Numero',

      case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
        n.cd_identificacao_nota_saida
      else
        n.cd_nota_saida
      end                       as 'Numero',

      n.dt_nota_saida		as 'Emissao',
      replace(n.cd_mascara_operacao,' ','')+' - '+
      o.nm_operacao_fiscal 	as 'CFOP',
      td.nm_tipo_destinatario,
      vw.nm_fantasia as 'Cliente',
      vw.cd_cnpj,
      tp.nm_tipo_pessoa,
      n.sg_estado_nota_saida 	as 'UF',
      n.vl_total 		as 'VlrTotal',
      d.nm_destinacao_produto 	as 'Destinacao', o.cd_operacao_fiscal
    from
      nota_saida n
    left outer join operacao_fiscal o on
      n.cd_operacao_fiscal = o.cd_operacao_fiscal
    left outer join destinacao_produto d on
      n.cd_destinacao_produto = d.cd_destinacao_produto
    left outer join vw_destinatario vw on
      vw.cd_destinatario=n.cd_cliente and vw.cd_tipo_destinatario=n.cd_tipo_destinatario
    left outer join tipo_destinatario td on
      td.cd_tipo_destinatario=vw.cd_tipo_destinatario
    left outer join tipo_pessoa tp on
      tp.cd_tipo_pessoa=vw.cd_tipo_pessoa
    left outer join estado_parametro p on
      p.cd_estado = vw.cd_estado and
      p.cd_pais = vw.cd_pais
    where
      (p.ic_zona_franca = 'S' and
       n.dt_cancel_nota_saida is null and
       o.ic_zfm_operacao_fiscal = 'S') and 
      (n.dt_nota_saida between @dt_inicial and @dt_final)
    order by
      n.dt_nota_saida desc
  end

-------------------------------------------------------------------------------
else if @ic_parametro = 2     -- Carrega as informações da nota saída itens
-------------------------------------------------------------------------------
  begin
    select
--      nsi.cd_nota_saida 'Nota Saida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                                               as 'Nota Saida',

      nsi.cd_item_nota_saida 'Item',
      nsi.nm_produto_item_nota 'Produto',
      um.sg_unidade_medida 'Unidade',
      nsi.qt_item_nota_saida 'Qtd',
      nsi.vl_unitario_item_nota 'Unitario',
      nsi.vl_total_item 'Total'
    from
      nota_saida_item nsi             with (nolock) 
      inner join nota_saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
      left outer join unidade_medida um on  nsi.cd_unidade_medida = um.cd_unidade_medida
      
    where 
      ns.cd_nota_saida=@cd_nota_saida

    order by nsi.cd_item_nota_saida
  end
else
  return

