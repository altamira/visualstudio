CREATE PROCEDURE pr_consulta_classificacao_nota_observacao

@ic_parametro        int,
@cd_Nota_saida       int, 
@cd_estado           int,
@cd_operacao_fiscal  int
AS
Begin

  select distinct
     nsi.cd_item_nota_saida as 'Item',
     prd.cd_dispositivo_legal_IPI as 'DLIPI',
     prd.cd_dispositivo_legal_ICMS as 'DLICMS',
     cf.cd_mascara_classificacao as 'CODIGOCF',
     cast(cfe.pc_redu_icms_class_fiscal as decimal(25,2)) as 'PCREDU' 
  into 
    #ClassProduto
  from
     Nota_Saida_Item nsi
  left outer join Produto_fiscal prd
     on (prd.cd_produto=nsi.cd_produto)
  left outer join classificacao_fiscal cf
     on (cf.cd_classificacao_fiscal=prd.cd_classificacao_fiscal)
  left outer join Dispositivo_Legal dl
     on (dl.cd_dispositivo_legal=cf.cd_dispositivo_legal)
  left outer join Classificacao_Fiscal_Estado cfe
     on (cfe.cd_classificacao_fiscal=cf.cd_classificacao_fiscal)
  left outer join Dispositivo_Legal dluf
     on (dluf.cd_dispositivo_legal=cfe.cd_dispositivo_legal)
  where 
     cfe.cd_estado=@cd_estado and 
     nsi.cd_nota_saida=@cd_nota_saida and
     (prd.cd_dispositivo_legal_IPI is not null or prd.cd_dispositivo_legal_ICMS is not null)

  select distinct
     nsi.cd_item_nota_saida as 'Item',
     cf.cd_dispositivo_legal as 'DLIPI',
     cfe.cd_dispositivo_legal as 'DLICMS',
     cf.cd_mascara_classificacao as 'CODIGOCF',
     cast(cfe.pc_redu_icms_class_fiscal as decimal(25,2)) as 'PCREDU' 
  into 
    #ClassFiscal
  from
     Nota_Saida_Item nsi
  left outer join Produto_fiscal prd
     on (prd.cd_produto=nsi.cd_produto)
  left outer join classificacao_fiscal cf
     on (cf.cd_classificacao_fiscal=prd.cd_classificacao_fiscal)
  left outer join Dispositivo_Legal dl
     on (dl.cd_dispositivo_legal=cf.cd_dispositivo_legal)
  left outer join Classificacao_Fiscal_Estado cfe
     on (cfe.cd_classificacao_fiscal=cf.cd_classificacao_fiscal)
  left outer join Dispositivo_Legal dluf
     on (dluf.cd_dispositivo_legal=cfe.cd_dispositivo_legal)
  where 
     cfe.cd_estado=@cd_estado and 
     nsi.cd_nota_saida=@cd_nota_saida and 
     (cf.cd_dispositivo_legal is not null or cfe.cd_dispositivo_legal is not null)

  select distinct
     nsi.cd_item_nota_saida as 'Item',
     op.cd_dispositivo_legal_IPI as 'DLIPI',
     op.cd_dispositivo_legal_ICMS as 'DLICMS',
     cast(' ' as varchar(30)) as 'CODIGOCF',
     cast(0 as Decimal(25,2)) as 'PCREDU'
  into 
    #ClassOperacao
  from
     Nota_Saida_Item nsi 
     inner join Operacao_fiscal op
     on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal	
  where 
     nsi.cd_nota_saida = @cd_nota_saida and
     (op.cd_dispositivo_legal_IPI is not null or op.cd_dispositivo_legal_ICMS is not null)

  
  Select distinct * 
  into
  #ClassGeral
  from 
  (
  Select * from #ClassProduto
  Union
  Select * from #ClassFiscal
  Union
  Select * from #ClassOperacao
  ) as Uniao


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta 
-------------------------------------------------------------------------------
  begin
     select
	      cg.*,        	
        dl.ds_dispositivo_legal as 'DLDESC'
     from 
        (Select distinct ITEM, DLIPI, 0 as DLICMS, CODIGOCF, PCREDU from #ClassGeral) cg
     left outer join Dispositivo_legal dl
        on (dl.cd_dispositivo_legal=cg.DLIPI)
     where CODIGOCF <> '' and CODIGOCF is not Null and DLIPI is not null
     order by DLIPI, CODIGOCF, ITEM
  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta 
-------------------------------------------------------------------------------
  begin
     select 
        cg.* ,
        dl.ds_dispositivo_legal as 'DLDESC'
     from 
        (Select distinct ITEM, 0 as DLIPI, DLICMS, CODIGOCF, PCREDU from #ClassGeral) cg
     left outer join Dispositivo_legal dl
        on (dl.cd_dispositivo_legal=cg.DLICMS)
     where CODIGOCF <> '' and CODIGOCF is not Null and DLICMS is not null   
     order by DLICMS, CODIGOCF, ITEM
  end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta 
-------------------------------------------------------------------------------
  begin
     select 
        cg.* ,
        dl.ds_dispositivo_legal as 'DLDESC'
     from 
        (Select distinct ITEM, DLIPI, 0 as DLICMS, CODIGOCF, PCREDU from #ClassGeral) cg
     left outer join Dispositivo_legal dl
        on (dl.cd_dispositivo_legal=cg.DLIPI)
     where CODIGOCF = '' or CODIGOCF is Null and DLIPI is not null
     ORDER BY DLIPI ,CODIGOCF, ITEM
  end

-------------------------------------------------------------------------------
if @ic_parametro = 4    -- Consulta 
-------------------------------------------------------------------------------
  begin
     select 
        cg.* ,
        dl.ds_dispositivo_legal as 'DLDESC'
     from 
        (Select distinct ITEM, 0 as DLIPI, DLICMS, CODIGOCF, PCREDU from #ClassGeral) cg
     left outer join Dispositivo_legal dl
        on (dl.cd_dispositivo_legal=cg.DLICMS)
     where CODIGOCF = '' or CODIGOCF is Null and DLICMS is not null
     ORDER BY DLICMS ,CODIGOCF, ITEM
  end
end
