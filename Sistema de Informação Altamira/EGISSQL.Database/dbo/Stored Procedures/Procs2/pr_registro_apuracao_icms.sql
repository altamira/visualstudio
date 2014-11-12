
create procedure pr_registro_apuracao_icms
@cd_tipo_operacao int,        --1 : entrada / 2 : Saída / 3: Apuração
@dt_inicial       datetime,
@dt_final         datetime

as
  --select * from operacao_fiscal

  -- ENTRADAS

  if (@cd_tipo_operacao = 1)
  begin

    --Entradas geradas na Saída

    select
      max(gop.nm_grupo_operacao_fiscal)  			as 'Grupo',
      max(op.cd_mascara_operacao) 				as 'Codificacao',
      max(op.nm_operacao_fiscal)        			as 'Natureza',
      sum(round(isnull(r.vl_contabil_item_nota,0),2))		as 'ValorContabil',
      sum(round(isnull(r.vl_base_icms_item_nota,0),2))		as 'BaseCalculo',	
      sum(round(isnull(r.vl_icms_item_nota_saida,0),2))	  	as 'ImpostoCreditado',
      sum(round(isnull(r.vl_icms_isento_item_nota,0),2))	as 'Isentas',
      sum(round(isnull(r.vl_icms_outras_item_nota,0),2))	as 'Outras',
      sum(round(isnull(r.vl_icms_obs_item_nota,0),2))		as 'Observacao'

    into 
      #EntradaSaida
 
    from
      Nota_Saida_Item_Registro r                                with (nolock) 
      left outer join Operacao_Fiscal op                        with (nolock) on op.cd_operacao_fiscal = r.cd_operacao_fiscal
      left outer join Grupo_Operacao_Fiscal gop                 with (nolock) on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      r.dt_nota_saida between @dt_inicial and @dt_final and
      --isnull(r.ic_servico_item_nota,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      r.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = @cd_tipo_operacao -- ENTRADA NO FATURAMENTO
      --17.09.2010 - carlos.
      and isnull(ic_destaca_vlr_livro_op_f,'S')='S'
    group by
      gop.nm_grupo_operacao_fiscal,
      op.cd_mascara_operacao
    order by
      op.cd_mascara_operacao,
      gop.nm_grupo_operacao_fiscal 

    --Entradas

    select
      max(gop.nm_grupo_operacao_fiscal)  			as 'Grupo',
      max(op.cd_mascara_operacao)				as 'Codificacao',
      max(op.nm_operacao_fiscal)        			as 'Natureza',
      sum(round(isnull(ni.vl_cont_reg_nota_entrada,0),2)) 	as 'ValorContabil',
      sum(round(isnull(ni.vl_bicms_reg_nota_entrada,0),2))      as 'BaseCalculo',
      sum(round(isnull(ni.vl_icms_reg_nota_entrada,0),2))       as 'ImpostoCreditado',
      sum(round(isnull(ni.vl_icmsisen_reg_nota_entr,0),2))	as 'Isentas',
      sum(round(isnull(ni.vl_icmsoutr_reg_nota_entr,0),2))      as 'Outras',
      sum(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2))       as 'Observacao'
    into
      #Entrada
    from
      Nota_Entrada_Item_Registro ni with (nolock) 
    inner join
      Nota_Entrada ne               with (nolock) 
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
      left outer join Operacao_Fiscal op        with (nolock) on op.cd_operacao_fiscal = ni.cd_operacao_fiscal
      left outer join Grupo_Operacao_Fiscal gop with (nolock) 
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      -- ELIAS 10/02/2004
      -- (isnull(ni.vl_icms_reg_nota_entrada,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      --isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = @cd_tipo_operacao  -- ENTRADAS
      --17.09.2010 - carlos.
      and isnull(ic_destaca_vlr_livro_op_f,'S')='S'

    group by
      gop.nm_grupo_operacao_fiscal,
      op.cd_mascara_operacao
    order by
      op.cd_mascara_operacao,
      gop.nm_grupo_operacao_fiscal

    insert into #Entrada
     select * from #EntradaSaida

    select
      *
    from
      #Entrada
    order by
      Codificacao,
      Grupo
    
  end

  -- SAÍDAS

  else if (@cd_tipo_operacao = 2)
  begin

    select
      max(gop.nm_grupo_operacao_fiscal)  			as 'Grupo',
      max(op.cd_mascara_operacao) 				as 'Codificacao',
       max(op.nm_operacao_fiscal)        			as 'Natureza',
      sum(round(isnull(r.vl_contabil_item_nota,0),2))		as 'ValorContabil',
      sum(round(isnull(r.vl_base_icms_item_nota,0),2))		as 'BaseCalculo',	
      sum(round(isnull(r.vl_icms_item_nota_saida,0),2))	  	as 'ImpostoCreditado',
      sum(round(isnull(r.vl_icms_isento_item_nota,0),2))	as 'Isentas',
      sum(round(isnull(r.vl_icms_outras_item_nota,0),2))	as 'Outras',
      sum(round(isnull(r.vl_icms_obs_item_nota,0),2))		as 'Observacao'

    from
      Nota_Saida_Item_Registro r                with (nolock) 
    left outer join
      Operacao_Fiscal op                        with (nolock) 
    on
      op.cd_operacao_fiscal = r.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop                 with (nolock) 
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      r.dt_nota_saida between @dt_inicial and @dt_final and
      --isnull(r.ic_servico_item_nota,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      r.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = @cd_tipo_operacao -- SAIDA
      --17.09.2010 - carlos.
      and isnull(ic_destaca_vlr_livro_op_f,'S')='S'
    group by
      gop.nm_grupo_operacao_fiscal,
      op.cd_mascara_operacao
    order by
      op.cd_mascara_operacao,
      gop.nm_grupo_operacao_fiscal

  end

  -- APURACAO_ICMS

  else if (@cd_tipo_operacao = 3)
  begin

    select
      sum(round(isnull(ni.vl_icms_reg_nota_entrada,0),2))       as 'ImpostoCreditado'
    into
      #Apuracao_icms_cred
    from
      Nota_Entrada_Item_Registro ni          with (nolock) 
    inner join
      Nota_Entrada ne                        with (nolock) 
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada    and
      ne.cd_fornecedor        = ni.cd_fornecedor      and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op                     with (nolock) 
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop              with (nolock) 
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      -- ELIAS 10/02/2003
      -- (isnull(ni.vl_icms_reg_nota_entrada,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      --isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      --17.09.2010 - carlos.
      and isnull(op.ic_destaca_vlr_livro_op_f,'S')='S'

    --ENTRADAS da Nota De Saída ( Importação )

    select
      sum(round(isnull(r.vl_icms_item_nota_saida,0),2))	  	as 'ImpostoCreditado'
    into
      #Apuracao_icms_cred_saida
    from
      Nota_Saida_Item_Registro r             with (nolock) 
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = r.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      r.dt_nota_saida between @dt_inicial and @dt_final and
      --isnull(r.ic_servico_item_nota,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      r.cd_mascara_operacao is not null and   
      gop.cd_tipo_operacao_fiscal = 1 -- ENTRADA
      --17.09.2010 - carlos.
      and isnull(op.ic_destaca_vlr_livro_op_f,'S')='S'


    select
      sum(round(isnull(r.vl_icms_item_nota_saida,0),2))	  	as 'ImpostoDebitado'
    into
      #Apuracao_icms_deb
    from
      Nota_Saida_Item_Registro r             with (nolock) 
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = r.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      r.dt_nota_saida between @dt_inicial and @dt_final and
      --isnull(r.ic_servico_item_nota,'N') = 'N' and
      isnull(r.ic_cancelada_item_nota,'N') = 'N' and
      r.cd_mascara_operacao is not null and
      gop.cd_tipo_operacao_fiscal = 2 -- SAIDA

      --17.09.2010 - carlos.
      and isnull(op.ic_destaca_vlr_livro_op_f,'S')='S'

    select 
        isnull(cred.ImpostoCreditado,0)      +
        isnull(cred_saida.ImpostoCreditado,0)  as 'vl_credito_icms',
	deb.ImpostoDebitado                    as 'vl_debito_icms'
    from
       #Apuracao_icms_cred       cred,
       #Apuracao_icms_deb        deb,
       #Apuracao_icms_cred_saida cred_saida


  end

