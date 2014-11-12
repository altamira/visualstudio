
-------------------------------------------------------------------------------
--pr_copia_grupo_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : EgisAdmin
--Objetivo         : Cópia do Tabela
--Data             : 14/08/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_grupo_produto
@cd_grupo_produto_old int,
@nm_grupo_produto_new Varchar(40)
as
print 'Iniciou'

Declare @cd_grupo_produto_new int
Declare @Tabela  varchar(50)  

if exists(Select top 1 * from Grupo_Produto where cd_grupo_produto = @cd_grupo_produto_old)
begin
----------------------------------------------------------------------------------------
--COPIA O USUARIO
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction
set @Tabela =  db_name()+'.dbo.grupo_produto' 
-- campo chave utilizando a tabela de códigos  
exec EGISADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_grupo_produto', @codigo = @cd_grupo_produto_new output  

Print 'Pegou o novo código'

----------------------------------------------------------------------------------------
--GRUPO PRODUTO
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#grupo_produto
from 
	grupo_produto
where 
	cd_grupo_produto = @cd_grupo_produto_old

Update #grupo_produto Set 
	cd_grupo_produto    	= @cd_grupo_produto_new,
	nm_fantasia_grupo_produto = @nm_grupo_produto_new,
   nm_grupo_produto          = @nm_grupo_produto_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()

insert into 
	grupo_produto
Select 
	* 
from 
	#grupo_produto

----------------------------------------------------------------------------------------
--GRUPO PRODUTO FICAL
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#grupo_produto_fiscal
from 
	grupo_produto_fiscal
where 
	cd_grupo_produto = @cd_grupo_produto_old

Update #grupo_produto_fiscal Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	grupo_produto_fiscal
Select 
	* 
from 
	#grupo_produto_fiscal


----------------------------------------------------------------------------------------
-- grupo_produto_fiscal_entrada
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#grupo_produto_fiscal_entrada
from 
	grupo_produto_fiscal_entrada
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #grupo_produto_fiscal_entrada Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	grupo_produto_fiscal_entrada
Select 
	* 
from 
	#grupo_produto_fiscal_entrada

----------------------------------------------------------------------------------------
-- Grupo_Produto_Contabilizacao
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#Grupo_Produto_Contabilizacao
from 
	Grupo_Produto_Contabilizacao
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #Grupo_Produto_Contabilizacao Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	Grupo_Produto_Contabilizacao
Select 
	* 
from 
	#Grupo_Produto_Contabilizacao

----------------------------------------------------------------------------------------
-- grupo_produto_garantia
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#grupo_produto_garantia
from 
	grupo_produto_garantia
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #grupo_produto_garantia Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	grupo_produto_garantia
Select 
	* 
from 
	#grupo_produto_garantia

----------------------------------------------------------------------------------------
-- Grupo_Produto_Custo
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#Grupo_Produto_Custo
from 
	Grupo_Produto_Custo
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #Grupo_Produto_Custo Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	Grupo_Produto_Custo
Select 
	* 
from 
	#Grupo_Produto_Custo

----------------------------------------------------------------------------------------
-- Grupo_Produto_Valoracao
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#Grupo_Produto_Valoracao
from 
	Grupo_Produto_Valoracao
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #Grupo_Produto_Valoracao Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	Grupo_Produto_Valoracao
Select 
	* 
from 
	#Grupo_Produto_Valoracao

----------------------------------------------------------------------------------------
-- grupo_produto_markup
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#grupo_produto_markup
from 
	grupo_produto_markup
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #grupo_produto_markup Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	grupo_produto_markup
Select 
	* 
from 
	#grupo_produto_markup

----------------------------------------------------------------------------------------
-- grupo_produto_codificacao
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#grupo_produto_codificacao
from 
	grupo_produto_codificacao
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #grupo_produto_codificacao Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	grupo_produto_codificacao
Select 
	* 
from 
	#grupo_produto_codificacao

----------------------------------------------------------------------------------------
-- Grupo_Produto_Observacao
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#Grupo_Produto_Observacao
from 
	Grupo_Produto_Observacao
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #Grupo_Produto_Observacao Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	Grupo_Produto_Observacao
Select 
	* 
from 
	#Grupo_Produto_Observacao

----------------------------------------------------------------------------------------
-- grupo_produto_proposta
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#grupo_produto_proposta
from 
	grupo_produto_proposta
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #grupo_produto_proposta Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	grupo_produto_proposta
Select 
	* 
from 
	#grupo_produto_proposta

----------------------------------------------------------------------------------------
-- Grupo_Produto_Fase
----------------------------------------------------------------------------------------

Select 
	 * 
into 
	#Grupo_Produto_Fase
from 
	Grupo_Produto_Fase
where 
	cd_grupo_produto  = @cd_grupo_produto_old

Update #Grupo_Produto_Fase Set 
	cd_grupo_produto    	     = @cd_grupo_produto_new,
	cd_usuario                = 99,
	dt_usuario                = GetDate()

insert into 
	Grupo_Produto_Fase
Select 
	* 
from 
	#Grupo_Produto_Fase
------------------------------------------------------------------------------
--Retorno
------------------------------------------------------------------------------
  if @@error = 0
  begin
    	commit transaction
		Select  'Código do Novo Grupo de Produto: ' +  cast(@cd_grupo_produto_new as varchar(8))  as Retorno
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		Select  'Ocorreu um erro interno do Banco ao Cópiar Grupo de Produto!' as Retorno
		print 'ERROR'
  end

end
else
begin
	Select  'Código do Grupo de Produto: ' +  cast(@cd_grupo_produto_old as varchar(8)) + ' não existe !' as Retorno
end


