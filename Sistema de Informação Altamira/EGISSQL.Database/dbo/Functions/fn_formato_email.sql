CREATE  FUNCTION fn_formato_email (
  @nm_email varchar(200) )
RETURNS varchar(255)
AS
BEGIN

  declare @nm_msg_erro varchar(255),
          @qt_count int
  
  select @nm_msg_erro = ''
  
  set @nm_email = ltrim(rtrim(@nm_email))

  --Caso não tenha sido informado um e-mail
  if ( @nm_email = '' ) 
  begin
    set @nm_msg_erro = 'E-mail não informado'
  end
  
  --Varre por caracteres especiais
  if ( @nm_msg_erro = '' )
  begin
    set @qt_count = 0
    while ( len(@nm_email) > @qt_count )
    begin
      set @qt_count = @qt_count + 1
      if substring(@nm_email,@qt_count,1) in ('!','#','$','%','¨','&','*','(',')','=','+','"',
        '[',']','{','}','<','>',':','/','(',')',',',' ')
      begin
        set @nm_msg_erro = 'E-mail com caracter ' + substring(@nm_email,@qt_count,1) + ' inválido'
        break
      end  
    end
  end
  
  --Varre por caracteres caracteres obrigatórios
  if ( @nm_msg_erro = '' )
  begin
    if CharIndex('@',@nm_email,0) = 0 
      set @nm_msg_erro = 'Não existe o caracter "@" para separação entre o usuário e o domínio da internet'
    else if (CharIndex('.',@nm_email, CharIndex('@',@nm_email,0)) = 0)
      set @nm_msg_erro = 'Não existe o caracter "." após o "@"'    
    else if CharIndex('.@',@nm_email,0) > 0 
      set @nm_msg_erro = 'Endereço inválido pois existe um "." antes do "@"'
    else if CharIndex('@.',@nm_email,0) > 0 
      set @nm_msg_erro = 'Endereço inválido pois existe um "." depois do "@"'
  end

  return @nm_msg_erro
END
