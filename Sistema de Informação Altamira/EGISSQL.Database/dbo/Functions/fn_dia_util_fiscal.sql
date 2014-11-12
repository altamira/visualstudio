
--fn_dia_util_fiscal
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. da Silva
--Banco de Dados: EgisSql
--Objetivo: Retorna o Dia Útil após a Quantidade de Dias Indicada - Calendário Fiscal
-- utilizando feriados e sábado e domingos como dia não útil - ELIAS
-- Data: 02/08/2005
-----------------------------------------------------------------------------------------
create function fn_dia_util_fiscal(@dt_inicial datetime,
                                   @qt_dias int,
                                   @ic_antecipa char(1))
returns datetime
as
begin

   declare @v_dia_util char(1)
   declare @a varchar(3)
   declare @b int
   declare @c int

   declare @dt_retorno datetime
   

   set @v_dia_util = 'N'
   set @a = 'NAO'

   if @ic_antecipa = 'S'
     set @b = @qt_dias
   else
     set @b = 0

   set @c = 0

   while @a <> 'OK'
   begin

      if exists(select 'X' from Agenda_Feriado
                where dt_agenda_feriado = dateadd(day, @b, @dt_inicial)) or
         ((datepart(dw, @dt_inicial + @b) = 7) or (datepart(dw, @dt_inicial + @b) = 1)) 
        set @v_dia_util = 'N'
      else
        set @v_dia_util = 'S'

      if @ic_antecipa = 'S'
      begin
     
        if @v_dia_util = 'N'
          set @b = @b - 1
        else
          set @a = 'OK'

      end
      else     
      begin
        if @v_dia_util = 'S'
        begin
           set @c = @c + 1
                    
           if (@c = @qt_dias) or (@qt_dias = 0)
           begin
              set @a = 'OK'
           end
         
        end
      
        set @b = @b + 1
     end

   end

   if @ic_antecipa = 'S'
     set @dt_retorno = @dt_inicial + @b
   else
     set @dt_retorno = @dt_inicial + @b - 1 

   return(@dt_retorno)
           
end

