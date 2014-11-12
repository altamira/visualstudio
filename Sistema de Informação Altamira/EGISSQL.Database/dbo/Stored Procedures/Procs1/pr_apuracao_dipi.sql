CREATE PROCEDURE pr_apuracao_dipi
@ic_parametro int,
@cd_ano       int,
@cd_usuario		int

as


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Geração da DIPI Destinatário
-------------------------------------------------------------------------------
  begin

    -- 1 - Leitura da tabela de Nota de Saída
    -- 2 - Agrupamento por ano e cliente
    -- 3 - Somatório dos valores para preenchimento de todos os campos da tabela
    --     Dipi_Destinatatio

    -- Apagar registros que já existam para o ano de processamento
    delete from
      Dipi_Destinatario
    where
      cd_ano = @cd_ano

    insert into Dipi_Destinatario 
     (cd_ano,
      cd_cliente,
      cd_tipo_destinatario,
      vl_nota_saida_dipi,
      cd_usuario, 
      dt_usuario)    
    select 
      top 150
      @cd_ano,
      n.cd_cliente,
      n.cd_tipo_destinatario,
      (round(sum(isnull(ns.vl_base_ipi_item_nota,0)),2) +
       round(sum(isnull(ns.vl_ipi_isento_item_nota,0)),2)+
       round(sum(isnull(ns.vl_ipi_outras_item_nota,0)),2)) as 'VlrApurado',
      @cd_usuario,
      getDate()
    from
      Nota_Saida_Item_Registro ns
    inner join
      Nota_Saida n     
    on
      n.cd_nota_saida = ns.cd_nota_saida
    left outer join
      Operacao_Fiscal opf
    on 
      opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    where
      year(n.dt_nota_saida) = @cd_ano and
      isnull(ns.ic_servico_item_nota,'N') = 'N' and
      isnull(ns.ic_cancelada_item_nota,'N') = 'N' and
      ns.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = 2  and -- SAIDA
      isnull(opf.ic_dipi_operacao_fiscal,'N') = 'S'
    group by
      n.cd_cliente,
      n.cd_tipo_destinatario
    order by
      (round(sum(isnull(ns.vl_base_ipi_item_nota,0)),2) +
       round(sum(isnull(ns.vl_ipi_isento_item_nota,0)),2)+
       round(sum(isnull(ns.vl_ipi_outras_item_nota,0)),2)) desc

    -- A ordem desta instrução insert into select foi comentada porque a tabela
    -- Dipi_Destinatário contem a chave primária composta dos campos
    -- cd_ano e cd_cliente e CLUSTERED o que impede a gravação na tabela na ordem
    -- que seria a ordem de consulta. Ao consultar os resultados desta tabela
    -- ordená-la por vl_nota_saida_dipi desc. - ELIAS
    -- Verificar qual flag será lido na tabela operacao_fiscal para filtrar corretamente - ELIAS

  end  -- if parametro 1

