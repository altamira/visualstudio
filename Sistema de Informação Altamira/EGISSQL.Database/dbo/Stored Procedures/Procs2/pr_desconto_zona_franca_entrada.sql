
CREATE  PROCEDURE pr_desconto_zona_franca_entrada
@ic_parametro int,
@nm_fantasia_empresa varchar(20),
@cd_fornecedor int,
@cd_nota_fiscal int,
@cd_serie_nota_fiscal int

as  

  declare @cd_estado int
  declare @cd_destinacao_produto int
  declare @pc_desconto_icms float
  declare @ic_mostra_icms_corpo_nota char(1)
  
  -- Localiza o Estado do Cliente, o Perc. de Desconto e a Destinação
  select
    @cd_estado = e.cd_estado,
----    @cd_destinacao_produto = n.cd_destinacao_produto,
    @pc_desconto_icms = ep.pc_aliquota_icms_estado,
    @ic_mostra_icms_corpo_nota = ep.ic_mostra_icms_corpo_nota
  from
    Estado e,
    Nota_Entrada n,
    Estado_Parametro ep
  where
    n.cd_fornecedor = @cd_fornecedor and
    n.cd_nota_entrada = @cd_nota_fiscal and
    n.cd_serie_nota_fiscal = @cd_serie_nota_fiscal
    and
----    n.sg_estado_nota_entrada = e.sg_estado and
    e.cd_estado = ep.cd_estado and
    e.cd_pais = 1  -- Brasil  

  -- É listado um Total somente quando Industrialização, Estado é
  -- Zona Franca e ic_mostra_icms_corpo_nota = 'S'
  if (@cd_destinacao_produto = 1) and (@ic_mostra_icms_corpo_nota = 'S') and 
    ((select ic_zona_franca from Estado_Parametro where cd_estado = @cd_estado and cd_pais = 1) = 'S')
    begin

      select
        sum(vl_total_nota_entr_item) 	as 'VALORTOTAL',
        @pc_desconto_icms   	as 'PERCDESC',
        ((sum(vl_total_nota_entr_item)*@pc_desconto_icms)/100)
	    			as 'VALORDESC',
        (sum(vl_total_nota_entr_item) - ((sum(vl_total_nota_entr_item)*@pc_desconto_icms)/100))
	  			as 'TOTALLIQUIDO',
        '----------------'	as 'TRACO1',
        '----------------'      as 'TRACO2',
        'DESC. '+ltrim(str(@pc_desconto_icms,3,0))+'% ICMS ===>' + str(((sum(vl_total_nota_entr_item)*@pc_desconto_icms)/100),25,2) as 'MSGDESCONTO',
        'TOTAL LÍQUIDO ===>' + str((sum(vl_total_nota_entr_item) - ((sum(vl_total_nota_entr_item)*@pc_desconto_icms)/100)),25,2) as 'MSGTOTAL'
      from
        Nota_Entrada_Item
      where
        cd_fornecedor = @cd_fornecedor and
        cd_nota_entrada = @cd_nota_fiscal and
        cd_serie_nota_fiscal = @cd_serie_nota_fiscal

    end
  else
    begin

      select
        null			as 'VALORTOTAL',
	      null			as 'PERCDESC',
      	null			as 'VALORDESC',
      	null			as 'TOTALLIQUIDO',
        null			as 'MSGDESCONTO',
        null			as 'MSGTOTAL',
        null			as 'TRACO1',
        null			as 'TRACO2'
      
    end  

