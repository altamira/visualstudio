
------------------------------------------------------------------------------------------
--pr_fornecedor_retorno_nota_fiscal
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias P. da Silva
--Banco de Dados: EGISSQL 
--Objetivo      : Listar as Informações do Fornecedor das Notas de Retorno impressas na NF
--Data          : 08/12/2004
--Atualizado    : 06.10.2005 - Acerto do Destinatario - Rafael Santiago
-- 06.02.2009 - Ajuste da Nota Correta - Carlos Fernandes
------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_fornecedor_retorno_nota_fiscal
@ic_parametro        int,
@nm_fantasia_empresa varchar(20),
@cd_nota_fiscal      int

as  

  select 
    distinct
    vw.nm_razao_social                            as 'RAZAO_SOCIAL',
    isnull(vw.nm_endereco,'')+', '+
    isnull(vw.cd_numero_endereco,'')+' '+
    isnull(vw.nm_complemento_endereco,'')+' '+
    isnull(vw.cd_cep,'')                          as 'ENDERECO',
    vw.cd_cnpj                                    as 'CNPJ',
    vw.cd_inscmunicipal                           as 'IE',
    ne.cd_nota_entrada,
    met.cd_nota_entrada,
    met.cd_nota_saida,
    met.cd_tipo_destinatario

--select * from movimento_produto_terceiro where cd_nota_entrada = 164

  from vw_destinatario vw,
       movimento_produto_terceiro met,
       (select m.cd_movimento_origem
        from movimento_produto_terceiro m with (nolock) 
        where m.cd_nota_saida = @cd_nota_fiscal) orig,
       Nota_Entrada ne                
  where 
    met.cd_movimento_produto_terceiro = orig.cd_movimento_origem and

    case when isnull(met.cd_nota_entrada,0) = 0 then 
      met.cd_destinatario 
    else 
      ne.cd_fornecedor
    end = vw.cd_destinatario and

    case when isnull(met.cd_nota_entrada,0) = 0 then 
      met.cd_tipo_destinatario 
    else
      ne.cd_tipo_destinatario 
    end = vw.cd_tipo_destinatario and

    case when isnull(met.cd_nota_entrada,0) = 0 then 
      isnull(met.cd_nota_entrada,0) 
    else
      ne.cd_nota_entrada 
    end = isnull(met.cd_nota_entrada,0)  and

    met.cd_destinatario       = ne.cd_fornecedor
