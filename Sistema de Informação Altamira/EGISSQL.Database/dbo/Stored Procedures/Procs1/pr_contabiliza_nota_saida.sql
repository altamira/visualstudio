
CREATE PROCEDURE pr_contabiliza_nota_saida
------------------------------------------------------------------------------ 
--GBS - Global Business Solution              2002 
------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        : Carlos Cardoso Fernandes.
--Banco de Dados   : EGISSQL 
--Objetivo         : Contabilização de Nota de Saída.
--Data             : 30/05/2003 
--Atualizado       : Eduardo - 08/07/2003 - Acertos estéticos e melhora na performance
--                 : 14/07/2003 - Carlos
--                 : 16/07/2003 - Arredondamento de valores float - ELIAS
--                 : 21/08/2003 - Inclusão do Campo SMO no Analítico - ELIAS
--                 : 26/08/2003 - Modificação do filtro do lançamento padrão que utilizava o campo
--                                de nome do lançamento, filtrando por %NF, para trazer somente
--                                o de tipo Nota Fiscal - ELIAS
--                   21/07/2004 - Arredondamento de Valores - ELIAS
-- 28.05.2008 - Incluir o Pis/Cofins - Carlos Fernandes
------------------------------------------------------------------------------ 

@ic_parametro  int,
@dt_inicial    datetime,
@dt_final      datetime

as

SET LOCK_TIMEOUT 15000
--------------------------------------------------------
if  @ic_parametro = 1 --Contabilização Analitíco
--------------------------------------------------------
begin

	-----------------------------------------------
	-- Traz Notas de Saída sem conta
	-----------------------------------------------
	select
		cast('- SEM VALOR CONTABIL' as varchar(40))        as Nome_Lancamento_Padrao,
		cast('10' as varchar(20))                          as Mascara_Lancamento_Padrao,
		cast(null as varchar(10))                          as Reduzido_Lancamento_Padrao,
		0                                                  as cd_conta_plano,
		cast(nsc.cd_nota_saida as varchar(10))             as Documento,
		nsc.nm_fantasia_destinatario                       as Cliente,
		nsc.dt_contab_nota_saida                           as DataContabilizacao,
		opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal as Operacao_Fiscal,
		opf.nm_operacao_fiscal                             as Operacao_Fiscal_Nome,
		opf.cd_mascara_operacao                            as Operacao_Fiscal_Mascara,
                /* ELIAS 16/07/2003 */
		sum(cast(round(isnull(nsc.vl_contab_nota_saida,0),2) as decimal(25,2)))              as ValorTotal,
		sum(cast(round(isnull(nsc.vl_ipi_nota_saida,0),2)    as decimal(25,2)))              as ValorIPI,
		sum(cast(round(isnull(nsc.vl_icms_nota_saida,0),2)   as decimal(25,2)))              as ValorICMS,
		sum(cast(round(isnull(nsc.vl_pis_nota_saida,0),2)    as decimal(25,2)))              as ValorPIS,
		sum(cast(round(isnull(nsc.vl_cofins_nota_saida,0),2) as decimal(25,2)))              as ValorCOFINS

	into	#ContabilRazaoSemConta 

	from
		Nota_Saida_Contabil nsc with (nolock) 
		left outer join Lancamento_Padrao lp on nsc.cd_lancamento_padrao = lp.cd_lancamento_padrao
		left outer join Operacao_Fiscal opf  on opf.cd_operacao_fiscal=nsc.cd_operacao_fiscal
	where
		(nsc.dt_contab_nota_saida between @dt_inicial and @dt_final) and
		(isnull(nsc.cd_lancamento_padrao,0)= 0)
	group by 
		cast(nsc.cd_nota_saida as varchar(10)),
		nsc.nm_fantasia_destinatario,                       
		nsc.dt_contab_nota_saida,
		opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal,
		opf.nm_operacao_fiscal,
		opf.cd_mascara_operacao

        order by
             Documento

	------------------------------------------------
	-- Traz Notas de Saída com conta
	------------------------------------------------
		
	--Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
	--restruturação da lógica empregada nos outros procedimentos
		
	Select 
		nsc.cd_lancamento_padrao,
		nsc.cd_conta_credito,
		nsc.cd_nota_saida,
		nsc.dt_contab_nota_saida,
		nsc.cd_tipo_destinatario,
                nsc.cd_cliente,
                nsc.nm_fantasia_destinatario,
		nsc.cd_operacao_fiscal,
                /* ELIAS 16/07/2003 */  
		sum(cast(round(isnull(vl_contab_nota_saida,0),2) as decimal(25,2))) as vl_contab_nota_saida,
		sum(cast(round(isnull(vl_ipi_nota_saida,0),2) as decimal(25,2)))    as vl_ipi_nota_saida,
		sum(cast(round(isnull(vl_icms_nota_saida,0),2) as decimal(25,2)))   as vl_icms_nota_saida,
		sum(cast(round(isnull(vl_pis_nota_saida,0),2)    as decimal(25,2)))              as vl_pis_nota_saida,
		sum(cast(round(isnull(vl_cofins_nota_saida,0),2) as decimal(25,2)))              as vl_cofins_nota_saida


	Into	#ContabilRazaoComContaBase

	From
		Nota_Saida_Contabil nsc
		inner join Lancamento_Padrao lp on
		nsc.cd_lancamento_padrao = lp.cd_lancamento_padrao

	Where
		(nsc.dt_contab_nota_saida between @dt_inicial and @dt_final) and
		(isnull(nsc.cd_lancamento_padrao,0)<>0)

	Group by
		nsc.cd_lancamento_padrao,
		nsc.cd_conta_credito,
		nsc.cd_nota_saida,
		nsc.dt_contab_nota_saida,
		nsc.cd_tipo_destinatario,
		nsc.cd_cliente,
                nsc.nm_fantasia_destinatario,
		nsc.cd_operacao_fiscal

	select distinct

		--Retorna o nome da conta

		cast('- '+
			(Select nm_conta from Plano_conta
  			where  cd_conta =
				(Select top 1 cd_conta_credito
				from	Lancamento_Padrao 
				where   cd_lancamento_padrao = 
					(select top 1 lanc.cd_lancamento_padrao
					from    Lancamento_Padrao lanc
					where   cd_conta_plano = lp.cd_conta_plano and
                                        cd_tipo_contabilizacao = 1))) as varchar(40)) as 'Nome_Lancamento_Padrao',
