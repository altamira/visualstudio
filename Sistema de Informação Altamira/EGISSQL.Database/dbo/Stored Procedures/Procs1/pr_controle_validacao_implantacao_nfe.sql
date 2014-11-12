
-------------------------------------------------------------------------------
--sp_helptext pr_controle_validacao_implantacao_nfe
-------------------------------------------------------------------------------
--pr_controle_validacao_implantacao_nfe
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Validação de Implantação da 
--                   Nota Fiscal Eletrônica
--Data             : 28.03.2009
--Alteração        : 
--
-- 31.03.2009 - Complemento da Consistência - Carlos Fernandes
-- 16.09.2009 - Ajuste das Consistências do Cliente 
--
------------------------------------------------------------------------------
create procedure pr_controle_validacao_implantacao_nfe
@ic_parametro      int = 0,
@cd_tipo_validacao int = 0,
@cd_usuario        int = 0

as

declare @nm_validacao          varchar(60)
declare @cd_registro           int
declare @nm_fantasia           varchar(30)
declare @nm_registro_validacao varchar(60)
declare @cd_tabela             int
declare @ds_validacao          varchar(256)

set @nm_validacao      = ''


--Tabela de Consistência
--select * from tipo_validacao

if @cd_tipo_validacao>0 
begin

  select
    @nm_validacao = isnull(nm_tipo_validacao,''),
    @ds_validacao = isnull(ds_tipo_validacao,'')
  from
    Tipo_Validacao tv with (nolock) 
  where
    cd_tipo_validacao = @cd_tipo_validacao

end

--Deleta a Tabela de Consistência

delete from NFE_Validacao 
where
  cd_tipo_validacao = @cd_tipo_validacao

--País

