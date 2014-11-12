CREATE PROCEDURE pr_registro_nota_entrada
@ic_parametro int,
@dt_inicial datetime,
@dt_final   datetime,
@cd_nota_entrada int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- consulta das Notas Fiscais do período
-------------------------------------------------------------------------------
  begin

    select
      nr.cd_nota_entrada	  as 'Numero',
      ne.dt_nota_entrada          as 'DtEmissao',
      opf.nm_operacao_fiscal      as 'CFOP',
      vw.nm_fantasia	          as 'Cliente',
      vw.nm_razao_social          as 'RazaoSocial',
      td.nm_tipo_Destinatario     as 'Tipo_Destinatario',
      cast('NFF' as varchar(25))  as 'Especie' -- Copiado da pr_livro_registro_saida
    from
      Nota_Entrada ne
    inner join Nota_Entrada_Registro nr on
      ne.cd_nota_entrada = nr.cd_nota_entrada
    left outer join vw_Destinatario vw on
      vw.cd_destinatario=ne.cd_fornecedor and vw.cd_tipo_destinatario=ne.cd_tipo_destinatario
    left outer join Tipo_Destinatario td on
      td.cd_tipo_destinatario=ne.cd_tipo_destinatario
    left outer join Operacao_Fiscal opf on
      opf.cd_operacao_fiscal=nr.cd_operacao_fiscal
    where
      (nr.cd_nota_entrada = @cd_nota_entrada) or 
      ((@cd_nota_entrada = 0) and
       (ne.dt_nota_entrada between @dt_inicial and @dt_final))
    group by
      nr.cd_nota_entrada,
      ne.dt_nota_entrada,
      opf.nm_operacao_fiscal,
      vw.nm_fantasia,
      vw.nm_razao_social,
      td.nm_tipo_destinatario
    order by ne.dt_nota_entrada
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- consulta Operações da Nota de Saída p/ Número
-------------------------------------------------------------------------------
  begin
    select
      ner.cd_operacao_fiscal, 
      ner.cd_rem, 
      ner.cd_nota_entrada,
      ner.vl_total_rem
    from   
      Nota_Entrada_Registro ner
    where  
      ner.cd_nota_entrada = @cd_nota_entrada
  end
else
  return