--				      RTrim(lanc.nm_lancamento_padrao) like '%NF%')))  as varchar(40)) as 'Nome_Lancamento_Padrao',

		--Retorna a mascara da conta

		cast((	Select	cd_mascara_conta
			from	Plano_conta
			where	cd_conta = 
				(Select top 1 cd_conta_credito 
				from    Lancamento_Padrao
				where   cd_lancamento_padrao = 
					(select top 1 lanc.cd_lancamento_padrao
					from    Lancamento_Padrao lanc
					where   cd_conta_plano = lp.cd_conta_plano and
                                        cd_tipo_contabilizacao = 1))) as varchar(20)) as 'Mascara_Lancamento_Padrao',
--						RTrim(lanc.nm_lancamento_padrao) like '%NF%'))) as varchar(20)) as 'Mascara_Lancamento_Padrao',

		--Código reduzido da conta débito

		cast((	Select	cd_conta_reduzido
			from	Plano_conta
			where	cd_conta =
				(Select top 1 cd_conta_debito
				from	Lancamento_Padrao
				where	cd_lancamento_padrao =
					(select top 1 lanc.cd_lancamento_padrao
					from	Lancamento_Padrao lanc
					where	cd_conta_plano = lp.cd_conta_plano and
                                        cd_tipo_contabilizacao = 1))) as varchar(10)) as 'Reduzido_Lancamento_Padrao',
