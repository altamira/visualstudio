-------------------------------------------------------------------------------  
--pr_copia_pedido_compra
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Márcio Rodrigues  
--Banco de Dados   : EgisSQL
--Objetivo         : Cópia do Pedido de Compra
--Data             : 05/12/2006
--Alteração        : 16.12.2006 - Ajuste do Status do Pedido de Compra - Carlos
--                 : 30.08.2007 - Checagem da data de emissão - Carlos
--                 : 13.10.2007 - Data de Emissão - Carlos Fernandes
-------------------------------------------------------------------------------  
create procedure pr_copia_pedido_compra  
@cd_pedido_compra_old int = 0,  
@cd_fornecedor        int = 0, 
@cd_usuario           int = 0,
@dt_pedido_compra     datetime    
as  

--print 'Iniciou'  
  
declare @cd_pedido_compra_new int  
declare @Tabela               varchar(50)    

if @dt_pedido_compra is null
begin
  set @dt_pedido_compra = cast(convert(int,getdate(),103) as datetime)
end

--declare @dt_pedido_compra     smalldatetime

-- select datepart(m,getdate()),datepart(d,getdate()),datepart(yyyy,getdate()),
--        cast( cast( datepart(m,getdate()) as varchar(2) )+'/'+cast(datepart(d,getdate()) as varchar(2))+'/'+cast(datepart(yyyy,getdate()) as varchar(4)) as datetime ) as dt_pedido_compra

--set @dt_pedido_compra = cast(convert(int,getdate(),103) as datetime)

--set @dt_pedido_compra = convert(nvarchar, getdate() - Convert(nvarchar, getdate(),114),103)

-- set @dt_pedido_compra =  cast( cast(datepart(m,getdate())     as varchar(2) )+'/'+
--                                cast(datepart(d,getdate())     as varchar(2) )+'/'+
--                                cast(datepart(yyyy,getdate() ) as varchar(4) ) as datetime ) 

--select @dt_pedido_compra
  
if exists(Select top 1 * from Pedido_Compra where cd_pedido_compra = @cd_pedido_compra_old) and   
   exists(Select top 1 cd_fornecedor from Fornecedor where cd_fornecedor = @cd_fornecedor)  
begin  
----------------------------------------------------------------------------------------  
--COPIA O USUARIO  
----------------------------------------------------------------------------------------  
--Inicia Transação  
Begin Transaction  
set @Tabela =  DB_NAME()+'.dbo.Pedido_Compra'
-- campo chave utilizando a tabela de códigos    
exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_compra', @codigo = @cd_pedido_compra_new output    

/**********************************************************************************************
COPIA o PEDIDO
**********************************************************************************************/
  
Select   
  *   
into   
 #Pedido_Compra  
from   
 Pedido_Compra  
where   
 cd_pedido_compra = @cd_pedido_compra_old  
  
--select * from pedido_compra
--select * from status_pedido
--select * from pedido_compra_item

Update #Pedido_Compra Set   
	cd_pedido_compra     	= @cd_pedido_compra_new,  
 	cd_fornecedor     	= @cd_fornecedor,  
 	cd_usuario           	= @cd_usuario,    
 	dt_usuario           	= GetDate(),
 	--dt_pedido_compra     	= dbo.fn_data(GetDate()),  
        --dt_pedido_compra        = cast(convert(int,getdate(),103) as datetime),

        dt_pedido_compra        = @dt_pedido_compra,

 	nm_ref_pedido_compra  	= (case @cd_fornecedor
                     			when cd_fornecedor then    
                         			nm_ref_pedido_compra    
                     			else    
                     				''      
                     			end)  ,
	dt_alteracao_ped_compra	 = GetDate(),
	dt_cancel_ped_compra     = Null,
        ds_cancel_ped_compra     = cast(null as varchar),
	ds_alteracao_ped_compra	 = 'Cópia do Pedido de Compra: ' + cast(@cd_pedido_compra_old as varchar),
	ic_fax_pedido_compra		 = 'N',
	ic_email_pedido_compra	 = 'N',
	ic_fechado_pedido_compra = 'N',
        cd_status_pedido         = 8,    --Status em Aberto do Pedido de Compra
        dt_ativacao_pedido_compra = null,
        ds_ativacao_pedido_compra = null,
        ic_aprov_pedido_compra    = 'N',
        dt_nec_pedido_compra      = getdate()     

  
