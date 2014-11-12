-------------------------------------------------------------------------------  
--sp_helptext pr_copia_pedido_importacao
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Cópia do Pedido de importacao
--Data             : 05/12/2006
--Alteração        : 16.12.2006 - Ajuste do Status do Pedido de importacao - Carlos
--                 : 30.08.2007 - Checagem da data de emissão - Carlos
--                 : 13.10.2007 - Data de Emissão - Carlos Fernandes
-- 02.03.2009 - Desenvolvimento da Rotina - Carlos Fernandes
-------------------------------------------------------------------------------  
create procedure pr_copia_pedido_importacao
@cd_pedido_importacao_old int = 0,  
@cd_fornecedor            int = 0, 
@cd_usuario               int = 0,
@dt_pedido_importacao     datetime    
as  

--print 'Iniciou'  
  
declare @cd_pedido_importacao_new int  
declare @Tabela                   varchar(80)    

if @dt_pedido_importacao is null
begin
  set @dt_pedido_importacao = cast(convert(int,getdate(),103) as datetime)
end

--declare @dt_pedido_importacao     smalldatetime

-- select datepart(m,getdate()),datepart(d,getdate()),datepart(yyyy,getdate()),
--        cast( cast( datepart(m,getdate()) as varchar(2) )+'/'+cast(datepart(d,getdate()) as varchar(2))+'/'+cast(datepart(yyyy,getdate()) as varchar(4)) as datetime ) as dt_pedido_importacao

--set @dt_pedido_importacao = cast(convert(int,getdate(),103) as datetime)

--set @dt_pedido_importacao = convert(nvarchar, getdate() - Convert(nvarchar, getdate(),114),103)

-- set @dt_pedido_importacao =  cast( cast(datepart(m,getdate())     as varchar(2) )+'/'+
--                                cast(datepart(d,getdate())     as varchar(2) )+'/'+
--                                cast(datepart(yyyy,getdate() ) as varchar(4) ) as datetime ) 

--select @dt_pedido_importacao
  
if exists(Select top 1 * from Pedido_importacao      where cd_pedido_importacao = @cd_pedido_importacao_old) and   
   exists(Select top 1 cd_fornecedor from Fornecedor where cd_fornecedor = @cd_fornecedor)  
begin  
----------------------------------------------------------------------------------------  
--COPIA O USUARIO  
----------------------------------------------------------------------------------------  
--Inicia Transação  
Begin Transaction  
set @Tabela =  DB_NAME()+'.dbo.Pedido_importacao'
-- campo chave utilizando a tabela de códigos    
exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_importacao', @codigo = @cd_pedido_importacao_new output    

/**********************************************************************************************
COPIA o PEDIDO
**********************************************************************************************/
  
Select   
  *   
into   
 #Pedido_importacao  
from   
 Pedido_importacao  
where   
 cd_pedido_importacao = @cd_pedido_importacao_old  
  
--select * from pedido_importacao
--select * from status_pedido
--select * from pedido_importacao_item

Update #Pedido_importacao Set   
	cd_pedido_importacao  	= @cd_pedido_importacao_new,  
 	cd_fornecedor     	= @cd_fornecedor,  
 	cd_usuario           	= @cd_usuario,    
 	dt_usuario           	= GetDate(),
 	--dt_pedido_importacao     	= dbo.fn_data(GetDate()),  
        --dt_pedido_importacao        = cast(convert(int,getdate(),103) as datetime),

        dt_pedido_importacao        = @dt_pedido_importacao,

 	nm_ref_ped_imp   	= (case @cd_fornecedor
                     			when cd_fornecedor then    
                         			nm_ref_ped_imp    
                     			else    
                     				''      
                     			end)  ,
	dt_alteracao_pedido_imp       = GetDate(),
	dt_canc_pedido_importacao     = Null,
        nm_canc_pedido_importacao     = cast(null as varchar),
        cd_motivo_canc_ped_imp        = Null,
	nm_alteracao_pedido_imp       = 'Cópia do Pedido de Importacao: ' + cast(@cd_pedido_importacao_old as varchar),
	ic_fax_pedido_importacao      = 'N',
	ic_email_pedido_imp           = 'N',
	ic_fechado_ped_importacao     = 'N',
        dt_fechado_ped_importacao     = null,
        cd_status_pedido              = 15,    --Status em Aberto do Pedido de importacao
        dt_ativacao_pedido_importacao = null,
        nm_ativacao_pedido_importacao = null
        --ic_aprov_pedido_importacao    = 'N',
        --dt_nec_pedido_importacao      = getdate()     

  
