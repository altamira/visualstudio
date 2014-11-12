
Create procedure pr_consulta_nota_fiscal_cfop
-------------------------------------------------------------------------------
--pr_consulta_nota_fiscal_cfop
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda                                       2004
-------------------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Carlos Cardoso Fernandes
--Banco de Dados      : EGISSQL
--Objetivo            : Consulta de Notas para determinada CFOP com Estado
--Data                : 05.04.2004
--Alteração           : 10/12/2004 Acerto do Cabeçalho - Sérgio Cardoso 
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes
-------------------------------------------------------------------------------
@ic_parametro int,
@cd_operacao_fiscal int,
@sg_estado varchar(20),
@dt_inicial datetime,
@dt_final   datetime
as

  --Resumo de total de notas saidas
  If @ic_parametro = 1
  Begin

    select
     	sg_estado_nota_saida sg_estado,
     	count('x')           as qt_item,
     	sum(vl_total)        as vl_total
    from
     	nota_saida
    where
     	cd_operacao_fiscal = @cd_operacao_fiscal and
     	IsNull(sg_estado_nota_saida,'') <> '' and
     	dt_nota_saida between @dt_inicial and @dt_final
    group by
     	sg_estado_nota_saida
    order by
     	sg_estado_nota_saida

  End Else
  --Resumo de total de notas entradas
  If @ic_parametro = 2
  Begin

    select
     	sg_estado,
     	count('x')                 as qt_item,
     	sum(vl_total_nota_entrada) as vl_total
    from
     	nota_Entrada
    where
     	cd_operacao_fiscal = @cd_operacao_fiscal and
     	IsNull(sg_estado,'') <> '' and
     	dt_nota_entrada between @dt_inicial and @dt_final
    group by
     	sg_estado
    order by
    	sg_estado

  End Else

  --Informações sobre as notas de saida para a CFOP passada
  ------------------------------------------------------------------------------------------
  If @ic_parametro = 3
  Begin

    select 

      case when isnull(cd_identificacao_nota_saida,0)>0 then
         cd_identificacao_nota_saida
      else
         cd_nota_saida                  
      end                                   as 'cd_nota_saida',

