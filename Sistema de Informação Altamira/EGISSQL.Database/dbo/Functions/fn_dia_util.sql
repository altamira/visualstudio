
CREATE FUNCTION fn_dia_util
(@dt_agenda      datetime = '',
 @ic_proximo     char(1)  = 'S',
 @cd_calendario  char(1)  = 'U')

-- @qt_dia_efetivo int      = 0) : Criar este novo parâmetro para processamento/Localizar os Locais.

RETURNS datetime

AS
BEGIN

  declare @iContador  int
  declare @dt_retorno datetime
  set     @dt_retorno = @dt_agenda

  if @ic_proximo = 'S'
   begin        

------------------------------------------------------------------------------
--Rotina para somar um dia antes de processar a busca da data.
--Verificar se é dia útil primeiro, localizar o próximo dia útil, depois 
--somar a quantidade de dias.
------------------------------------------------------------------------------
--
--      set @iContador = 0
-- 
--      while ( @iContador = 0 )
--      begin
-- 
--        --Verifica se a Data da Agenda é Dia útil
--        
--        set @icontador = 1
--   
--      end
------------------------------------------------------------------------------

     --Busca a Data Correta
  
       select 
         @dt_retorno = isnull(min(dt_agenda),@dt_agenda)
       from
         agenda
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
        agenda
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
           
END