--						RTrim(nm_lancamento_padrao) like '%NF%'))) as varchar(10)) as 'Reduzido_Lancamento_Padrao',

		isNull(lp.cd_conta_plano,0)		as cd_conta_plano,
		cast(nsc.cd_nota_saida as varchar(10))	as 'Documento',
		nsc.nm_fantasia_destinatario            as 'Cliente',
		nsc.dt_contab_nota_saida              	as 'DataContabilizacao',
		opf.cd_mascara_operacao+'-'+opf.nm_operacao_fiscal as 'Operacao_Fiscal',
		opf.nm_operacao_fiscal                 	as 'Operacao_Fiscal_Nome',
		opf.cd_mascara_operacao			as 'Operacao_Fiscal_Mascara',
                /* ELIAS 16/07/2003 */ 
		cast(round(nsc.vl_contab_nota_saida,2) as decimal(25,2))               	as 'ValorTotal',
		cast(round(nsc.vl_icms_nota_saida,2) as decimal(25,2))               	as 'ValorICMS',
		cast(round(nsc.vl_ipi_nota_saida,2) as decimal(25,2))               	as 'ValorIPI',
		cast(round(isnull(nsc.vl_pis_nota_saida,0),2)    as decimal(25,2))      as 'ValorPIS',
		cast(round(isnull(nsc.vl_cofins_nota_saida,0),2) as decimal(25,2))      as 'ValorCOFINS'


	-------
	Into	#ContabilRazaoComConta 
	-------

	from
		#ContabilRazaoComContaBase nsc
		inner join Lancamento_Padrao lp on
		nsc.cd_lancamento_padrao = lp.cd_lancamento_padrao
		left outer join Tipo_Contabilizacao t on
		lp.cd_tipo_contabilizacao = t.cd_tipo_contabilizacao
		left outer join Operacao_Fiscal opf on
		opf.cd_operacao_fiscal=nsc.cd_operacao_fiscal

		
	-- Unir a temporária das sem conta com as que possuem contas
	Insert 
	into	#ContabilRazaoSemConta

		(Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_conta_plano,
		Documento,
		Cliente,
		DataContabilizacao,
		Operacao_Fiscal,
		Operacao_Fiscal_Nome,
		Operacao_Fiscal_Mascara,
		ValorTotal,
		ValorICMS,
		ValorIPI,
                ValorPIS,
                ValorCofins)
	select
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_conta_plano,
		Documento,
		Cliente,
		DataContabilizacao,
		Operacao_Fiscal,
		Operacao_Fiscal_Nome,
		Operacao_Fiscal_Mascara,
		sum(IsNull(ValorTotal,0))  as ValorTotal,
		sum(IsNull(ValorICMS,0))   as ValorICMS,
		sum(isNull(ValorIPI,0))    as ValorIPI,
                sum(isnull(ValorPIS,0))    as ValorPIS,
                sum(isnull(ValorCOFINS,0)) as ValorCOFINS


	from	#ContabilRazaoComConta 

	group by
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,   
		cd_conta_plano,
		Documento,
		Cliente,
		DataContabilizacao,
		Operacao_Fiscal,
		Operacao_Fiscal_Nome,
		Operacao_Fiscal_Mascara
		
	--Define o nome do lancamento em função da contabilização da CFOP

	Update	#ContabilRazaoSemConta 
	set	Nome_Lancamento_Padrao = '- ' + Left(Operacao_Fiscal_Nome,28),
		Mascara_Lancamento_Padrao = ' CFOP: ' + left(Operacao_Fiscal_Mascara,15)
	where	IsNull(Nome_Lancamento_Padrao,'') = ''		
		
	Select
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,   
		cd_conta_plano,
		Documento,
		Cliente,
		DataContabilizacao,
		Operacao_Fiscal,
		Operacao_Fiscal_Nome,
		Operacao_Fiscal_Mascara,
		sum(IsNull(ValorTotal,0)) as ValorTotal,
		sum(IsNull(ValorICMS,0))  as ValorICMS,
		sum(isNull(ValorIPI,0))   as ValorIPI, 
                sum(isnull(ValorPIS,0))    as ValorPIS,
                sum(isnull(ValorCOFINS,0)) as ValorCOFINS,
                isnull(pv.ic_smo_pedido_venda,'N')    as 'SMO' 
	from 
		#ContabilRazaoSemConta left outer join
                Nota_Saida n on n.cd_nota_saida = Documento left outer join
                Pedido_Venda pv on n.cd_pedido_venda = pv.cd_pedido_venda
	group by 
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,   
		cd_conta_plano,
		Documento,
		Cliente,
		DataContabilizacao,
		Operacao_Fiscal,
		Operacao_Fiscal_Nome,
		Operacao_Fiscal_Mascara,
                pv.ic_smo_pedido_venda
	order by 
		Reduzido_Lancamento_Padrao,
    Mascara_Lancamento_Padrao, 
    Nome_Lancamento_Padrao, 
    cast(IsNull(Documento,0) as integer)

