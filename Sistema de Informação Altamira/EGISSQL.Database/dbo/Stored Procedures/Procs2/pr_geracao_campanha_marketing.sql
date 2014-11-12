

/****** Object:  Stored Procedure dbo.pr_geracao_campanha_marketing    Script Date: 13/12/2002 15:08:31 ******/
--pr_geracao_campanha_marketing
-----------------------------------------------------------------------------------
--GBS-Global Business Solution
--Stored Procedure : SQL Server Microsoft 7.0  
--Fabio Cesar Magalhaes         
--Geraçao da Campanha de Marketing
--Data       : 11.Junho.2001
--Atualizado : 11/Dezembro/2001
--             
-----------------------------------------------------------------------------------
CREATE procedure pr_geracao_campanha_marketing
@cd_campanha       int,
@cd_usuario        int
as
/* Comentário feito por Fabio, para busca de dados no banco GBS-BANCO
   caso haja a necessidade de uma alteraçao do mesmo me comunique
-- Clientes
select ctc_cli,
       fan_cli,
       raz_cli,
       email,
       'fax_cli'=
       case 
       when CHARINDEX('11',ddd_cli)>0 then cast(cast(fax_cli as int) as varchar (10)) 
       else '021'+right(ddd_cli,2)+cast(cast(fax_cli as int) as varchar (10))
       end
       
into #Aux_cli1
from
  sap.dbo.cadcli
where
  email is not null and
  CharIndex('@',email,1) > 0
order by fan_cli
-- Contatos
select 
       a.ctc_cli,
       a.fan_cli,
       a.raz_cli,
       a.email,
       'fax_cli'=
       case 
       when CHARINDEX('11',a.ddd_cli)>0 then cast(cast(a.fax_cli as int) as varchar (10)) 
       else '021'+right(a.ddd_cli,2)+cast(cast(a.fax_cli as int) as varchar (10))
       end,
       b.cod_co,
       b.nom_co,
       b.eml_co
into #Aux_cli2
from
  sap.dbo.cadcli a, 
  sap.dbo.cadcon b
where
  a.fan_cli = b.fan_co and
  b.eml_co  is not null and
  CharIndex('@',b.eml_co,1) > 0
order by a.fan_cli,
         b.nom_co 
-- Clientes da Internet
--sp_addlinkedserver '10.0.0.2'
select 
       a.cadastroID,
       a.Empresa,
       a.Nome,
       a.EMail,
       a.Fax
into #Aux_cli3
from
   polimold.dbo.tb_cadastro a
--  [10.0.0.2].polimold.dbo.tb_cadastro a
where
  a.EMail is not null and
  CharIndex('@',EMail,1) > 0
order by a.cadastroID
--
-- Gravacao da Tabela Auxiliar da Campanha
--
declare @nm_fantasia_cliente char(15)
declare @cd_item_campanha    int
declare @nm_email_cliente    varchar(100)
declare @cd_contato          int
declare @cd_fax_cliente      varchar(15)
declare @cd_cliente_internet int
declare @cd_cliente          int
declare @nm_contato          char(40)
set @cd_item_campanha    = 0  
set @cd_contato          = 0
set @cd_fax_cliente      = ''
set @cd_cliente_internet = 0 
while exists ( select * from #Aux_cli1 )
begin
  select @cd_cliente          = ctc_cli,
         @nm_fantasia_cliente = fan_cli,
         @nm_email_cliente    = email,
         @cd_fax_cliente      = fax_cli
  from
     #Aux_cli1
  set @cd_item_campanha  = @cd_item_campanha + 1  
  --Insere o registro da campanha
  insert into Campanha_Cliente 
  values
    ( @cd_campanha,@nm_fantasia_cliente,@cd_item_campanha,@cd_contato,@cd_cliente_internet,
      @nm_email_cliente,@cd_fax_cliente,null,@cd_usuario,getdate() )
  delete from #Aux_cli1
  where
     ctc_cli = @cd_cliente and
     fan_cli = @nm_fantasia_cliente 
end
-- Processamento dos contatos
set @cd_item_campanha  = ( select max(cd_item_campanha_cliente) from campanha_cliente where cd_campanha = @cd_campanha ) + 1 
while exists ( select * from #Aux_cli2 )
begin
  select @cd_cliente          = ctc_cli,
         @nm_fantasia_cliente = fan_cli,
         @cd_contato          = cod_co,
         @nm_contato          = nom_co,
         @nm_email_cliente    = eml_co,
         @cd_fax_cliente      = fax_cli
  from
     #Aux_cli2
  if not exists( select cd_campanha from campanha_cliente 
                 where nm_fantasia_cliente = @nm_fantasia_cliente and
                       nm_email_cliente_campanha = @nm_email_cliente )
  begin
    --Insere o registro da campanha
    insert into Campanha_Cliente 
    values
      ( @cd_campanha,@nm_fantasia_cliente,@cd_item_campanha,@cd_contato,@cd_cliente_internet,
        @nm_email_cliente,@cd_fax_cliente,null,@cd_usuario,getdate() )
    set @cd_item_campanha  = @cd_item_campanha + 1  
  end
  delete from #Aux_cli2
  where
     ctc_cli = @cd_cliente and
     cod_co  = @cd_contato
end
-- Processamento dos clientes da internet
set @cd_item_campanha  = ( select max(cd_item_campanha_cliente) from campanha_cliente where cd_campanha = @cd_campanha ) + 1 
set @cd_contato = 0
while exists ( select * from #Aux_cli3 )
begin
  select @cd_cliente_internet = cadastroID,
         @nm_fantasia_cliente = substring(empresa,1,15),
         @nm_email_cliente    = email
  from
     #Aux_cli3
  if not exists( select * from campanha_cliente 
                 where nm_email_cliente_campanha = @nm_email_cliente )
  begin
    --Insere o registro da campanha
    insert into Campanha_Cliente 
    values
      ( @cd_campanha,@nm_fantasia_cliente,@cd_item_campanha,@cd_contato,@cd_cliente_internet,
        @nm_email_cliente,@cd_fax_cliente,null,@cd_usuario,getdate() )
    set @cd_item_campanha  = @cd_item_campanha + 1  
  end
  delete from #Aux_cli3
  where
     cadastroID = @cd_cliente_internet
*/
  --Apaga os clientes cadastrados na campanha antiga
  drop table EGISSQL.dbo.Campanha_cliente
  --Insere na tabela de campanha_cliente os clientes vinculados a campanha
  select 
    @cd_campanha   	  	as 'cd_campanha',
    nm_razao_social_cliente   	as 'nm_fantasia_cliente',
    identity(int,1,1) 	  	as 'cd_item_campanha_cliente',
    null    		  	as 'cd_contato',
    null	      	  		as 'cd_cliente_internet',
    cd_email_contato_cliente	as 'nm_email_cliente_campanha',
    cd_fax_contato		as 'cd_fax_cliente_campanha',
    cd_telefone_contato		as 'cd_tel_cliente_campanha',
    null				as 'cd_campanha_mensagem',
    @cd_usuario			as 'cd_usuario',
    getdate()	      		as 'dt_usuario',
    nm_contato_cliente		as 'nm_contato'
  into
    EGISSQL.dbo.Campanha_cliente
  from
    (
    Select 
--           b.cidade,
--           a.codarea,
           a.nm_razao_social_cliente,
           b.nm_contato_cliente,
--           b.Cargo,
           b.cd_email_contato_cliente,
           b.cd_telefone_contato,
           b.cd_fax_contato
--           b.estado
    from
     EGISSQL.dbo.Cliente a, EGISSQL.dbo.Cliente_Contato b
    Where
      a.cd_cliente = b.cd_cliente and
      isnull(b.cd_email_contato_cliente,'') <> '' and
      CharIndex('@',b.cd_email_contato_cliente,1) > 0
    ) as Filtro
   order by nm_fantasia_cliente
--end