-------------------------------------------------------------------------------
else if @ic_parametro = 2    -- Geração da DIPI Remetente
-------------------------------------------------------------------------------
  begin

    delete from
      Dipi_Remetente
    where
      cd_ano = @cd_ano

    -- ENTRADAS EFETUADAS PELO RECEBIMENTO
    select 
      ne.cd_fornecedor 	as 'Fornecedor',
      isnull(ne.cd_tipo_destinatario,0) as 'Tipo',
      (round(sum(isnull(neir.vl_bipi_reg_nota_entrada,0)),2)+
       round(sum(isnull(neir.vl_ipiisen_reg_nota_entr,0)),2)+
       round(sum(isnull(neir.vl_ipioutr_reg_nota_entr,0)),2)) as 'VlrNotaEntrada'
    into
      #DIPI_Remetente_NF_Entrada
    from
      Nota_Entrada_Item_Registro neir
    left outer join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = neir.cd_nota_entrada and
      ne.cd_fornecedor = neir.cd_fornecedor and
      ne.cd_operacao_fiscal = neir.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal 
		left outer join
			Operacao_Fiscal opf
		on
			opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    where
      year(ne.dt_receb_nota_entrada) = @cd_ano and
      isnull(opf.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      isnull(opf.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  and -- ENTRADAS
      isnull(opf.ic_dipi_operacao_fiscal,'N') = 'S'
    group by
      ne.cd_fornecedor,
      ne.cd_tipo_destinatario
    order by
      (round(sum(isnull(neir.vl_bipi_reg_nota_entrada,0)),2)+
       round(sum(isnull(neir.vl_ipiisen_reg_nota_entr,0)),2)+
       round(sum(isnull(neir.vl_ipioutr_reg_nota_entr,0)),2)) desc


    -- ENTRADAS EFETUADAS PELO FATURAMENTO

    select 
      n.cd_cliente,
      n.cd_tipo_destinatario,
      (round(sum(isnull(ns.vl_base_ipi_item_nota,0)),2) +
       round(sum(isnull(ns.vl_ipi_isento_item_nota,0)),2)+
       round(sum(isnull(ns.vl_ipi_outras_item_nota,0)),2)) as 'VlrNotaEntrada'
    into
      #DIPI_Remetente_NF_Saida
    from
      Nota_Saida_Item_Registro ns
    inner join
      Nota_Saida n      
    on
      n.cd_nota_saida = ns.cd_nota_saida
    left outer join
      Operacao_Fiscal opf
    on 
      opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    where
      year(n.dt_nota_saida) = @cd_ano and
      isnull(ns.ic_servico_item_nota,'N') = 'N' and
      isnull(ns.ic_cancelada_item_nota,'N') = 'N' and
      ns.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = 1  and -- ENTRADA
      isnull(opf.ic_dipi_operacao_fiscal,'N') = 'S'
    group by
      n.cd_cliente,
      n.cd_tipo_destinatario
    order by
      (round(sum(isnull(ns.vl_base_ipi_item_nota,0)),2) +
       round(sum(isnull(ns.vl_ipi_isento_item_nota,0)),2)+
       round(sum(isnull(ns.vl_ipi_outras_item_nota,0)),2)) desc

    insert into #DIPI_Remetente_NF_Entrada
    select * from #DIPI_Remetente_NF_Saida

    insert into Dipi_Remetente
     (cd_ano,
      cd_fornecedor,
      cd_tipo_destinatario,
      vl_nota_entrada_dipi,
      cd_usuario, 
      dt_usuario)    
    select
      top 150
      @cd_ano,
      Fornecedor,
      Tipo,
      sum(VlrNotaEntrada),
      @cd_usuario,
      getDate()
    from
      #DIPI_Remetente_NF_Entrada
    group by
      Fornecedor,
      Tipo    
    order by
      sum(VlrNotaEntrada) desc


  end  -- if parametro 2
-------------------------------------------------------------------------------
else if @ic_parametro = 3    -- Geração da DIPI apuração
-------------------------------------------------------------------------------
  begin

    -- Apaga os registro do ano
    delete from
      Dipi_Apuracao
    where
      cd_ano = @cd_ano

    -- Debito IPI
    select 
      @cd_ano			as 'Ano',
      month(n.dt_nota_saida)	as 'Mes',
      case when (day(n.dt_nota_saida) <= 10) then 1 else
        case when (day(n.dt_nota_saida) > 10) and (day(n.dt_nota_saida) <= 20) then 2 else
          case when (day(n.dt_nota_saida) > 20) then 3 end
        end
      end			as 'Decendio',
      isnull(ns.vl_ipi_item_nota_saida,0)	as 'DebitoIPI',
      isnull(ns.vl_ipi_obs_item_nota,0)   as 'ObsDebitoIPI'
    into
      #DIPI_Debito
    from
      Nota_Saida n
    inner join
      Nota_Saida_Item_Registro ns
    on
      n.cd_nota_saida = ns.cd_nota_saida
    left outer join
      Operacao_Fiscal opf
    on 
      opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    where
      year(n.dt_nota_saida) = @cd_ano and
      isnull(ns.ic_servico_item_nota,'N') = 'N' and
      isnull(ns.ic_cancelada_item_nota,'N') = 'N' and
      ns.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = 2  and -- SAIDA
      isnull(opf.cd_categoria_dipi,0) <> 0

    -- Credito IPI
    select 
      @cd_ano			as 'Ano',
      month(ne.dt_receb_nota_entrada)	as 'Mes',
      case when (day(ne.dt_receb_nota_entrada) <= 10) then 1 else
        case when (day(ne.dt_receb_nota_entrada) > 10) and (day(ne.dt_receb_nota_entrada) <= 20) then 2 else
          case when (day(ne.dt_receb_nota_entrada) > 20) then 3 end
        end
      end			as 'Decendio',
      isnull(neir.vl_ipi_reg_nota_entrada,0)	as 'CreditoIPI',
      0 as 'ObsCreditoIPI'
    into
      #DIPI_Credito
    from
      Nota_Entrada_Item_Registro neir
    left outer join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = neir.cd_nota_entrada and
      ne.cd_fornecedor = neir.cd_fornecedor and
      ne.cd_operacao_fiscal = neir.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = neir.cd_serie_nota_fiscal 
		left outer join
			Operacao_Fiscal opf
		on
			opf.cd_operacao_fiscal = ne.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    where
      year(ne.dt_receb_nota_entrada) = @cd_ano and
      isnull(opf.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      isnull(opf.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  and -- ENTRADAS
      isnull(opf.cd_categoria_dipi,0) <> 0

    -- Agrupando as Tabelas
    select
      Ano,
      Mes,
      Decendio,
      sum(CreditoIPI) as 'CreditoIPI',
      sum(ObsCreditoIPI) as 'ObsCreditoIPI'
    into
      #DIPI_Credito_Agrupado
    from
      #DIPI_Credito
    group by
      Ano,
      Mes,
      Decendio

    select
      Ano,
      Mes,
      Decendio,
      sum(DebitoIPI) as 'DebitoIPI',
      sum(ObsDebitoIPI) as 'ObsDebitoIPI'
    into
      #DIPI_Debito_Agrupado
    from
      #DIPI_Debito
    group by
      Ano,
      Mes,
      Decendio

    insert into
      Dipi_Apuracao(cd_ano,
	                  cd_mes,
                    cd_descendio_dipi,
                    vl_deb_ipi_dipi,
                    vl_deb_obs_ipi_dipi,
                    vl_cred_ipi_dipi,
                    vl_cred_obs_ipi_dipi,
                    dt_inicial_dipi,
                    dt_final_dipi,
                    cd_usuario,
                    dt_usuario)  

    select
      case when c.Ano is null then d.Ano else c.Ano end,
      case when c.Mes is null then d.Mes else c.Mes end,
      case when c.Decendio is null then d.Decendio else c.Decendio end,
      d.DebitoIPI,
      d.ObsDebitoIPI,
      c.CreditoIPI,
      c.ObsCreditoIPI,
      getdate(),
      getdate(),
      @cd_usuario,
      getdate()
    from
      #DIPI_Debito_Agrupado d
    full outer join
      #DIPI_Credito_Agrupado c
    on
      d.Ano 	   = c.Ano and
      d.Mes 	   = c.Mes and
      d.Decendio = c.Decendio
           		
  end -- if parametro 3


-------------------------------------------------------------------------------
else if @ic_parametro = 4    -- Geração da DIPI ENTRADAS/Classificação fiscal
-------------------------------------------------------------------------------

  begin
    delete from
      Dipi_Classificacao_Fiscal
    where
      (cd_ano = @cd_ano) and (ic_tipo_ipi = 'E')

    -- ENTRADAS EFETUADAS PELO RECEBIMENTO
    select
      isnull(isnull(nei.cd_classificacao_fiscal, pf.cd_classificacao_fiscal),0) as 'ClassFiscal',
      round(sum(isnull(nei.vl_total_nota_entr_item,0)),2) as 'VlrContabil'
    into
      #Dipi_Classificacao_Fiscal_NF_Entrada
    from
      Nota_Entrada_Item nei
    left outer join
      Nota_Entrada_Item_Registro neir
		on
			nei.cd_fornecedor 				= neir.cd_fornecedor and
			nei.cd_nota_entrada 			= neir.cd_nota_entrada and
			nei.cd_operacao_fiscal		= neir.cd_operacao_fiscal and
			nei.cd_serie_nota_fiscal	= neir.cd_serie_nota_fiscal
		left outer join
			Nota_Entrada ne 				-- para pegar a data dt_nota_entrada
		on
			ne.cd_fornecedor 				= neir.cd_fornecedor and
			ne.cd_nota_entrada 			= neir.cd_nota_entrada and
			ne.cd_operacao_fiscal		= neir.cd_operacao_fiscal and
			ne.cd_serie_nota_fiscal	= neir.cd_serie_nota_fiscal
    left outer join
			Operacao_Fiscal opf
		on
			opf.cd_operacao_fiscal = neir.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join
      Produto_Fiscal pf
    on
      nei.cd_produto = pf.cd_produto
    where
      year(ne.dt_receb_nota_entrada) = @cd_ano and
      isnull(opf.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      isnull(opf.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  and -- ENTRADAS
      isnull(opf.ic_dipi_operacao_fiscal,'N') = 'S'
    group by
      nei.cd_classificacao_fiscal,
      pf.cd_classificacao_fiscal

    -- ENTRADAS EFETUADAS PELO FATURAMENTO
    select
      isnull(isnull(nsi.cd_classificacao_fiscal, pf.cd_classificacao_fiscal),0) as 'ClassFiscal',
      round(sum(isnull(nsi.vl_total_item,0)),2) as 'VlrContabil'
    into
      #Dipi_Classificacao_Fiscal_NF_Saida
    from
      Nota_Saida_Item nsi
    left outer join
      Nota_Saida ns -- para pegar a data  dt_nota_saida
    on
      ns.cd_nota_saida = nsi.cd_nota_saida
    left outer join
      Operacao_Fiscal opf
    on
      opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join
      Produto_Fiscal pf
    on
      nsi.cd_produto = pf.cd_produto
    where
      year(ns.dt_nota_saida) = @cd_ano and
      gop.cd_tipo_operacao_fiscal = 1  and -- ENTRADAS
      isnull(opf.ic_dipi_operacao_fiscal,'N') = 'S'
    group by
      nsi.cd_classificacao_fiscal,
      pf.cd_classificacao_fiscal

    insert into #Dipi_Classificacao_Fiscal_NF_Entrada
    select * from #Dipi_Classificacao_Fiscal_NF_Saida

    insert into Dipi_Classificacao_Fiscal
     (cd_ano,
      cd_classificacao_fiscal,
      ic_tipo_ipi,
      vl_classif_fiscal_dipi,
      cd_usuario,
      dt_usuario)     
    select 
      top 100
      @cd_ano,
      ClassFiscal,
      'E',
      sum(VlrContabil),
      @cd_usuario,
      getDate()
    from
      #Dipi_Classificacao_Fiscal_NF_Entrada     
    group by 
      ClassFiscal
    order by
      sum(VlrContabil) desc

  end -- if parametro 4


-------------------------------------------------------------------------------
else if @ic_parametro = 5    -- Geração da DIPI SAIDAS/Classificação fiscal
-------------------------------------------------------------------------------
begin
    delete from
      Dipi_Classificacao_Fiscal
    where
      (cd_ano = @cd_ano) and (ic_tipo_ipi = 'S')

    insert into
      Dipi_Classificacao_Fiscal
    select
      top 100
      @cd_ano,
      isnull(isnull(nsi.cd_classificacao_fiscal, pf.cd_classificacao_fiscal),0) as 'ClassFiscal',
      'S' ic_tipo_ipi,
      round(sum(isnull(nsi.vl_total_item,0)),2),
      @cd_usuario,
      getDate()
    from
      Nota_Saida_Item nsi
    left outer join
      Nota_Saida ns -- para pegar a data  dt_nota_saida
    on
      ns.cd_nota_saida = nsi.cd_nota_saida
    left outer join
      Operacao_Fiscal opf
    on
      opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = opf.cd_grupo_operacao_fiscal
    left outer join
      Produto_Fiscal pf
    on
      nsi.cd_produto = pf.cd_produto
    where
      year(ns.dt_nota_saida) = @cd_ano and
      gop.cd_tipo_operacao_fiscal = 2  and -- SAIDA
      isnull(opf.ic_dipi_operacao_fiscal,'N') = 'S'
    group by
      isnull(isnull(nsi.cd_classificacao_fiscal, pf.cd_classificacao_fiscal),0)
    order by
      round(sum(isnull(nsi.vl_total_item,0)),2) desc

  end -- if parametro 5
-------------------------------------------------------------------------------
else if @ic_parametro = 6  -- Listar a DIPI p/ Destinatario
-------------------------------------------------------------------------------
  begin

    select
      top 150
      d.cd_ano,
      d.cd_cliente,
      vw.nm_fantasia as nm_fantasia_cliente,
      vw.cd_cnpj as cd_cnpj_cliente,
      vw.nm_razao_social as nm_razao_social_cliente,
      d.vl_nota_saida_dipi
    from
      Dipi_Destinatario d
    left outer join
      vw_destinatario_rapida vw
    on
      vw.cd_destinatario = d.cd_cliente and
      vw.cd_tipo_destinatario = d.cd_tipo_destinatario
    where
      cd_ano = @cd_ano
    order by 
      vl_nota_saida_dipi desc


  end -- If @ic_parametro = 6

--------------------------------------------------------------------------------------------
else if @ic_parametro = 7  -- Listar a DIPI p/ Remetente
--------------------------------------------------------------------------------------------
  begin

    select 
       top 150
       r.cd_ano,
       r.cd_fornecedor,
       vw.nm_fantasia as nm_fantasia_fornecedor,
       vw.nm_razao_social,
       vw.cd_cnpj as cd_cnpj_fornecedor ,
       r.vl_nota_entrada_dipi
    from
       Dipi_Remetente r
    left outer join
       vw_destinatario_rapida vw
    on
       vw.cd_destinatario = r.cd_fornecedor and
       vw.cd_tipo_destinatario = r.cd_tipo_destinatario
    where
      cd_ano = @cd_ano
    order by 
      r.vl_nota_entrada_dipi desc

 end -- If @ic_parametro = 7

--------------------------------------------------------------------------------------------
else if @ic_parametro = 8  -- Listar a DIPI p/ SAIDA
--------------------------------------------------------------------------------------------
  begin

    select
      top 100
      dcf.cd_ano,
      cf.nm_classificacao_fiscal,
      cf.cd_mascara_classificacao,
      dcf.ic_tipo_ipi,
      dcf.vl_classif_fiscal_dipi,
      dcf.cd_classificacao_fiscal
    from
      Dipi_Classificacao_Fiscal dcf
    left outer join
      Classificacao_Fiscal cf
    on
      cf.cd_classificacao_fiscal=dcf.cd_classificacao_fiscal
    where
      (dcf.ic_tipo_ipi = 'S') and 
      cd_ano = @cd_ano
    order by 
      dcf.vl_classif_fiscal_dipi desc

 end -- end @ic_parametro = 8

--------------------------------------------------------------------------------------------
else if @ic_parametro = 9  -- Listar a DIPI p/ ENTRADAS
--------------------------------------------------------------------------------------------
  begin

    select
      top 100
      dcf.cd_ano,
      cf.nm_classificacao_fiscal,
      cf.cd_mascara_classificacao,
      dcf.ic_tipo_ipi,
      dcf.vl_classif_fiscal_dipi,
      dcf.cd_classificacao_fiscal
    from
      Dipi_Classificacao_Fiscal dcf
    left outer join
      Classificacao_Fiscal cf
    on
      cf.cd_classificacao_fiscal = dcf.cd_classificacao_fiscal
    where
     (dcf.ic_tipo_ipi = 'E')
     and cd_ano = @cd_ano

    order by dcf.vl_classif_fiscal_dipi desc

 end -- end @ic_parametro = 9

--------------------------------------------------------------------------------------------
else if @ic_parametro = 10  -- Listar a Apuração do Saldo do IPI
--------------------------------------------------------------------------------------------
  begin
    select * from dipi_apuracao
    where cd_ano = @cd_ano
  end -- end if @ic_parametro = 10
else
  return





