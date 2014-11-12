
-------------------------------------------------------------------------------
--sp_helptext pr_nfe_registros_duplicados
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 26.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_nfe_registros_duplicados
@ic_parametro int = 0
as

if isnull(@ic_parametro,0) = 0 -- CNPJ Duplicados dos Clientes 
  begin

	select 
	  count(*) as TotalCNPJ,
	  max(c.cd_cnpj_cliente) as cd_cnpj_cliente
	into 
	  #temp 
        from
          cliente c with (nolock)
          inner join status_cliente sc  with (nolock) on sc.cd_status_cliente = c.cd_status_cliente
        where
          isnull(sc.ic_operacao_status_cliente,'N') = 'S'
	group by 
	  c.cd_cnpj_cliente 
	
        declare cliente_d cursor for
	
	select 
	  cd_cnpj_cliente 
	from 
	  #temp 
	where 
	  TotalCNPJ > 1

	open cliente_d
	
	declare @cd_cnpj_cliente varchar(100) 
	
	fetch next from cliente_d into @cd_cnpj_cliente
	
	select top 1 * into #cliente from cliente
	
	delete from #cliente

	while (@@fetch_status <> -1)
	begin
	  
	  select * into #aux from cliente where cd_cnpj_cliente = @cd_cnpj_cliente
	
	  insert into #cliente select * from #aux
	
	  drop table #aux
	
	  fetch next from cliente_d into @cd_cnpj_cliente
	
	end
	
	select 
	  nm_fantasia_cliente,
	  cd_cnpj_cliente,
	  nm_razao_social_cliente 
	from 
	  #cliente
	order by
	  cd_cnpj_cliente  
	
	close      cliente_d
	deallocate cliente_d
	
	drop table #temp
	drop table #cliente

  end
else if isnull(@ic_parametro,0) = 1 -- Código de Produto Duplicados 
  begin

	select 
	  count(*) as TotalProduto,
	  max(p.cd_mascara_produto) as cd_mascara_produto
	into 
	  #temp2 
	from
	  Produto p                   with (nolock)  
	  inner join status_produto s with (nolock) on s.cd_status_produto        = p.cd_status_produto  
	where  
	  isnull(s.ic_bloqueia_uso_produto,'N') = 'N'   
	group by 
	  p.cd_mascara_produto 
	
	declare produto_d cursor for
	
	select 
	  cd_mascara_produto 
	from 
	  #temp2 
	where 
	  TotalProduto > 1
	
	open produto_d
	
	declare @cd_mascara_produto varchar(100) 
	
	fetch next from produto_d into @cd_mascara_produto
	
	select top 1 * into #produto from produto
	
	delete from #produto
	
	while (@@fetch_status <> -1)
	begin
	  
	  select * into #aux2 from produto where cd_mascara_produto = @cd_mascara_produto
	
	  insert into #produto select * from #aux2
	
	  drop table #aux2
	
	  fetch next from produto_d into @cd_mascara_produto
	
	end
	
	select 
	  nm_fantasia_produto,
	  cd_mascara_produto,
	  nm_produto 
	from 
	  #produto
	order by
	  cd_mascara_produto  
	
	close      produto_d
	deallocate produto_d
	
	drop table #temp2
	drop table #produto

  end
else    -- CNPJ duplicados das transportadoras 
  begin

	select 
	  count(*) as TotalCNPJ,
	  max(cd_cnpj_transportadora) as cd_cnpj_transportadora
	into 
	  #temp3 
	from
	  transportadora 
	where
	  isnull(ic_ativo_transportadora,'S') = 'S'  
	group by 
	  cd_cnpj_transportadora 
	
	declare transportadora_d cursor for
	
	select 
	  cd_cnpj_transportadora 
	from 
	  #temp3 
	where 
	  TotalCNPJ > 1
	
	open transportadora_d
	
	declare @cd_cnpj_transportadora varchar(100) 
	
	fetch next from transportadora_d into @cd_cnpj_transportadora
	
	select top 1 * into #transportadora from transportadora
	
	delete from #transportadora
	
	while (@@fetch_status <> -1)
	begin
	  
	  select * into #aux3 from transportadora where cd_cnpj_transportadora = @cd_cnpj_transportadora
	
	  insert into #transportadora select * from #aux3
	
	  drop table #aux3
	
	  fetch next from transportadora_d into @cd_cnpj_transportadora
	
	end
	
	select 
	  nm_fantasia,
	  cd_cnpj_transportadora,
	  nm_transportadora 
	from 
	  #transportadora
	order by
	  cd_cnpj_transportadora  
	
	close      transportadora_d
	deallocate transportadora_d
	
	drop table #temp3
	drop table #transportadora

  end



