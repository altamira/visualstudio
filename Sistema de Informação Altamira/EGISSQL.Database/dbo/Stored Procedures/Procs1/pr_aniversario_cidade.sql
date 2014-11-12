
CREATE PROCEDURE pr_aniversario_cidade
@ic_parametro as int,
@nm_cidade as varchar(60),
@sg_cidade as char(10)

as

begin
-----------------------------  Realiza Pesquisa Geral  -----------------------------------------
if @ic_parametro = 1
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     c.cd_cidade,
     c.nm_cidade,
     c.sg_cidade,
     c.dt_aniversario_cidade,
     cf.dt_cidade_feriado,
     cf.nm_obs_cidade_feriado,
     Isnull(Cast(Year(GetDate()) - Year(c.dt_Aniversario_Cidade) as Integer),0) as Anos,
     Dia_Semana = Case DATEPART(dw, cf.dt_cidade_feriado) 
                     When 1 Then 'Domingo'
                     When 2 Then 'Segunda-Feira'
                     When 3 Then 'Terça-Feira'
                     When 4 Then 'Quarta-Feira'
                     When 5 Then 'Quinta-Feira'
                     When 6 Then 'Sexta-Feira'
                     When 7 Then 'Sábado'
                  End
   from 
     cidade c inner join
     cidade_feriado cf on (c.cd_cidade = cf.cd_cidade) 
  end

--***-

else
-------------------------  Realiza Pesquisa por Nome  ----------------------------------------
if @ic_parametro = 2
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     c.cd_cidade,
     c.nm_cidade,
     c.sg_cidade,
     c.dt_aniversario_cidade,
     cf.dt_cidade_feriado,
     cf.nm_obs_cidade_feriado,
     Isnull(Cast(Year(GetDate()) - Year(c.dt_Aniversario_Cidade) as Integer),0) as Anos,
     Dia_Semana = Case DATEPART(dw, cf.dt_cidade_feriado) 
                     When 1 Then 'Domingo'
                     When 2 Then 'Segunda-Feira'
                     When 3 Then 'Terça-Feira'
                     When 4 Then 'Quarta-Feira'
                     When 5 Then 'Quinta-Feira'
                     When 6 Then 'Sexta-Feira'
                     When 7 Then 'Sábado'
                  End
   from 
     cidade c inner join
     cidade_feriado cf on (c.cd_cidade = cf.cd_cidade) 
   where c.nm_cidade like @nm_cidade + '%'
  end

--***-

else
-----------------------------  Realiza Pesquisa por Sigla  ---------------------------------
if @ic_parametro = 3
-----------------------------------------------------------------------------------------------------
  Begin
   Select 
     c.cd_cidade,
     c.nm_cidade,
     c.sg_cidade,
     c.dt_aniversario_cidade,
     cf.dt_cidade_feriado,
     cf.nm_obs_cidade_feriado,
     Isnull(Cast(Year(GetDate()) - Year(c.dt_Aniversario_Cidade) as Integer),0) as Anos,
     Dia_Semana = Case DATEPART(dw, cf.dt_cidade_feriado) 
                     When 1 Then 'Domingo'
                     When 2 Then 'Segunda-Feira'
                     When 3 Then 'Terça-Feira'
                     When 4 Then 'Quarta-Feira'
                     When 5 Then 'Quinta-Feira'
                     When 6 Then 'Sexta-Feira'
                     When 7 Then 'Sábado'
                  End
   from 
     cidade c inner join
     cidade_feriado cf on (c.cd_cidade = cf.cd_cidade) 
   where c.sg_cidade like @sg_cidade + '%'
  end
end

