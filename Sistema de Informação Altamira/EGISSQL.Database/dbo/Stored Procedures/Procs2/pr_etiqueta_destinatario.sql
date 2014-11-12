
--sp_helptext pr_etiqueta_destinatario
-------------------------------------------------------------------------------
--pr_etiqueta_destinatario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Etiquetas para Destinatário
--Data             : 29.08.2007
--Alteração        : 13.04.2008 - Acerto para incluir o contato - Carlos Fernandes
--24.04.2008 - Ajuste do Contato - Carlos Fernandes 
-----------------------------------------------------------------------------------
create procedure pr_etiqueta_destinatario
as

--Dentro do Delphi
--
-- declare @ic_parametro int
-- 
-- set @ic_parametro = :ic_parametro
-- 
-- if @ic_parametro = 1
-- begin
-- 
--      IF EXISTS (SELECT name
-- 	   FROM   tempdb.dbo.sysobjects
-- 	   WHERE  name = N'##SelecaoDestinatario'
-- 	   AND 	  type = 'U')
--      DROP TABLE ##SelecaoDestinatario
-- end
-- else if @ic_parametro = 2
-- begin
--      Create Table ##SelecaoDestinatario (
-- 	cd_destinatario int
--      )
-- end
-- else if @ic_parametro = 3
-- begin
--      Insert into ##SelecaoDestinatario Values (:cd_destinatario)
-- end


--select * from vw_destinatario
--select * from cliente_contato

Declare @SQL varchar(8000)

Create Table #DestinatarioSelecao(
        cd_tipo_destinatario int,
        cd_destinatario      int,
        cd_contato           int,
	nm_razao_social	     varchar(60),
	End1  		     varchar(500),
	End2  		     varchar(500),
        nm_contato           varchar(60))

Set @SQL =

--'if exists(Select * from sysobjects
--          where name = ''##SelecaoDestinatario'' and
--                xtype = ''U'' AND
--                uid = 1 ) '+
--
-- ' begin '+
 ' Insert into #DestinatarioSelecao '+  
 ' Select d.cd_tipo_destinatario,
       d.cd_destinatario,    
       isnull(s.cd_contato,0) as cd_contato,
       isnull(nm_razao_social, nm_fantasia) as nm_razao_social,  
       rtrim(nm_endereco) +'' , '' + rtrim(cd_numero_endereco)+'' ''+ nm_complemento_endereco +'' ''+ rtrim(nm_bairro) as End1,  
       rtrim(d.nm_cidade) + '' '' + rtrim(d.sg_estado) + '' Cep:'' +  substring(cast(cd_cep as char(8)), 1, 5) +''-''+         
       substring(cast(cd_cep as char(8)), 6, 8) as End2, cast(isnull(cc.nm_contato_cliente,'''') as varchar(60)) as nm_contato
from vw_destinatario d with (nolock) 
     inner join ##SelecaoDestinatario s with (nolock) on d.cd_destinatario = s.cd_destinatario and d.cd_tipo_destinatario = 1                                              
     left outer join cliente_contato cc on cc.cd_cliente = d.cd_destinatario and cc.cd_contato = s.cd_contato'
--+
--' end '


--Select * from #DestinatarioSelecao
exec(@sql)

--select * from ##SelecaoDestinatario
--Select * from #DestinatarioSelecao

Create Table #EtiquetaDestinatario(  
	nm_razao_social_col1  	varchar(60),
	nm_end_col1  		varchar(500),
	nm_end2_col1  		varchar(500),
        nm_contato1             varchar(60),
	nm_razao_social_col2 	varchar(60),
	nm_end_col2  		varchar(500),
	nm_end2_col2  		varchar(500),
        nm_contato2             varchar(60))

Declare @cd_tipo_destinatario int
Declare @cd_destinatario      int
declare @cd_contato           int

Declare @nm_razao_social_col1 varchar(60)
Declare @nm_end_col1          varchar(500)
Declare @nm_end2_col1         varchar(500)
Declare @nm_contato1          varchar(60)

Declare @nm_razao_social_col2 varchar(60)
Declare @nm_end_col2          varchar(500)
Declare @nm_end2_col2         varchar(500)
declare @nm_contato2          varchar(60)


while exists(Select top 1 'x' from #DestinatarioSelecao)
begin
     	Select top 1 
           @cd_tipo_destinatario  = d.cd_tipo_destinatario,
           @cd_destinatario       = d.cd_destinatario, 
           @cd_contato            = d.cd_contato,
           @nm_razao_social_col1  = d.nm_razao_social, 
           @nm_end_col1           = End1, 
           @nm_end2_col1          = End2,
           @nm_contato1           = nm_contato
        from 
           #DestinatarioSelecao d

        --Busca o Contato do cliente
--         if @cd_tipo_destinatario = 1
--         begin
--           --select * from cliente_contato
--           set @nm_contato1 = (select top 1 nm_contato_cliente from cliente_contato with (nolock)
--                               where cd_cliente = @cd_destinatario and
--                                     isnull(ic_mala_direta_contato,'N')='S' )
--         end

     	Delete from #DestinatarioSelecao where cd_destinatario = @cd_destinatario and 
                                               cd_contato      = @cd_contato		

     	Select top 1 
           @cd_tipo_destinatario  = d.cd_tipo_destinatario,
           @cd_destinatario       = d.cd_destinatario, 
           @cd_contato            = d.cd_contato,
           @nm_razao_social_col2  = d.nm_razao_social, 
           @nm_end_col2           = End1, 
           @nm_end2_col2          = End2,
           @nm_contato2           = nm_contato  
        from 
           #DestinatarioSelecao d

--         if @cd_tipo_destinatario = 1
--         begin
--           --select * from cliente_contato
--           set @nm_contato2 = (select top 1 nm_contato_cliente from cliente_contato with (nolock)
--                               where cd_cliente = @cd_destinatario and
--                                     isnull(ic_mala_direta_contato,'N')='S' )
--         end


     	Delete from #DestinatarioSelecao where cd_destinatario = @cd_destinatario and
                                               cd_contato      = @cd_contato		

        insert into 
          #EtiquetaDestinatario (nm_razao_social_col1 ,
                                nm_end_col1, 
                                nm_end2_col1, 
                                nm_contato1,
                                nm_razao_social_col2 ,
                                nm_end_col2, 
                                nm_end2_col2,
                                nm_contato2) 
	Values
          (isnull(@nm_razao_social_col1,''),
           isnull( @nm_end_col1,''), 
           isnull(@nm_end2_col1,''),
           isnull(@nm_contato1,''),
           isnull(@nm_razao_social_col2,''), 
           isnull(@nm_end_col2,''), 
           isnull(@nm_end2_col2,''),
           isnull(@nm_contato2,'') )	


end

Drop table #DestinatarioSelecao


--Mostra a Tabela montada para Impressão

Select * from #EtiquetaDestinatario
order by
  nm_razao_social_col1

Drop Table #EtiquetaDestinatario

