
-------------------------------------------------------------------------------
--pr_etiqueta_medico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_etiqueta_medico
as
Declare @SQL varchar(8000)

Create Table #MedicoSelecao(
   cd_medico int,
	nm_medico  	varchar(60),
	End1  		varchar(500),
	End2  		varchar(500),
)

Set @SQL = ' Insert into #MedicoSelecao   
Select m.cd_medico,    
    isnull(nm_medico, nm_fantasia_medico) as nm_medico,  
      rtrim(nm_endereco_medico) +'' , '' + rtrim(cd_numero_endereco)+'' ''+ nm_complemento_endereco +'' ''+ rtrim(nm_bairro_medico) as End1,  
      rtrim(cid.nm_cidade) + '' '' + rtrim(est.sg_estado) + '' Cep:'' +  substring(cast(cd_cep as char(8)), 1, 5) +''-''+         
  substring(cast(cd_cep as char(8)), 6, 8) as End2  
from Medico m left join  
   Cidade cid on (m.cd_cidade = cid.cd_cidade) left join  
   Estado est on (m.cd_estado = est.cd_estado) left join  
     Medico_Especialidade me on  (m.cd_medico = me.cd_medico)  
where m.cd_medico in (Select s.cd_medico from ##SelecaoMedico as S)
'

--Select * from #MedicoSelecao
exec(@sql)

--Select * from #MedicoSelecao

Create Table #EtiquetaMedico(
	nm_medico_col1  	varchar(60),
	nm_end_col1  		varchar(500),
	nm_end2_col1  		varchar(500),
	nm_medico_col2 	varchar(60),
	nm_end_col2  		varchar(500),
	nm_end2_col2  		varchar(500)
)

Declare @cd_medico int

Declare @nm_medico_col1 varchar(60)
Declare @nm_end_col1 varchar(500)
Declare @nm_end2_col1 varchar(500)

Declare @nm_medico_col2 varchar(60)
Declare @nm_end_col2 varchar(500)
Declare @nm_end2_col2 varchar(500)


while exists(Select top 1 'x' from #MedicoSelecao)
begin
     	Select top 1 @cd_medico = m.cd_medico, @nm_medico_col1 = m.nm_medico, @nm_end_col1 = End1, @nm_end2_col1 = End2  from #MedicoSelecao m    	
     	Delete from #MedicoSelecao where cd_medico = @cd_medico		

  	 	Select top 1 @cd_medico = m.cd_medico, @nm_medico_col2 = m.nm_medico, @nm_end_col2 = End1, @nm_end2_col2 = End2  from #MedicoSelecao m    	
     	Delete from #MedicoSelecao where cd_medico = @cd_medico		

		insert into #EtiquetaMedico (nm_medico_col1 ,nm_end_col1, nm_end2_col1, nm_medico_col2 ,nm_end_col2, nm_end2_col2) 
		Values (isnull(@nm_medico_col1,''),isnull( @nm_end_col1,''), isnull(@nm_end2_col1,''), isnull(@nm_medico_col2,''), isnull(@nm_end_col2,''), isnull(@nm_end2_col2,''))	


end

Drop table #MedicoSelecao



Select * from #EtiquetaMedico

Drop Table #EtiquetaMedico
