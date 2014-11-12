

CREATE   PROCEDURE pr_produto_nota_fiscal_entrada
-------------------------------------------------------------------------------
--GBS - Global Business Solution
-------------------------------------------------------------------------------
--Autor     : Eduardo Baião
--Objetivo  : Retornar os Dados dos Produtos das Notas de Entrada
--            Baseada em "pr_produto_nota_fiscal"
--Data      : 07/08/2003
--Alteracao : 07/08/2003
--
-------------------------------------------------------------------------------
@ic_parametro         int,
@nm_fantasia_empresa  varchar(20),
@cd_fornecedor        int,
@cd_nota_fiscal       int,
@cd_serie_nota_fiscal int
as

  Select
     dbo.fn_formata_mascara((select g.cd_mascara_grupo_produto
                             from Grupo_Produto g, Produto pr
                             where pr.cd_produto = nei.cd_produto
                                   and
                                   g.cd_grupo_produto = pr.cd_grupo_produto),
                            (select pr.cd_mascara_produto
                             from   Produto pr
                             where  pr.cd_produto = nei.cd_produto)) as 'CODIGO', 

     p.nm_fantasia_produto as 'FANTASIA',
     cast(nei.nm_produto_nota_entrada as varchar(100)) as 'DESCRICAO',

     c.cd_mascara_classificacao                  as 'CLASSFISCAL',
     nei.cd_situacao_tributaria                  as 'SITTRIB',
     u.sg_unidade_medida		                     as 'UNIDADE',
     IsNull(nei.qt_item_nota_entrada,0)          as 'QUANTIDADE',
     cast(IsNull(nei.vl_item_nota_entrada,0) as decimal(25,2))          as 'UNITARIO',
     cast(IsNull(nei.vl_total_nota_entr_item,0) as decimal(25,2))       as 'VLTOTALITEM',
     str(IsNull(nei.pc_icms_nota_entrada,0),2,0) as 'VLALIQICMS',
     str(IsNull(nei.pc_ipi_nota_entrada,0),2,0)  as 'VLALIQIPI',
     IsNull(nei.vl_ipi_nota_entrada,0)	         as 'VLIPIITEM',
----     dbo.fn_produto_localizacao(nei.cd_produto,nei.cd_fase_produto) as 'LOCALIZACAO',	  
     cast(null as integer) as 'LOCALIZACAO',
----     str(isnull(nei.qt_saldo_estoque,0),8,0)     as 'SALDOESTOQUE',
     cast('' as char(1)) as 'SALDOESTOQUE',
     nei.cd_produto

  From
     Nota_Entrada_Item nei with (nolock) 

     left outer join Produto p with (nolock) 
                on p.cd_produto = nei.cd_produto

     left outer join Classificacao_Fiscal c with (nolock) 
                on c.cd_classificacao_fiscal = nei.cd_classificacao_fiscal

     left outer join Unidade_Medida u with (nolock) 
                on nei.cd_unidade_medida = u.cd_unidade_medida

  Where
     nei.cd_fornecedor = @cd_fornecedor and
     nei.cd_nota_entrada = @cd_nota_fiscal and
     nei.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
     nei.ic_tipo_nota_entrada_item = 'P'