--      cd_nota_saida,
      cd_num_formulario_nota,
      dt_nota_saida,
      nm_fantasia_nota_saida,
      cd_destinacao_produto,
      ic_emitida_nota_saida,
      nm_mot_cancel_nota_saida,
      dt_cancel_nota_saida,
      dt_saida_nota_saida,
      cast(round(vl_bc_icms,2) as decimal(25,2)) as vl_bc_icms,
      cast(round(vl_icms,2) as decimal(25,2)) as vl_icms,
      cast(round(vl_bc_subst_icms,2) as decimal(25,2)) as vl_bc_subst_icms,
      cast(round(vl_produto,2) as decimal(25,2)) as vl_produto,
      cast(round(vl_frete,2) as decimal(25,2)) as vl_frete,
      cast(round(vl_seguro,2) as decimal(25,2)) as vl_seguro,
      cast(round(vl_desp_acess,2) as decimal(25,2)) as vl_desp_acess,

	   cast(round((case --Condição
			when exists((Select Top 1 'X' 
		 					 from Nota_saida_item NSI  
	    					 where NSI.cd_operacao_fiscal = @cd_operacao_fiscal and 
             			  		 NSI.cd_nota_saida = Nota_Saida.cd_nota_saida and 
									 NSI.vl_total_item > 0)) then
				--Retorno
				(Select sum(isnull(vl_total_item,0)) 
		 		from Nota_saida_item NSI  
	    		where NSI.cd_operacao_fiscal = @cd_operacao_fiscal and 
             		NSI.cd_nota_saida = Nota_Saida.cd_nota_saida )
         else
      	vl_total
		end),2) as decimal(25,2) )as vl_total,

      cast(round(vl_icms_subst,2) as decimal(25,2)) as vl_icms_subst,
      cast(round(vl_ipi,2) as decimal(25,2)) as vl_ipi,
      (Select top 1 nm_status_nota from status_nota where cd_status_nota = Nota_Saida.cd_status_nota) as nm_status_nota,
      cd_num_formulario,
      cast(round(vl_iss,2) as decimal(25,2)) as vl_iss	,
      cast(round(vl_servico,2) as decimal(25,2)) as vl_servico	,
      nm_razao_social_nota	,
      nm_razao_social_c	,
      cd_mascara_operacao,
      nm_operacao_fiscal	,
      cast(round(vl_irrf_nota_saida,2) as decimal(25,2)) as vl_irrf_nota_saida	,
      nm_fantasia_destinatario	,
      nm_razao_social_cliente	,
      nm_razao_socila_cliente_c	,
      cast(round(vl_bc_ipi,2) as decimal(25,2))	 as vl_bc_ipi,
      (Select top 1 nm_destinacao_produto from Destinacao_Produto where cd_destinacao_produto = Nota_Saida.cd_destinacao_produto) as nm_destinacao_produto,
      ic_forma_nota_saida
    from
      Nota_Saida
    where
      cd_operacao_fiscal = @cd_operacao_fiscal and
      sg_estado_nota_saida = @sg_estado and
      dt_nota_saida between @dt_inicial and @dt_final
    order by
      cd_nota_saida  desc

  End Else 
  --Informações sobre as notas de entrada para a CFOP passada
  if @ic_parametro = 4
  Begin
    select 
      cd_nota_entrada,
      dt_nota_entrada,
      cd_serie_nota_fiscal,
      nm_serie_nota_entrada,
      Nota_Entrada.cd_destinacao_produto,
      ic_emitida_nota_entrada,
      dt_receb_nota_entrada,
      cast(round(vl_bicms_nota_entrada,2) as decimal(25,2)) as vl_bc_icms,
      cast(round(vl_icms_nota_entrada,2) as decimal(25,2)) as vl_icms,
      cast(round(vl_prod_nota_entrada,2) as decimal(25,2)) as vl_produto,
      cast(round(vl_frete_nota_entrada,2) as decimal(25,2)) as vl_frete,
      cast(round(vl_seguro_nota_entrada,2) as decimal(25,2)) as vl_seguro,
      cast(round(vl_despac_nota_entrada,2) as decimal(25,2)) as vl_desp_acess,
	   cast(round((case --Condição
			when exists((Select Top 1 'X' 
		 					 from Nota_entrada_item NEI  
	    					 where NEI.cd_operacao_fiscal = @cd_operacao_fiscal and 
             					 NEI.cd_nota_entrada = Nota_Entrada.cd_nota_entrada and 
									 NEI.vl_total_nota_entr_item > 0)) then
				--Retorno
				(Select sum(isnull(vl_total_nota_entr_item,0)) 
		 		from Nota_entrada_item NEI  
	    		where NEI.cd_operacao_fiscal = @cd_operacao_fiscal and 
             		NEI.cd_nota_entrada = Nota_Entrada.cd_nota_entrada )
         else
      	vl_total_nota_entrada
		end),2) as decimal(25,2) )as vl_total,

      cast(round(vl_ipi_nota_entrada,2) as decimal(25,2)) as vl_ipi,
      cast(round(vl_iss_nota_entrada,2) as decimal(25,2)) as vl_iss,
      cast(round(vl_servico_nota_entrada,2) as decimal(25,2)) as vl_servico,
      nota_entrada.nm_razao_social,
      op.cd_mascara_operacao,
      op.nm_operacao_fiscal,
      cast(round(vl_irrf_nota_entrada,2) as decimal(25,2)) as vl_irrf_nota_saida,
      nm_fantasia_destinatario,
      d.nm_razao_social,
      d.nm_razao_social_complemento,
      cast(round(vl_bipi_nota_entrada,2) as decimal(25,2))	 as vl_bc_ipi,
      (Select top 1 nm_destinacao_produto from Destinacao_Produto where cd_destinacao_produto = Nota_Entrada.cd_destinacao_produto) as nm_destinacao_produto
    from
      Nota_Entrada 
        Left Outer Join
      Operacao_fiscal op
        on Nota_Entrada.cd_operacao_fiscal = op.cd_operacao_fiscal
        left Outer Join
      vw_destinatario d
        on nota_entrada.cd_fornecedor = d.cd_destinatario and
           nota_entrada.cd_tipo_destinatario = d.cd_tipo_destinatario
    where
        Nota_Entrada.cd_operacao_fiscal = @cd_operacao_fiscal and
        Nota_entrada.sg_estado = @sg_estado and
       dt_nota_entrada between @dt_inicial and @dt_final
    order by
      cd_nota_entrada desc

  End

