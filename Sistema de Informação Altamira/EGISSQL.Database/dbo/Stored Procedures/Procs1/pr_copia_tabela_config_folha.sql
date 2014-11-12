
-------------------------------------------------------------------------------
--sp_helptext pr_copia_tabela_config_folha
-------------------------------------------------------------------------------
--pr_copia_tabela_config_folha
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Lázaro
--Banco de Dados   : Egissql
--Objetivo         : Cópia de tabelas de inss/irrf/sal.fam/config folha
--Data             : 10.01.2010
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_tabela_config_folha

@cd_identificacao int         = 0 --CODIGO DO ULTIMO CONFIG


as

if @cd_identificacao>0
 
begin
  select
    *
  into 
    #config_mensal_folha
  from  
    config_mensal_folha 
  where
     cd_config_mensal_folha = @cd_identificacao
    
  --gera novo numero interno

  declare @Tabela            varchar(80)
  declare @cd_documento_novo int

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.config_mensal_folha' as varchar(80))

  -- campo chave utilizando a tabela de códigos  
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_config_mensal_folha', @codigo = @cd_documento_novo output  

  --while exists(Select top 1 'x' from config_mensal_folha where cd_config_mensal_folha = @cd_documento_novo)
  --begin
  --  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_config_mensal_folha', @codigo = @cd_documento_novo output
  --  -- limpeza da tabela de código
  --  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'
  --end


  --update do novo código 

  update
    #config_mensal_folha
  set
    cd_config_mensal_folha = @cd_documento_novo
    
  --gera cópia do documento

  insert into
    config_mensal_folha
  select
    *
  from
    #config_mensal_folha

  --Libero o novo código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_novo, 'D'

  --***************** 
  --IRRF   inicio
  --***************** 
  select
    *
  into 
    #Imposto_Renda
  from  
    Imposto_Renda 
  where
     cd_config_mensal_folha = @cd_identificacao
  
  --update do novo código e identificação

  update
    #Imposto_Renda
  set
    cd_config_mensal_folha = @cd_documento_novo

  --gera cópia do documento

  insert into
    Imposto_Renda
  select
    *
  from
    #Imposto_Renda

  --***************** 
  --IRRF   fim
  --***************** 



  --***************** 
  --INSS   inicio
  --***************** 
  select
    *
  into 
    #INSS
  from  
    INSS 
  where
     cd_config_mensal_folha = @cd_identificacao
   
  --update do novo código e identificação

  update
    #INSS
  set
    cd_config_mensal_folha = @cd_documento_novo

  --gera cópia do documento

  insert into
    INSS
  select
    *
  from
    #INSS

  --***************** 
  --INSS   fim
  --***************** 


  --***************** 
  --SALARIO FAMILIA  INICIO
  --***************** 
  select
    *
  into 
    #salario_familia
  from  
    salario_familia 
  where
     cd_config_mensal_folha = @cd_identificacao
     
   
  --update do novo código e identificação

  update
    #salario_familia
  set
    cd_config_mensal_folha = @cd_documento_novo

  --gera cópia do documento

  insert into
    salario_familia
  select
    *
  from
    #salario_familia

  --***************** 
  --SALARIO FAMILIA  FIM
  --*****************   
  



end


