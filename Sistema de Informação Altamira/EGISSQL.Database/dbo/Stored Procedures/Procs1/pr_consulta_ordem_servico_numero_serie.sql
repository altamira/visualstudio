create procedure pr_consulta_ordem_servico_numero_serie
@cd_numero_equipto_serie varchar(30),
@dt_Inicial datetime, 
@dt_Final datetime,
@ic_parametro int,
@cd_ordem_servico int
as

if @ic_parametro = 0 --filtro por data
begin
  Select
     sos.nm_status_ordem_servico,
     os.cd_ordem_servico,
     c.nm_fantasia_cliente,  
     t.nm_fantasia_tecnico,
     ns.dt_nota_saida,
     os.ds_def_enc_ordem_servico as ds_tec_enc_ordem_servico,
     os.ds_def_cli_ordem_servico,
     os.vl_total_ordem_servico,     
     nse.cd_numero_equipto_serie,
     dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
     p.qt_dia_garantia_produto,
     (ns.dt_nota_saida + p.qt_dia_garantia_produto) as dt_garantia
  From
     Ordem_Servico os
      left outer join Cliente c on
     c.cd_cliente = os.cd_cliente
      left outer join Tecnico t on
     t.cd_tecnico = os.cd_tecnico
      left outer join Numero_serie_Equipamento nse on
     nse.cd_equipamento_serie = os.cd_equipamento_serie 
      left outer join Nota_Saida ns on
     ns.cd_Nota_saida = nse.cd_nota_saida
      left outer join Status_Ordem_Servico sos on
     sos.cd_status_ordem_servico = os.cd_status_ordem_servico
      left outer join Produto p on
     p.cd_produto = nse.cd_produto
  where
     ns.dt_nota_saida between @dt_Inicial and @dt_Final
  Order By 
     os.cd_ordem_servico

  end
else if @ic_parametro = 1  --filtro por numero de serie
begin
  Select
     sos.nm_status_ordem_servico,
     os.cd_ordem_servico,
     c.nm_fantasia_cliente,  
     t.nm_fantasia_tecnico,
     ns.dt_nota_saida,
     os.ds_def_enc_ordem_servico as ds_tec_enc_ordem_servico,
     os.ds_def_cli_ordem_servico,
     os.vl_total_ordem_servico,     
     nse.cd_numero_equipto_serie,
     dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto,
     p.qt_dia_garantia_produto,
     (ns.dt_nota_saida + p.qt_dia_garantia_produto) as dt_garantia
  From
     Ordem_Servico os
      left outer join Cliente c on
     c.cd_cliente = os.cd_cliente
      left outer join Tecnico t on
     t.cd_tecnico = os.cd_tecnico
      left outer join Numero_serie_Equipamento nse on
     nse.cd_equipamento_serie = os.cd_equipamento_serie 
      left outer join Nota_Saida ns on
     ns.cd_Nota_saida = nse.cd_nota_saida
      left outer join Status_Ordem_Servico sos on
     sos.cd_status_ordem_servico = os.cd_status_ordem_servico
      left outer join Produto p on
     p.cd_produto = nse.cd_produto
  where
      IsNull(nse.cd_numero_equipto_serie,'') =  
      case 
       When isnull(@cd_numero_equipto_serie,'') = '' then 
         isNull(nse.cd_numero_equipto_serie,'') 
       else 
         @cd_numero_equipto_serie
      end
  Order By os.cd_ordem_servico
end
else If @ic_parametro = 2  --dados tabsheet itens
begin
  Select
     osi.cd_item_ordem_servico,
     osi.qt_item_ordem_servico,
     os.cd_ordem_servico,
     osi.nm_servico_produto_item,
     osi.vl_item_ordem_servico
  From
     Ordem_Servico os
       left outer join Ordem_Servico_Item osi on
     osi.cd_ordem_servico = os.cd_ordem_servico
  where
     os.cd_ordem_servico = @cd_ordem_servico 
  Order By osi.cd_item_ordem_servico
end

