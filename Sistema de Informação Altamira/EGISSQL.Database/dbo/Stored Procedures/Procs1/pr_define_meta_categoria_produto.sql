-------------------------------------------------------------------
--pr_define_meta_categoria_produto
-------------------------------------------------------------------
--GBS - Global Business Solution Ltda                 	       2004
-------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Fabio Cesar Magalhães
--Banco de Dados      : EgisSQL
--Objetivo            : Procedimentos para as Metas por Categoria de Produto.
--Data                : 02.01.2006
--Atualizado          : 
CREATE procedure pr_define_meta_categoria_produto
	@ic_parametro           int,      -- 1 - Consulta meta do período informado
																    -- 2 - Gera Meta em função do Período informado
	@dt_pesquisa_meta       datetime, -- Data para pesquisa (1) / Data para geração (2)
	@dt_geracao_meta        datetime = '01/01/2005',  -- Data base para importação da meta anterior (01/01/2005--data qualquer)
	@cd_usuario             int = 0   --Usuário utilizado para caso de geração
as
begin
	
declare
	@dt_final_periodo datetime,
  @dt_ano int,
	@dt_mes int,
  @dt_ano_geracao int,
	@dt_mes_geracao int

--Carrega variáveis para uso
Select
	@dt_ano = DATEPART(yyyy,@dt_pesquisa_meta), --Define o Ano
	@dt_mes = DATEPART(mm,@dt_pesquisa_meta),   --Define o Mês
	@dt_ano_geracao = DATEPART(yyyy,IsNull(@dt_geracao_meta,getdate())), --Define o Ano para base de geração
	@dt_mes_geracao = DATEPART(mm,IsNull(@dt_geracao_meta,getdate())),   --Define o Mês para base de geração
  @dt_final_periodo = dateadd(month, 1, dateadd(day,-1,@dt_pesquisa_meta)) --Define o último dia do mês corrente

	--*******************************************************************************************
	--Caso seja selecionado para gerar em função de uma data, depois muda o parâmetro para apresentação
	--*******************************************************************************************
	if ( @ic_parametro = 2 )
	begin
		--Gera massa de dados para importação		
		select 
			mcp.*
		into
			#Mudanca
		from 
			Categoria_Produto cp
			inner join Meta_Categoria_Produto mcp
				on mcp.cd_categoria_produto = cp.cd_categoria_produto 					 
		where 
			IsNull(cp.ic_fatura_categoria,'S') = 'S' and --Somente apresenta categoria do Mapa de faturamento
		  IsNull(cp.ic_total_categoria,'N') = 'N' and --Apresenta apenas as categorias finais			
			year(mcp.dt_inicial_meta_categoria) = @dt_ano_geracao and --Informa o período / Ano
		  month(mcp.dt_inicial_meta_categoria) = @dt_mes_geracao      --Informa o período / Mês
		order by 
			cp.cd_ordem_categoria

		update #Mudanca
		set 
			dt_inicial_meta_categoria = @dt_pesquisa_meta,
			dt_final_meta_categoria = @dt_final_periodo,
			dt_usuario = getdate(),
			cd_usuario = @cd_usuario,
			qt_ven_meta_categoria = IsNull(qt_ven_meta_categoria,0),
			qt_fat_meta_categoria = IsNull(qt_fat_meta_categoria,0),
			vl_ven_meta_categoria = IsNull(vl_ven_meta_categoria,0),
			vl_fat_meta_categoria = IsNull(vl_fat_meta_categoria,0)
		
		--Insere registro
		Insert into Meta_Categoria_Produto
		Select * from #Mudanca
		where not exists(Select 'x' from Meta_Categoria_Produto mcp 
										 where year(mcp.dt_inicial_meta_categoria) = year(#Mudanca.dt_inicial_meta_categoria) and
													 month(mcp.dt_inicial_meta_categoria) = month(#Mudanca.dt_inicial_meta_categoria))
		--Exclui tabela
		drop table #Mudanca		

		--Define que será apresentado os dados gerados, caso não existam
		set @ic_parametro = 1
	end

	--*******************************************************************************************
	--Caso seja selecionado apenas para filtrar
	--*******************************************************************************************
	if ( @ic_parametro = 1 )
	begin
		select 
		  cp.sg_categoria_produto,
		  cp.cd_mascara_categoria,
			mcp.*
		from 
			Meta_Categoria_Produto mcp
			inner join Categoria_Produto cp
				on mcp.cd_categoria_produto = cp.cd_categoria_produto
		where 
			IsNull(cp.ic_fatura_categoria,'S') = 'S' and --Somente apresenta categoria do Mapa de faturamento
		  IsNull(cp.ic_total_categoria,'N') = 'N' and  --Apresenta apenas as categorias finais
			year(mcp.dt_inicial_meta_categoria) = @dt_ano and --Informa o período / Ano
		  month(mcp.dt_inicial_meta_categoria) = @dt_mes    --Informa o período / Mês
		order by 
			cp.cd_ordem_categoria
	end
end
