
CREATE PROCEDURE pr_consulta_reajuste_definitivo
@ic_parametro          int,
@cd_produto            int,
@vl_temp_preco_produto float,
@cd_usuario            int = 0

as

  declare @cd_grupo_produto     int
  declare @cd_tipo_reajuste     int
  declare @cd_tipo_tabela_preco int
  declare @cd_motivo_reajuste   int
  declare @cd_moeda             int 
  declare @cd_produto_historico int
  declare @vl_produto           float --Preço Anterior -> Antes do Cálculo
  declare @nm_obs_produto_preco varchar(40)
  declare @pc_reajuste          float

set @cd_grupo_produto     = 0
set @cd_tipo_reajuste     = 0
set @cd_tipo_tabela_preco = 0
set @cd_motivo_reajuste   = 0
set @cd_moeda             = 1
set @nm_obs_produto_preco = ''
set @pc_reajuste          = 0

-------------------------------------------------------------------
if @ic_parametro = 1 --Consulta 
-------------------------------------------------------------------
begin

  select
    pp.cd_produto,
    dbo.fn_mascara_produto(p.cd_produto) as 'cd_mascara_produto',
    p.nm_fantasia_produto,
    p.nm_produto,
    p.vl_produto,
    u.sg_unidade_medida,
    pp.dt_produto_preco,
    pp.vl_atual_produto_preco,
    pp.vl_temp_produto_preco,
    pp.qt_indice_produto_preco,
    pp.nm_obs_produto_preco,
    pp.cd_grupo_preco_produto,
    pp.cd_moeda,
    pp.cd_tipo_reajuste,
    pp.cd_motivo_reajuste,
    mr.nm_motivo_reajuste,
    pp.cd_tipo_tabela_preco,
    pp.cd_usuario,
    pp.dt_usuario
  from Produto_Preco pp with (nolock)
  left outer join Produto p with (nolock)
    on p.cd_produto=pp.cd_produto
  left outer join Motivo_Reajuste mr with (nolock)
    on mr.cd_motivo_reajuste=pp.cd_motivo_reajuste
  left outer join Unidade_Medida u with (nolock)
    on u.cd_unidade_medida=p.cd_unidade_medida

end

-------------------------------------------------------------------
else if @ic_parametro = 2 -- Atualização individual
-------------------------------------------------------------------
begin

  --Atualiza a Tabela de Histórico de preço

  select
    @cd_grupo_produto     = p.cd_grupo_produto,
    @cd_tipo_reajuste     = 1, 
    @cd_tipo_tabela_preco = 1,
    @cd_moeda             = p.cd_moeda,
    @vl_produto           = p.vl_produto,
    @cd_motivo_reajuste   = pp.cd_motivo_reajuste
  from
    Produto p with (nolock)
    inner join Produto_Preco pp with (nolock)
    on p.cd_produto = pp.cd_produto 
  where
    p.cd_produto = @cd_produto    

  --Busca do Próximo Código

  select
    @cd_produto_historico = isnull( max(cd_produto_historico),0) + 1
  from
    Produto_Historico with (nolock)
  where
    cd_produto = @cd_produto
    
  --Inserção do Registro
 
  insert Produto_Historico (
     dt_historico_produto,
     cd_grupo_produto,
     cd_produto,
     vl_historico_produto,
     cd_tipo_reajuste,
     cd_tipo_tabela_preco,
     cd_moeda,
     cd_usuario,
     dt_usuario,
     cd_produto_historico,
     ic_tipo_historico_produto,
     cd_motivo_reajuste )
  select
     getdate(),
     @cd_grupo_produto,
     @cd_produto,
     @vl_produto,
     @cd_tipo_reajuste,
     @cd_tipo_tabela_preco,
     @cd_moeda,
     @cd_usuario,
     getdate(),
     @cd_produto_historico,
     'V', --Venda
     @cd_motivo_reajuste

  --Atualiza o Preço de Venda do Produto
    
  update Produto
  set vl_produto = @vl_temp_preco_produto
  where
    cd_produto = @cd_produto
    
  delete Produto_Preco
  where cd_produto = @cd_produto

