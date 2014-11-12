
CREATE FUNCTION fn_dia_util_efetivo
(@dt_agenda      datetime = '',
 @ic_proximo     char(1)  = 'S',
 @cd_calendario  char(1)  = 'U',
 @qt_dia_efetivo int      = 0) --: Criar este novo parâmetro para processamento/Localizar os Locais.

RETURNS datetime

AS
BEGIN

  declare @iContador      int
  declare @ic_valida_data char(1) 
  declare @dt_retorno     datetime

  set     @dt_agenda  = convert(datetime,left(convert(varchar,@dt_agenda,121),10)+' 00:00:00',121)
  set     @dt_retorno = @dt_agenda

  if @ic_proximo = 'S'
  begin        

------------------------------------------------------------------------------
--Rotina para somar um dia antes de processar a busca da data.
--Verificar se é dia útil primeiro, localizar o próximo dia útil, depois 
--somar a quantidade de dias.
------------------------------------------------------------------------------

      set @iContador = 0
 
      while ( @iContador = 0 )
      begin
 
        --Verifica se a Data da Agenda é Dia útil

       select 
         @ic_valida_data = isnull(
         case @cd_calendario 
           when 'U' then ic_util
           when 'F' then ic_financeiro 
           when 'V' then ic_plantao_vendas
           when 'I' then ic_fiscal
           when 'O' then ic_fabrica_operacao
         end,'N')

       from
         agenda with (nolock)
       where
         dt_agenda = @dt_agenda and
         case @cd_calendario 
           when 'U' then ic_util
           when 'F' then ic_financeiro 
           when 'V' then ic_plantao_vendas
           when 'I' then ic_fiscal
           when 'O' then ic_fabrica_operacao
         end = 'S'

        if @ic_valida_data = 'S' 
           set @icontador = 1
        else
          set @dt_agenda = @dt_agenda + 1 
   
      end


      if @qt_dia_efetivo>0 
      begin
        set @dt_agenda = @dt_agenda + isnull(@qt_dia_efetivo,0)
      end

------------------------------------------------------------------------------

     --Busca a Data Correta
  
       select 
         @dt_retorno = isnull(min(dt_agenda),@dt_agenda)
       from
         agenda with (nolock) 
       where
         dt_agenda >= @dt_agenda and
         case @cd_calendario 
           when 'U' then ic_util
           when 'F' then ic_financeiro 
           when 'V' then ic_plantao_vendas
           when 'I' then ic_fiscal
           when 'O' then ic_fabrica_operacao
         end = 'S'
 
    end
  else
    begin

      select 
        @dt_retorno = isnull(max(dt_agenda),@dt_agenda)
      from
        agenda with (nolock) 
      where
        dt_agenda <= @dt_agenda and
        case @cd_calendario 
          when 'U' then ic_util
          when 'F' then ic_financeiro 
          when 'V' then ic_plantao_vendas
          when 'I' then ic_fiscal
          when 'O' then ic_fabrica_operacao
        end = 'S'
  end

  return(@dt_retorno)

--  return(@dt_agenda)
           
END

-- declare @dt datetime
-- set @dt='05/22/2008'
-- select @dt+ 1
--select * from ano
--select * from agenda_feriado

