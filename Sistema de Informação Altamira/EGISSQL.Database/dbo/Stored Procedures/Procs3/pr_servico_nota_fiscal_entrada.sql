
CREATE  PROCEDURE pr_servico_nota_fiscal_entrada
@ic_parametro int,
@nm_fantasia_empresa varchar(20),
@cd_fornecedor int,
@cd_nota_fiscal int,
@cd_serie_nota_fiscal int

as

  select
     um.sg_unidade_medida      as 'UNIDSERV',
     nei.qt_item_nota_entrada  as 'QUANTSERV',
     nei.ds_servico            as 'DESCSERV',
     nei.vl_item_nota_entrada  as 'VLUNITSERV',
     nei.vl_iss_servico        as 'VLISS'
  from
     Nota_Entrada_Item nei

     left outer join Unidade_Medida um   
     on nei.cd_unidade_medida = um.cd_unidade_medida

  where
     nei.cd_fornecedor = @cd_fornecedor and
     nei.cd_nota_entrada = @cd_nota_fiscal and
     nei.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
     nei.ic_tipo_nota_entrada_item = 'S'