insert into   
 Pedido_importacao  
Select   
 *   
from   
 #Pedido_importacao
	
update
  Pedido_importacao
set
  dt_pedido_importacao = @dt_pedido_importacao
where
  cd_pedido_importacao = @cd_pedido_importacao_new
  
----------------------------------------------------------------------------------------  
--COPIA OS ITENS
----------------------------------------------------------------------------------------  
Select   
  *   
into   
  #Pedido_importacao_Item
from   
 Pedido_importacao_Item  
where   
 cd_pedido_importacao = @cd_pedido_importacao_old  
  

--select * from pedido_importacao_item

  
Update #Pedido_importacao_Item Set   
	cd_pedido_importacao   		= @cd_pedido_importacao_new,  
 	cd_usuario           		= @cd_usuario,    
 	dt_usuario           		= GetDate(),
	--dt_item_pedido_importacao       = @dt_pedido_importacao,
	dt_cancel_item_ped_imp   	= Null,
	nm_motivo_cancel_item_ped       = '',
        qt_saldo_item_ped_imp           = qt_item_ped_imp,
        nm_motivo_ativ_item_ped         = null,
        dt_ativ_item_ped_imp            = null
--        dt_entrega_ped_imp             = @dt_pedido_importacao + isnull(qt_dia_entrega_item_ped,0)
        

insert into   
 Pedido_importacao_Item  
Select   
 *   
from   
 #Pedido_importacao_Item
  
drop table  #Pedido_importacao_Item  

----------------------------------------------------------------------------------------  
--COPIA Pedido_importacao_Aprovacao
--select * from pedido_importacao_aprovacao
----------------------------------------------------------------------------------------  
-- Select   
--   *   
-- into   
--   #Pedido_importacao_Aprovacao
-- from   
--  Pedido_importacao_Aprovacao 
-- where   
--  cd_pedido_importacao = @cd_pedido_importacao_old  
--   
--   
-- Update #Pedido_importacao_Aprovacao Set   
-- 	cd_pedido_importacao     	= @cd_pedido_importacao_new,  
--  	cd_usuario           	= @cd_usuario,    
--  	dt_usuario           	= GetDate()
  
-- insert into   
--  Pedido_importacao_Aprovacao
-- Select   
--  *   
-- from   
--  #Pedido_importacao_Aprovacao
  
--drop table  #Pedido_importacao_Aprovacao

----------------------------------------------------------------------------------------  
--COPIA Pedido_importacao_Aprovacao
----------------------------------------------------------------------------------------  
-- Select   
--   *   
-- into   
--   #Pedido_importacao_Follow
-- from   
--  Pedido_importacao_Follow
-- where   
--  cd_pedido_importacao = @cd_pedido_importacao_old  
--   
--   
-- Update #Pedido_importacao_Follow Set   
-- 	cd_pedido_importacao     	= @cd_pedido_importacao_new,  
--  	cd_usuario           	= @cd_usuario,    
--  	dt_usuario           	= GetDate()
  
-- insert into   
--  Pedido_importacao_Follow
-- Select   
--  *   
-- from   
--  #Pedido_importacao_Follow

--drop table #Pedido_importacao_Follow

------------------------------------------------------------------------------  
--Retorno  
------------------------------------------------------------------------------  
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_importacao_new, 'D'   

  if @@error = 0  
  begin  
     commit transaction  
  Select  'Código do Novo Pedido de Importação: ' +  cast(@cd_pedido_importacao_new as varchar(8))  as Retorno  , @cd_pedido_importacao_new as cd_pedido_importacao_new
    print 'OK'  
  end  
  else  
  begin  
     rollback transaction     
  Select  'Ocorreu um erro interno do Banco ao Cópiar Pedido importacao!' as Retorno, @cd_pedido_importacao_new  as cd_pedido_importacao_new 
  print 'ERROR'  
  end  
      -- limpeza da tabela de código --Precisa ser executado antes   
end  
else  
begin  
 Select  'Código do Pedido de importacao: ' +  cast(@cd_pedido_importacao_old as varchar(8)) + ' não Existe ou Fornecedor com código: ' + cast(@cd_fornecedor as varchar)  + ' Não existe !' as Retorno, 0  as cd_pedido_importacao_new   
end  
  