insert into   
 Pedido_Compra  
Select   
 *   
from   
 #Pedido_Compra

update
  Pedido_Compra
set
  dt_pedido_compra = @dt_pedido_compra
where
  cd_pedido_compra = @cd_pedido_compra_new
  
----------------------------------------------------------------------------------------  
--COPIA OS ITENS
----------------------------------------------------------------------------------------  
Select   
  *   
into   
  #Pedido_Compra_Item
from   
 Pedido_Compra_Item  
where   
 cd_pedido_compra = @cd_pedido_compra_old  
  

--select * from pedido_compra_item

  
Update #Pedido_Compra_Item Set   
	cd_pedido_compra     		= @cd_pedido_compra_new,  
 	cd_usuario           		= @cd_usuario,    
 	dt_usuario           		= GetDate(),
	dt_item_pedido_compra 		= @dt_pedido_compra,
	dt_item_canc_ped_compra 	= Null,
	nm_item_motcanc_ped_compr       = '',
        qt_saldo_item_ped_compra        = qt_item_pedido_compra,
        nm_item_ativ_ped_compra         = null,
        dt_item_ativ_ped_compra         = null,
        ic_aprov_comprador_pedido       = 'N',
        dt_item_nec_ped_compra          = @dt_pedido_compra + isnull(qt_dia_entrega_item_ped,0),
        dt_entrega_item_ped_compr       = @dt_pedido_compra + isnull(qt_dia_entrega_item_ped,0)
        

insert into   
 Pedido_Compra_Item  
Select   
 *   
from   
 #Pedido_Compra_Item
  
drop table  #Pedido_Compra_Item  

----------------------------------------------------------------------------------------  
--COPIA Pedido_Compra_Aprovacao
----------------------------------------------------------------------------------------  
Select   
  *   
into   
  #Pedido_Compra_Aprovacao
from   
 Pedido_Compra_Aprovacao 
where   
 cd_pedido_compra = @cd_pedido_compra_old  
  
  
Update #Pedido_Compra_Aprovacao Set   
	cd_pedido_compra     	= @cd_pedido_compra_new,  
 	cd_usuario           	= @cd_usuario,    
 	dt_usuario           	= GetDate()
  
-- insert into   
--  Pedido_Compra_Aprovacao
-- Select   
--  *   
-- from   
--  #Pedido_Compra_Aprovacao
  
drop table  #Pedido_Compra_Aprovacao

----------------------------------------------------------------------------------------  
--COPIA Pedido_Compra_Aprovacao
----------------------------------------------------------------------------------------  
Select   
  *   
into   
  #Pedido_Compra_Follow
from   
 Pedido_Compra_Follow
where   
 cd_pedido_compra = @cd_pedido_compra_old  
  
  
Update #Pedido_Compra_Follow Set   
	cd_pedido_compra     	= @cd_pedido_compra_new,  
 	cd_usuario           	= @cd_usuario,    
 	dt_usuario           	= GetDate()
  
-- insert into   
--  Pedido_Compra_Follow
-- Select   
--  *   
-- from   
--  #Pedido_Compra_Follow

drop table #Pedido_Compra_Follow

------------------------------------------------------------------------------  
--Retorno  
------------------------------------------------------------------------------  
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_compra_new, 'D'   

  if @@error = 0  
  begin  
     commit transaction  
  Select  'Código do Novo Pedido de Compra: ' +  cast(@cd_pedido_compra_new as varchar(8))  as Retorno  , @cd_pedido_compra_new as cd_pedido_compra_new
    print 'OK'  
  end  
  else  
  begin  
     rollback transaction     
  Select  'Ocorreu um erro interno do Banco ao Cópiar Pedido Compra!' as Retorno, @cd_pedido_compra_new  as cd_pedido_compra_new 
  print 'ERROR'  
  end  
      -- limpeza da tabela de código --Precisa ser executado antes   
end  
else  
begin  
 Select  'Código do Pedido de Compra: ' +  cast(@cd_pedido_compra_old as varchar(8)) + ' não Existe ou Fornecedor com código: ' + cast(@cd_fornecedor as varchar)  + ' Não existe !' as Retorno, 0  as cd_pedido_compra_new   
end  
  
