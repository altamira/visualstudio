
-------------------------------------------------------------------------------
--sp_helptext pr_copia_laudo_produto_caracteristica
-------------------------------------------------------------------------------
--pr_copia_laudo_produto_caracteristica
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 29.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_copia_laudo_produto_caracteristica
@cd_produto                int = 0,
@cd_produto_copia          int = 0,
@nm_fantasia_produto       varchar(25) = '',
@nm_fantasia_produto_copia varchar(25) = '' 
as

if @nm_fantasia_produto<>'' and isnull(@cd_produto,0)=0
begin
  select 
    @cd_produto = isnull(cd_produto,0)
  from
    produto
  where
    nm_fantasia_produto = @nm_fantasia_produto
end

if @nm_fantasia_produto_copia<>'' and isnull(@cd_produto_copia,0)=0
begin
  select 
    @cd_produto_copia = isnull(cd_produto,0)
  from
    produto
  where
    nm_fantasia_produto = @nm_fantasia_produto_copia
end

  

if @cd_produto>0 and @cd_produto_copia>0
begin

  --Deleta o Produto da Cópia
  delete from laudo_produto_caracteristica where cd_produto = @cd_produto_copia

  select 
    *
  into
    #laudo_produto_caracteristica
  from 
    laudo_produto_caracteristica
  where
    cd_produto = @cd_produto

  update
    #laudo_produto_caracteristica
  set
    cd_produto = @cd_produto_copia
  where
    cd_produto = @cd_produto

  insert into
    laudo_produto_caracteristica
  select 
    *
  from
    #laudo_produto_caracteristica   
       

end