if @ic_parametro = 1
begin

  --select * from pais

  select 
    cd_registro           = cd_pais,
    nm_fantasia           = sg_pais,
    nm_registro_validacao = nm_pais  
  into
    #Pais
  from
    Pais p with (nolock) 
  where
    isnull(cd_bacen_pais,0)=0

  while exists ( select top 1 cd_registro from #Pais )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Pais

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Pais
    where
      cd_registro = @cd_registro

  end

end

--Estado

if @ic_parametro = 2
begin

  --select * from estado

  select 
    cd_registro           = cd_estado,
    nm_fantasia           = sg_estado,
    nm_registro_validacao = nm_estado  
  into
    #EstadoT

  from
    Estado e with (nolock) 

  where
    isnull(cd_ibge_estado,0)=0

  while exists ( select top 1 cd_registro from #EstadoT )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #EstadoT

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #EstadoT
    where
      cd_registro = @cd_registro


   end

end

--Cidade

if @ic_parametro = 3
begin

  --select * from cidade

  select 
    cd_registro           = cd_cidade,
    nm_fantasia           = sg_cidade,
    nm_registro_validacao = nm_Cidade  
  into
    #Cidade

  from
    Cidade c with (nolock) 

  where
    isnull(cd_cidade_ibge,0)=0

  while exists ( select top 1 cd_registro from #Cidade )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Cidade

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Cidade
    where
      cd_registro = @cd_registro


   end

end

--Transportadora

if @ic_parametro = 4
begin

  --select * from Transportadora

  select 
    cd_registro           = cd_transportadora,
    nm_fantasia           = nm_fantasia,
    nm_registro_validacao = nm_transportadora
  into
    #Transportadora

  from
    Transportadora t with (nolock) 

  where
    isnull(cd_registro_transportadora,'')=''

  while exists ( select top 1 cd_registro from #Transportadora )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Transportadora

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Transportadora
    where
      cd_registro = @cd_registro


   end

end


--Condição de Pagamento

if @ic_parametro = 5
begin

  --select * from Condicao_Pagamento

  select 
    cd_registro           = cd_condicao_pagamento,
    nm_fantasia           = sg_condicao_pagamento,
    nm_registro_validacao = nm_condicao_pagamento
  into
    #CP

  from
    Condicao_Pagamento with (nolock) 

  where
    isnull(cd_forma_condicao,0)=0

  while exists ( select top 1 cd_registro from #CP )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #CP

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #CP
    where
      cd_registro = @cd_registro


   end

end

--Produto sem Tributação

if @ic_parametro = 6
begin

  --select * from pais

  select 
    cd_registro           = p.cd_produto,
    nm_fantasia           = p.nm_fantasia_produto,
    nm_registro_validacao = p.nm_produto
  into
    #Produto_Sem_Tributacao
  from
    Produto p with (nolock) 
    left join Produto_Fiscal pf with (nolock) on pf.cd_produto = p.cd_produto
  where
    isnull(pf.cd_tributacao,0)=0

  while exists ( select top 1 cd_registro from #Produto_Sem_Tributacao )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Produto_Sem_Tributacao

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Produto_Sem_Tributacao
    where
      cd_registro = @cd_registro


  end

end

--Produto sem Código do Produto

if @ic_parametro = 7
begin

  --select * from pais

  select 
    cd_registro           = p.cd_produto,
    nm_fantasia           = p.nm_fantasia_produto,
    nm_registro_validacao = p.nm_produto
  into
    #Produto_Sem_Codigo
  from
    Produto p with (nolock) 
    
  where
    isnull(p.cd_mascara_produto,'')=''

  while exists ( select top 1 cd_registro from #Produto_Sem_Codigo )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Produto_Sem_Codigo

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Produto_Sem_Codigo
    where
      cd_registro = @cd_registro


  end

end

--Produtos Duplicados

if @ic_parametro = 8
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
	
    select 
      cd_registro           = p.cd_produto,
      nm_fantasia           = p.nm_fantasia_produto,
      nm_registro_validacao = p.nm_produto
    into
      #Produto_Duplicado
    from
      Produto p with (nolock) 
      inner join #Produto x on x.cd_mascara_produto = p.cd_mascara_produto
    
  while exists ( select top 1 cd_registro from #Produto_Duplicado )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Produto_Duplicado

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Produto_Duplicado
    where
      cd_registro = @cd_registro


  end

  drop table #temp2
  drop table #produto
  drop table #produto_duplicado



end

--Produtos sem Classificação Fiscal

if @ic_parametro = 9
begin

  select 
    cd_registro           = p.cd_produto,
    nm_fantasia           = p.nm_fantasia_produto,
    nm_registro_validacao = p.nm_produto
  into
    #Produto_Sem_CF
  from
    Produto p with (nolock) 
    left outer join Produto_Fiscal pf on pf.cd_produto = p.cd_produto
    
  where
    isnull(pf.cd_classificacao_fiscal,0)=0

  while exists ( select top 1 cd_registro from #Produto_Sem_CF )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Produto_Sem_CF

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Produto_Sem_CF
    where
      cd_registro = @cd_registro


  end

end

--Cliente sem CNPJ

if @ic_parametro = 15
begin

  select 
    cd_registro           = c.cd_cliente,
    nm_fantasia           = c.nm_fantasia_cliente,
    nm_registro_validacao = c.nm_razao_social_cliente
  into
    #Cliente_Sem_CNPJ
  from
    Cliente c with (nolock) 
    
  
  where
    isnull(c.cd_cnpj_cliente,'')=''

  while exists ( select top 1 cd_registro from #Cliente_Sem_CNPJ )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Cliente_Sem_CNPJ

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Cliente_Sem_CNPJ
    where
      cd_registro = @cd_registro


  end


end

--Cliente sem Inscrição Estadual

if @ic_parametro = 16
begin

  select 
    cd_registro           = c.cd_cliente,
    nm_fantasia           = c.nm_fantasia_cliente,
    nm_registro_validacao = c.nm_razao_social_cliente
  into
    #Cliente_Sem_IE
  from
    Cliente c with (nolock) 
    
  
  where
    isnull(c.cd_inscestadual,'')=''

  while exists ( select top 1 cd_registro from #Cliente_Sem_IE )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Cliente_Sem_IE

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Cliente_Sem_IE
    where
      cd_registro = @cd_registro


  end

end

--Clientes sem Telefone
if @ic_parametro = 19
begin

  --select * from cliente

  select 
    cd_registro           = c.cd_cliente,
    nm_fantasia           = c.nm_fantasia_cliente,
    nm_registro_validacao = c.nm_razao_social_cliente
  into
    #Cliente_Sem_Telefone
  from
    Cliente c with (nolock) 
 
  where
    isnull(c.cd_telefone,'')='' or
    isnull(c.cd_ddd,'')     = ''

  while exists ( select top 1 cd_registro from #Cliente_Sem_Telefone )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Cliente_Sem_Telefone

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Cliente_Sem_Telefone
    where
      cd_registro = @cd_registro


  end



end



--Clientes sem Bairro

if @ic_parametro = 20
begin

  --select * from cliente

  select 
    cd_registro           = c.cd_cliente,
    nm_fantasia           = c.nm_fantasia_cliente,
    nm_registro_validacao = c.nm_razao_social_cliente
  into
    #Cliente_Sem_Bairro
  from
    Cliente c with (nolock) 
    
  
  where
   isnull(c.nm_bairro,'')=''

    --isnull(c.cd_cnpj_cliente,'')=''

  while exists ( select top 1 cd_registro from #Cliente_Sem_Bairro )
  begin
    select 
      top 1
      @cd_registro           = cd_registro,
      @nm_fantasia           = nm_fantasia,
      @nm_registro_validacao = nm_registro_validacao
    from
      #Cliente_Sem_Bairro

    --Gera a Gravação da Tabela

    exec pr_gera_gravacao_validacao_nfe
      @cd_usuario,
      @cd_tipo_validacao,
      @nm_validacao,      
      @cd_registro,
      @nm_fantasia,
      @nm_registro_validacao,
      @cd_tabela,
      @ds_validacao

    --Deleta o registro Temporário

    delete from #Cliente_Sem_Bairro
    where
      cd_registro = @cd_registro


  end



end

--Cliente Duplicado
--Douglas já fez precisa complementar aqui na procedure

-- if @ic_parametro = 17
-- begin
-- 
-- 
-- end
-- 
--select * from cidade
--select * from transportadora

