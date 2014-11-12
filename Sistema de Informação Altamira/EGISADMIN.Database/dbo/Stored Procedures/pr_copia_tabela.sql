
-------------------------------------------------------------------------------
--pr_copia_tabela
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
create procedure pr_copia_tabela
@cd_tabela_old int,
@nm_tabela_new Varchar(40)
as
print 'Iniciou'

Declare @cd_tabela_new int
Declare @Tabela       varchar(50)  

if exists(Select top 1 * from Tabela where cd_tabela = @cd_tabela_old) and 
  not exists(Select top 1 * from Tabela where nm_tabela like @nm_tabela_new)
begin
----------------------------------------------------------------------------------------
--COPIA O USUARIO
----------------------------------------------------------------------------------------
--Inicia Transação
Begin Transaction
set @Tabela =  'Tabela' 
-- campo chave utilizando a tabela de códigos  
exec sp_PegaCodigo @Tabela, 'cd_tabela', @codigo = @cd_tabela_new output  

Select 
	 * 
into 
	#Tabela 
from 
	Tabela
where 
	cd_tabela = @cd_tabela_old

Update #Tabela Set 
	cd_tabela          	= @cd_tabela_new,
	nm_tabela 				= @nm_tabela_new,
   dt_criacao_tabela	   = GetDate(),
	dt_alteracao_tabela 	= GetDate(),
	cd_usuario           = 99,
	dt_usuario           = GetDate()

insert into 
	Tabela
Select 
	* 
from 
	#Tabela

----------------------------------------------------------------------------------------
--COPIA O Tabela Composição
----------------------------------------------------------------------------------------
Select 
	 * 
into 
 	#Tabela_Composicao
from 
	Tabela_Composicao
where 
	cd_tabela = @cd_tabela_old


Update #Tabela_Composicao Set 
	cd_tabela          	= @cd_tabela_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()

insert into 
	Tabela_Composicao
Select 
	* 
from 
	#Tabela_Composicao

----------------------------------------------------------------------------------------
--COPIA O Tabela Filtro
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Tabela_Filtro
from 
	Tabela_Filtro 
where 
	cd_tabela = @cd_tabela_old

Update #Tabela_Filtro Set 
	cd_tabela          	= @cd_tabela_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()


insert into 
	Tabela_Filtro
Select 
	* 
from 
	#Tabela_Filtro


----------------------------------------------------------------------------------------
--COPIA O Tabela TabSheet
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Tabela_TabSheet
from 
	Tabela_TabSheet 
where 
	cd_tabela = @cd_tabela_old

Update #Tabela_TabSheet Set 
	cd_tabela 				= @cd_tabela_new, 
	cd_usuario           = 99,
	dt_usuario           = GetDate()


insert into 
	Tabela_TabSheet
Select 
	* 
from 
	#Tabela_TabSheet


----------------------------------------------------------------------------------------
--COPIA O Tabela TabSheet Atributo
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Tabela_TabSheet_Atributo
from 
	Tabela_TabSheet_Atributo 
where 
	cd_tabela = @cd_tabela_old

Update #Tabela_TabSheet_Atributo Set 
	cd_tabela          	= @cd_tabela_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()


insert into 
	Tabela_TabSheet_Atributo
Select 
	* 
from 
	#Tabela_TabSheet_Atributo


----------------------------------------------------------------------------------------
--COPIA O Atributo
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Atributo
from 
	Atributo
where 
	cd_tabela = @cd_tabela_old

Update #Atributo Set 
	cd_tabela          	= @cd_tabela_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()

insert into 
	Atributo
Select 
	* 
from 
	#Atributo


----------------------------------------------------------------------------------------
--COPIA O Atributo_Classe
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Atributo_Classe
from 
	Atributo_Classe 
where 
	cd_tabela = @cd_tabela_old

Update #Atributo_Classe Set 
	cd_tabela          	= @cd_tabela_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()

insert into 
	Atributo_Classe
Select 
	* 
from 
	#Atributo_Classe
Print 'Lista de Valores'
----------------------------------------------------------------------------------------
--COPIA O Atributo_Lista_Valor
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Atributo_Lista_Valor
from 
	Atributo_Lista_Valor
where 
	cd_tabela = @cd_tabela_old

Update #Atributo_Lista_Valor Set 
	cd_tabela          	= @cd_tabela_new,
	cd_usuario_atualiza  = 99,
	dt_usuario           = GetDate()


insert into 
	Atributo_Lista_Valor
Select 
	* 
from 
	#Atributo_Lista_Valor
----------------------------------------------------------------------------------------
--COPIA O Indice
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Indice
from 
	Indice
where 
	cd_tabela = @cd_tabela_old

Update #Indice Set 
	cd_tabela 	         = @cd_tabela_new,
	cd_usuario_atualiza  = 99,
	dt_usuario           = GetDate()

insert into 
	Indice
Select 
	* 
from 
	#Indice

----------------------------------------------------------------------------------------
--COPIA O Indice_Atributo
----------------------------------------------------------------------------------------
Select 
	 * 
into 
	#Indice_Atributo
from 
	Indice_Atributo
where 
	cd_tabela= @cd_tabela_old

Update #Indice_Atributo Set 
	cd_tabela 	= @cd_tabela_new,
	cd_usuario           = 99,
	dt_usuario           = GetDate()


insert into 
	Indice_Atributo 
Select 
	* 
from 
	#Indice_Atributo

------------------------------------------------------------------------------
--Retorno
------------------------------------------------------------------------------
  if @@error = 0
  begin
    	commit transaction
		Select  'Código da Nova Tabela: ' +  cast(@cd_tabela_new as varchar(8))  as Retorno
	   print 'OK'
  end
  else
  begin
    	rollback transaction   
		Select  'Ocorreu um erro interno do Banco ao Cópiar Tabela!' as Retorno
		print 'ERROR'
  end

end
else
begin
	Select  'Código da Tabela: ' +  cast(@cd_tabela_old as varchar(8)) + ' não Existe ou a tabela: ' + @nm_tabela_new + ' já existe no sistema !' as Retorno
end