--select * from produto_historico
end

-------------------------------------------------------------------
else if @ic_parametro = 3 -- Retorno dos Preços
-------------------------------------------------------------------
begin

  update 
    Produto
  set 
    vl_produto = @vl_temp_preco_produto,
    cd_usuario = @cd_usuario,
    dt_usuario = getdate()
  where
    cd_produto = @cd_produto

end

-------------------------------------------------------------------
else if @ic_parametro = 4 -- Geração da Tabela com os Preços Temporário
-------------------------------------------------------------------
begin

	Select
	  @cd_produto            as cd_produto,
	  getdate()              as dt_produto_preco,
	  p.vl_produto           as vl_atual_produto_preco,
	  @vl_temp_preco_produto as vl_temp_produto_preco,
	  pc.cd_grupo_preco_produto,
	  @cd_tipo_reajuste      as cd_tipo_reajuste,
	  @cd_motivo_reajuste    as cd_motivo_reajuste,
	  @nm_obs_produto_preco  as nm_obs_produto_preco,
	  @cd_usuario            as cd_usuario,
	  IsNull(p.cd_moeda,1)   as cd_moeda,
	  getdate()              as dt_usuario
	into
	  #Produto
	from
	  Produto p with (nolock) inner join Produto_Custo pc with (nolock)
	  on p.cd_produto = pc.cd_produto
	where
	  p.cd_produto = @cd_produto
	
	delete from Produto_Preco
	where exists(Select 'x' from #Produto where cd_produto = Produto_Preco.cd_produto)

        --Gera a Tabela Temporária

	insert into Produto_Preco
	Select
		cd_produto,
		dt_produto_preco,
		IsNull(vl_atual_produto_preco,0),
		IsNull(vl_temp_produto_preco,0),
		@pc_reajuste,
		@nm_obs_produto_preco,
		cd_grupo_preco_produto,
		cd_moeda,
		cd_tipo_reajuste,
		@cd_motivo_reajuste,
		@cd_tipo_tabela_preco,
		@cd_usuario,
		dt_usuario,
                null,
                null
	from
		#Produto

  
end
-------------------------------------------------------------------
else if @ic_parametro = 5 -- Atualização em Lote de todos os preços Definitivos
-------------------------------------------------------------------
begin

	--Será feita de forma recursiva para evitar duplicidade de código
  
	Select 
		cd_produto, 
		vl_temp_produto_preco
	into
		#Atualizacao_Em_Lote
	from
		Produto_Preco with (nolock)

	--Garantir que só efetiva o processo completo
    Begin transaction
	while exists (Select 'x' from #Atualizacao_Em_Lote)
	begin
		Select top 1 @cd_produto = cd_produto,
					 @vl_temp_preco_produto = vl_temp_produto_preco
		from
			#Atualizacao_Em_Lote
		print 'Produto:'
		print cast(@cd_produto as varchar)

		--Chamada recursiva para evitar código duplicado e problemas futuros de desatualização
		exec pr_consulta_reajuste_definitivo
			2, --@ic_parametro = Atualização individual
			@cd_produto,
			@vl_temp_preco_produto,
			@cd_usuario

		delete from #Atualizacao_Em_Lote where cd_produto = @cd_produto	
	end	

	drop table #Atualizacao_Em_Lote

	--Caso não tenha ocorrido nenhuma anomalia confirma a transação
	if ( @@error != 0 )
		Rollback transaction
	else
	begin
		Commit Transaction
 		--Executa procedimento do JOB da Lista de preço do REPNET para empresas que possuam o REPNET
 		--if exists(select 'x' from egisadmin.dbo.empresa where ic_repnet_empresa = 'S')
 		--	EXEC msdb.[dbo].sp_start_job @job_name = 'ListaREP', @server_name = 'TAITI'
	end
end