end
--------------------------------------------------------
else if  @ic_parametro = 2 --Contabilização Sintético
--------------------------------------------------------
begin

	-----------------------------------------------
	-- Traz Notas de Saída sem conta
	-----------------------------------------------
	select
		cast('- SEM VALOR CONTABIL' as varchar(40)) as 'Nome_Lancamento_Padrao',
		cast(' ' as varchar(20))              as 'Mascara_Lancamento_Padrao',
		cast(null as varchar(10))             as 'Reduzido_Lancamento_Padrao',
		--Conta de Débito da Nota
		null as 'cd_debito_nota_fiscal',
		--Conta de Crédito da nota
		null as 'cd_credito_nota_fiscal',
		--Conta de Débito do IPI
		null as 'cd_debito_ipi',
		--Conta de Crédito IPI
		null as 'cd_credito_ipi',
		--Conta de Débito do ICMS
		null as 'cd_debito_icms',
		--Conta de Crédito do ICMS
		null as 'cd_credito_icms',
		--Histórico Nota
		null as 'cd_historico_nota_fiscal',
		--Histórico IPI
		null as 'cd_historico_ipi',
		--Histórico ICMS
		null as 'cd_historico_icms',
                /* ELIAS 16/07/2003 */ 
		sum(cast(round(isnull(nsc.vl_contab_nota_saida,0),2) as decimal(25,2)))	as 'ValorTotal',
		sum(cast(round(isnull(nsc.vl_icms_nota_saida,0),2) as decimal(25,2)))	as 'ValorICMS',
		sum(cast(round(isnull(nsc.vl_ipi_nota_saida,0),2) as decimal(25,2)))	as 'ValorIPI',
		sum(cast(round(isnull(nsc.vl_pis_nota_saida,0),2)    as decimal(25,2)))              as 'ValorPIS',
		sum(cast(round(isnull(nsc.vl_cofins_nota_saida,0),2) as decimal(25,2)))              as 'ValorCOFINS'


	into	#ContabilRazaoSemContaSINTETICO

	from	Nota_Saida_Contabil nsc

	where	nsc.dt_contab_nota_saida between @dt_inicial and @dt_final
                and
		(isnull(nsc.cd_lancamento_padrao,0)=0 or 
		IsNull(nsc.cd_lancamento_padrao,0) = 598)-- Lancamento do tipo "SEM VALOR CONTABIL"  

	-----------------------------------------------
	-- Traz Notas de Saída com conta
	-----------------------------------------------

	--Foi criada esta tabela para agrupara os valores sem a necessidade de uma 
	--restruturação da lógica empregada nos outros procedimentos

	Select
		nsc.cd_lancamento_padrao,
		--Define a conta principal

		(Select	top 1 nm_conta
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_credito
			from	Lancamento_Padrao
			where	cd_conta_plano =
				(Select top 1 cd_conta_plano
				from	Lancamento_Padrao lp
				where	lp.cd_lancamento_padrao = nsc.cd_lancamento_padrao) and
                                        cd_tipo_contabilizacao = 1)) as Nome_Lancamento_Padrao,
