

/****** Object:  Stored Procedure dbo.pr_custo_financeiro    Script Date: 13/12/2002 15:08:26 ******/


CREATE PROCEDURE pr_custo_financeiro

  @cd_empresa   integer, --Código da empresa
  @vl_taxa      float  , --Valor da taxa de custo financeiro da empresa
  @ic_parametro integer, --Quando = 1 Cálculo somente do dia, quando = 2 fazer cálculo por faixa de valor, quando = 3 fazer cálculo em número de meses
  @qt_calculo   float    --Quando @ic_parametro = 1 @qt_calculo será considerada como quantidade de dias
                         --Quando @ic_parametro = 2 @qt_calculo será considerada como uma faixa entre 1 até o número informado em @qt_calculo
                         --Quando @ic_parametro = 3 @qt_calculo será considerada como quantidade de meses

AS


  --Caso não seje passada uma taxa buscar taxa no cadastro da empresa
  if @vl_taxa = 0.0
  begin
  
    --Buscando taxa de custo financeiro mensal da empresa informada
    select
      @vl_taxa = vl_tx_mensal_cust_fin
    from
      EGISAdmin.dbo.Empresa
    where
      cd_empresa = @cd_empresa
  end
---------------------------------------------------------
  if @ic_parametro = 3 --Rotina para cálculo mensal
---------------------------------------------------------
  begin
    set @ic_parametro = 1
    set @qt_calculo = @qt_calculo * 30
  end

---------------------------------------------------------
  if @ic_parametro = 1 --Rotina para cálculo de somente 1 dia
---------------------------------------------------------
  begin
    select ((POWER(((@vl_taxa / 100.0) + 1.0), (@qt_calculo / 30.0)) * 100.0) -100.0) as vl_calculo
  end
  else
---------------------------------------------------------
    if @ic_parametro = 2 --Rotina para cálculo de um período
---------------------------------------------------------
    begin

      declare @count int --Contador do loop para criação da tabela temporária
      set @count = 1

       --Criando tabela temporária para cálculo
       create table
         #Temp_Calculo
         (cd_dia int,
          vl_calculo float)
      
       while @count <= @qt_calculo
       begin
        
         --Inserindo registro na tabela temporária
         insert into
           #Temp_Calculo
         values
         (
           @count,
         ((POWER(((@vl_taxa / 100.0) + 1.0), (@count / 30.0)) * 100.0) -100.0)           
         )
     
         set @count = @count + 1
       end
       
      select * from #Temp_Calculo
      
      drop table #Temp_Calculo
                
    end




