CREATE FUNCTION fn_calcula_vencimento_imposto
(@dt_inicial datetime,
 @cd_dias_uteis int = 0,
 @ic_tipo_pagamento_imposto char(1),
 @ic_competencia char(1))
RETURNS datetime

--fn_calcula_vencimento_imposto
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Eduardo Baião
--Banco de Dados: EgisSql
--Objetivo: Calcular a data da competência baseando-se numa data inicial,
--          quantidade de dias e o tipo do Pagamento (Anual, Mensal, Semanal etc)
--
-- Data: 25/03/2004
-- Atualizações: 12/07/2005 - Acerto no Cálculo Semanal - ELIAS
--               13/07/2005 - Passa a retornar a Data de Competência ou o Vencimento - ELIAS
--               14/07/2005 - Desenvolvido rotina de Cálculo Quinzenal - ELIAS
--               01/08/2005 - Incluído Retorno de Início de Competência - ELIAS
--               02/08/2005 - Acerto no Retorno da Competência Inicial e Final do Período Quinzenal - ELIAS
--               25.11.2005 - Foi acertado o cálculo da data para considerar apenas dias úteis - Fabio Cesar

-- OBSERVAÇÃO - FALTA ENCONTRAR FÓRMULA DE ANOS BISSEXTOS - ELIAS
--               26.01.2006 - Fabio Cesar - Conform lei 11.196/05 Deverão ser aplicadas novas regras para o IRRF e PIS/COFINS
--                            seguindo apartir de janeiro/2006 a seguinte regra:
--                            IRRF: Até o último dia do primeiro descêncio do mês subsequente ao mês de ocorrência 
--                                  dos fatos geradores, nos casos de retenções: 0561 / 0588 / 1708 / 8045
--                                  (Ex. fatos geradores (pagtos ou créditos), ocorridos de 01/01/2006 a 31/01/2006 
--                                   recollher IRRF em 10/02/2006)
--                                  Havendo apenas algumas exceções a serem consideradas: 
--                                  *****************************************************
--                                  DEZEMBRO/06 - PRIMEIRO e SEGUNDO decêndios
--                                  *****************************************
--                                  Efetuar recolhimento até o 3º dia útil do decêncio subsequente, para as retenções
--                                  efetuadas no PRIMEIRO e SEGUNDO decêndios (Ex. No período de 01/12/06 a 20/12/06
--                                  recolher em 26/12/06)
--                                  *******************************
--                                  DEZEMBRO/06 - TERCEIRO decêndio
--                                  *******************************
--                                  Efetuar recolhimento até o último dia útil do primeiro decêncio subsequente, 
--                                  (Ex. No período de 21/12/06 a 31/12/06 recolher em 10/01/07)
--                                  *****************************************************
--                                  DEZEMBRO/07 - PRIMEIRO decêndio
--                                  *****************************************
--                                  Efetuar recolhimento até o 3º dia útil do decêncio subsequente, para as retenções
--                                  efetuadas no PRIMEIRO decêndio 
--                                  (Ex. No período de 01/12/07 a 10/12/07 recolher em 13/12/07)
--                                  *******************************
--                                  DEZEMBRO/06 - SEGUNDO e TERCEIRO decêndio
--                                  *******************************
--                                  Efetuar recolhimento até o último dia útil do primeiro decêncio subsequente, 
--                                  (Ex. No período de 11/12/07 a 31/12/07 recolher em 10/01/08)
--               30.01.2006 - Fabio Cesar - Foi alterado o procedimento para o calculo de quinzenal
-------------------------------------------------------------------------------------------------------------------
AS
BEGIN

  declare @dt_competencia datetime
  declare @dt_inicio_competencia datetime
  declare @dt_vencimento datetime
  declare @dt_retorno datetime

  declare @cd_dia_semana_inicial int

  set @cd_dias_uteis = isnull(@cd_dias_uteis,0)
  set @cd_dia_semana_inicial = datepart( weekday, @dt_inicial ) 
  
  -- Semanal
  if (@ic_tipo_pagamento_imposto = 'S')
  begin
    set @dt_competencia = dateadd(dd, 7-datepart(dw, @dt_inicial), @dt_inicial)    
    set @dt_inicio_competencia = dateadd(dd, -6, dateadd(dd, 7-datepart(dw, @dt_inicial), @dt_inicial))    
  end
  else
  -- Quinzenal
  if (@ic_tipo_pagamento_imposto = 'Q')
  begin

    if (datepart(dd, @dt_inicial) > 15)
    begin
      --Define o primeio dia de competencia como sendo sempre dia 16
      Select 
        @dt_inicio_competencia = dbo.fn_dia_util_fiscal(convert(datetime, cast(datepart(mm, @dt_inicial) as varchar)  
            + '/16/' + cast(datepart(yy, @dt_inicial) as varchar), 101),0,'N'),
        @dt_competencia = (case 
                              --Define se o mês possui 31 dias
                              when ( datepart(mm, @dt_inicial) in (1,3,5,7,8,10,12) ) then
                                convert(datetime, cast(datepart(mm, @dt_inicial) as varchar)  
                                  + '/31/' + cast(datepart(yy, @dt_inicial) as varchar), 101)
                              --Define se o mês possui 30 dias
                              when ( datepart(mm, @dt_inicial) in (4,6,9,11) ) then
                                convert(datetime, cast(datepart(mm, @dt_inicial) as varchar)  
                                  + '/30/' + cast(datepart(yy, @dt_inicial) as varchar), 101)
                              else
                                convert(datetime, cast(datepart(mm, @dt_inicial) as varchar)  
                                  + '/28/' + cast(datepart(yy, @dt_inicial) as varchar), 101)
                          end)

    end
    else
    begin
      --Define o primeio dia de competencia como sendo sempre dia 16
      Select 
        @dt_inicio_competencia = dbo.fn_dia_util_fiscal(convert(datetime, cast(datepart(mm, @dt_inicial) as varchar)  
            + '/01/' + cast(datepart(yy, @dt_inicial) as varchar), 101),0,'S'),
        @dt_competencia = convert(datetime, cast(datepart(mm, @dt_inicial) as varchar)  
                                  + '/15/' + cast(datepart(yy, @dt_inicial) as varchar), 101)

    end
  end
  else
  -- Especial
  if (@ic_tipo_pagamento_imposto = 'E') --Mensal com retenção no último dia do primeiro decêndio do MÊS
  begin
    --Verifica exceções
    --DEZEMBRO/06 - PRIMEIRO e SEGUNDO decêndios (ANO / MES / DIA)
    if ( @dt_inicial between convert(datetime, '12/01/2006', 101) and convert(datetime, '12/20/2006', 101))
      Select
          @dt_competencia = convert(datetime, '12/26/2006', 101),
          @dt_inicio_competencia = convert(datetime, '12/01/2006', 101)
    --DEZEMBRO/06 - TERCEIRO decêndio   
    else if ( @dt_inicial between  convert(datetime, '12/21/2006', 101) and convert(datetime, '12/31/2006', 101) )
      Select
          @dt_competencia = convert(datetime, '01/10/2007', 101),
          @dt_inicio_competencia = convert(datetime, '21/12/2006', 101)
    --DEZEMBRO/07 - PRIMEIRO decêndio
    else if ( @dt_inicial between convert(datetime, '12/01/2007', 101) and convert(datetime, '12/10/2007', 101) )
      Select
          @dt_competencia = convert(datetime, '12/13/2007', 101),
          @dt_inicio_competencia = convert(datetime, '12/01/2007', 101)
    --DEZEMBRO/07 - SEGUNDO e TERCEIRO decêndios
    else if ( @dt_inicial between convert(datetime, '12/11/2007', 101) and convert(datetime, '12/31/2007', 101) )
      Select
          @dt_competencia = convert(datetime, '01/10/2008', 101),
          @dt_inicio_competencia = convert(datetime, '12/11/2007', 101)
    --Regra geral para todos os demais casos
    else
    begin
      Select 
        @dt_inicial = DateAdd(mm, 1, @dt_inicial)

      --Define a conversão como sendo "mm/dd/yyyy"
      Select @dt_competencia =  dbo.fn_dia_util_fiscal(convert(datetime, cast(datepart(mm, @dt_inicial) as varchar) 
                                                            + '/01/' + cast(datepart(yy, @dt_inicial) as varchar) ,101),9,'S'),
             @cd_dias_uteis = 9

      -- O dia não poderá ser superior ao primeiro decêndio (10)
      while datepart(dd, @dt_competencia ) > 10
      begin
         Select @dt_competencia =  dbo.fn_dia_util_fiscal(convert(datetime, cast(datepart(mm, @dt_inicial) as varchar) 
                                                            + '/01/' + cast(datepart(yy, @dt_inicial) as varchar) ,101),@cd_dias_uteis,'S'),
         @cd_dias_uteis = @cd_dias_uteis -1
      end


      Select 
        @dt_inicial = DateAdd(mm, -1, @dt_inicial), 
        @cd_dias_uteis = -1

      Select
        @dt_inicio_competencia = convert(datetime, cast(datepart(mm, @dt_inicial) as varchar) 
                                                            + '/01/' + cast(datepart(yy, @dt_inicial) as varchar), 101)
    end

    --Define o vencimento como sendo a data da competência
    Select
      @dt_vencimento = @dt_competencia

  end
  else
  begin
    set @dt_competencia = @dt_inicial
    set @dt_inicio_competencia = @dt_inicial
  end

  if (@ic_tipo_pagamento_imposto = 'Q')
  begin
    select
      @dt_vencimento =  ( case 
                            when datepart(mm, dbo.fn_dia_util_fiscal(@dt_competencia, @cd_dias_uteis, 'N')) =
                                 datepart(mm,@dt_inicial) then
                                dbo.fn_dia_util_fiscal(@dt_competencia, @cd_dias_uteis, 'N') 
                            else
                                dbo.fn_dia_util_fiscal(@dt_competencia, @cd_dias_uteis, 'S')
                          end )

      --Caso a data de referencia for inferior ao dia 15 deverá ser colocado no período do mês
      if (datepart(dd, @dt_inicial) <= 15)
      begin
        while not ( datepart(mm, dbo.fn_dia_util_fiscal(@dt_competencia, @cd_dias_uteis, 'S')) =
                                 datepart(mm,@dt_inicial) )
        begin
          Select 
            @cd_dias_uteis = @cd_dias_uteis - 1,
            @dt_vencimento = dbo.fn_dia_util_fiscal(@dt_competencia, @cd_dias_uteis, 'S')
        end
      end

      Select @dt_competencia = dbo.fn_dia_util_fiscal(@dt_competencia,0,'S')
  end
  else  if (@ic_tipo_pagamento_imposto <> 'E')
    set @dt_vencimento = dbo.fn_dia_util_fiscal(@dt_competencia, @cd_dias_uteis, 'N')
 
  if @ic_competencia = 'S' 
    set @dt_retorno = @dt_competencia
  else if @ic_competencia = 'I' 
    set @dt_retorno = @dt_inicio_competencia
  else
    set @dt_retorno = @dt_vencimento

  return (dbo.fn_dia_util(@dt_retorno,'S','U')) --Desta forma será considerado apenas os dias úteis

end