--					RTrim(nm_lancamento_padrao) like '%NF')) as Nome_Lancamento_Padrao,

		(Select top 1 cd_mascara_conta
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_credito
			from	Lancamento_Padrao
			where	cd_conta_plano =
				(Select top 1 cd_conta_plano
				from	Lancamento_Padrao lp
				where	lp.cd_lancamento_padrao = nsc.cd_lancamento_padrao) and
                                        cd_tipo_contabilizacao = 1)) as Mascara_Lancamento_Padrao,
--					RTrim(nm_lancamento_padrao) like '%NF')) as Mascara_Lancamento_Padrao,

		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_credito
			from	Lancamento_Padrao
			where	cd_conta_plano =
				(Select top 1 cd_conta_plano
				from	Lancamento_Padrao lp
				where	lp.cd_lancamento_padrao = nsc.cd_lancamento_padrao) and
                                        cd_tipo_contabilizacao = 1)) as Reduzido_Lancamento_Padrao,
--					RTrim(nm_lancamento_padrao) like '%NF')) as Reduzido_Lancamento_Padrao,
                /* ELIAS 16/07/2003 */  
		cast(round(isnull(vl_contab_nota_saida,0),2) as decimal(25,2)) as vl_contab_nota_saida,
		cast(round(isnull(vl_ipi_nota_saida,0),2) as decimal(25,2))    as vl_ipi_nota_saida,
		cast(round(isnull(vl_icms_nota_saida,0),2) as decimal(25,2))   as vl_icms_nota_saida,
		cast(round(isnull(nsc.vl_pis_nota_saida,0),2)    as decimal(25,2)) as vl_pis_nota_saida,
		cast(round(isnull(nsc.vl_cofins_nota_saida,0),2) as decimal(25,2)) as vl_cofins_nota_saida,

		(Select cd_conta_debito from lancamento_padrao       where cd_lancamento_padrao = nsc.cd_lancamento_padrao) as cd_conta_debito,
		(Select cd_conta_credito from lancamento_padrao      where cd_lancamento_padrao = nsc.cd_lancamento_padrao) as cd_conta_credito,
		(Select cd_historico_contabil from lancamento_padrao where cd_lancamento_padrao = nsc.cd_lancamento_padrao) as cd_historico

	into	#ContabilRazaoComContaBaseSINTETICO

	from	Nota_Saida_Contabil nsc
		inner join Lancamento_Padrao lp on
		nsc.cd_lancamento_padrao = lp.cd_lancamento_padrao
	where
		(nsc.dt_contab_nota_saida between @dt_inicial and @dt_final) and
		(IsNull(nsc.cd_lancamento_padrao,0) <> 0 and IsNull(nsc.cd_lancamento_padrao,0) <> 598)


	Select	
		Nome_Lancamento_Padrao,
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
    -- ELIAS 21/07/2004 - Arredondamento
		(Select sum(cast(str(vl_contab_nota_saida,25,2) as decimal(25,2))) from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao) as vl_total,
		(Select sum(cast(str(vl_icms_nota_saida,25,2) as decimal(25,2)))   from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao) as vl_icms,
		(Select sum(cast(str(vl_ipi_nota_saida,25,2) as decimal(25,2)))    from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao) as vl_ipi,
		(Select sum(cast(str(vl_pis_nota_saida,25,2) as decimal(25,2)))    from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao) as vl_pis,
		(Select sum(cast(str(vl_cofins_nota_saida,25,2) as decimal(25,2)))    from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao) as vl_cofins,

		(Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao
			and vl_contab_nota_saida > 0) as cd_lancamento_nota,
		(Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao
			and vl_icms_nota_saida > 0) as cd_lancamento_icms,
		(Select top 1 cd_lancamento_padrao from #ContabilRazaoComContaBaseSINTETICO where Mascara_Lancamento_Padrao = nsc.Mascara_Lancamento_Padrao
			and vl_ipi_nota_saida > 0) as cd_lancamento_ipi

	into	#ContabilRazaoComContaBaseSINTETICO_Contas

	from	#ContabilRazaoComContaBaseSINTETICO nsc

	group by
		Nome_Lancamento_Padrao,
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao


	Select 
		Nome_Lancamento_Padrao,
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,

		--===============
		-- Contas Crédito:
		--===============

		--Nota
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_credito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = nsc.cd_lancamento_nota)) as cd_credito_nota_fiscal,
		--ICMS
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_credito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = nsc.cd_lancamento_icms)) as cd_credito_icms,
		--IPI
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_credito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = nsc.cd_lancamento_ipi)) as cd_credito_ipi,

		--===============
		-- Contas Débito:
		--===============

		--Nota
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = nsc.cd_lancamento_nota)) as cd_debito_nota_fiscal,
		--ICMS
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = nsc.cd_lancamento_icms)) as cd_debito_icms,
		--IPI
		(Select top 1 cd_conta_reduzido
		from	plano_conta
		where	cd_conta =
			(Select top 1 cd_conta_debito
			from	Lancamento_padrao
			where	cd_lancamento_padrao = nsc.cd_lancamento_ipi)) as cd_debito_ipi,

		--============
		-- Históricos:
		--============

		--Nota
		(Select top 1 cd_historico_contabil
		from	Lancamento_padrao
		where	cd_lancamento_padrao = nsc.cd_lancamento_nota) as cd_historico_nota_fiscal,
		--ICMS
		(Select top 1 cd_historico_contabil
		from	Lancamento_padrao
		where	 cd_lancamento_padrao = nsc.cd_lancamento_icms) as cd_historico_icms,
		--IPI
		(Select top 1 cd_historico_contabil
		from	Lancamento_padrao 
		where	cd_lancamento_padrao = nsc.cd_lancamento_ipi) as cd_historico_ipi,
		--Valor NF
		cast(str(vl_total,25,2) as decimal(25,2)) as ValorTotal,
		--Valor ICMS
		cast(str(vl_icms,25,2) as decimal(25,2))  as ValorICMS,
		--Valor IPI
		cast(str(vl_ipi,25,2) as decimal(25,2))   as ValorIPI,
                --Valor PIS
		cast(str(vl_pis,25,2) as decimal(25,2))   as ValorPIS,
                --Valor COFINS 
		cast(str(vl_cofins,25,2) as decimal(25,2))   as ValorCOFINS

	into	#ContabilRazaoComContaBaseSINTETICO_Final

	from	#ContabilRazaoComContaBaseSINTETICO_Contas as nsc

	-------------------------------------------------------------
	-- Unir a temporária das sem conta com as que possuem contas
	-------------------------------------------------------------
	Insert 
	into	#ContabilRazaoSemContaSINTETICO 

		(Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		ValorTotal,
		ValorICMS,
		ValorIPI,
                ValorPIS,
                ValorCOFINS)
	select 
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		ValorTotal,
		ValorICMS,
		ValorIPI,
                ValorPIS,
                ValorCOFINS

	from	#ContabilRazaoComContaBaseSINTETICO_Final


	select
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,   
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms,
		sum(IsNull(ValorTotal,0))  as ValorTotal,
		sum(IsNull(ValorICMS,0))   as ValorICMS,
		sum(isNull(ValorIPI,0))    as ValorIPI,
		sum(isNull(ValorPIS,0))    as ValorPIS,
		sum(isNull(ValorCOFINS,0)) as ValorCOFINS

	from 
		#ContabilRazaoSemContaSINTETICO

	group by 
		Nome_Lancamento_Padrao, 
		Mascara_Lancamento_Padrao,
		Reduzido_Lancamento_Padrao,
		cd_credito_nota_fiscal,
		cd_debito_nota_fiscal,
		cd_credito_ipi,
		cd_debito_ipi,
		cd_credito_icms,
		cd_debito_icms,
		cd_historico_nota_fiscal,
		cd_historico_ipi,
		cd_historico_icms
	order by
		cd_debito_nota_fiscal, Mascara_Lancamento_Padrao, Nome_Lancamento_Padrao

end

SET LOCK_TIMEOUT -1

