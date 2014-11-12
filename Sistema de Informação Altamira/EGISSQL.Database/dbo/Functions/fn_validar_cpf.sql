create function fn_validar_cpf(@cpf varchar(11))
returns char(1)
as
begin
  declare @indice int,
          @soma int,
          @dig1 int,
          @dig2 int,
          @cpf_temp varchar(11),
          @digitos_iguais char(1),
          @resultado char(1)
          
  set @resultado = 'n'
  set @cpf_temp = substring(@cpf,1,1)
  set @indice = 1
  set @digitos_iguais = 's'

  while (@indice <= 11)
  begin
    if substring(@cpf,@indice,1) <> @cpf_temp
      set @digitos_iguais = 'n'
    set @indice = @indice + 1
  end;

  --caso os digitos não sejão todos iguais começo o calculo do digitos
  if @digitos_iguais = 'n' 
  begin
    --cálculo do 1º dígito
    set @soma = 0
    set @indice = 1
    while (@indice <= 9)
    begin
      set @soma = @soma + convert(int,substring(@cpf,@indice,1)) * (11 - @indice);
      set @indice = @indice + 1
    end

    set @dig1 = 11 - (@soma % 11)

    if @dig1 > 9
      set @dig1 = 0;

    -- cálculo do 2º dígito }
    set @soma = 0
    set @indice = 1
    while (@indice <= 10)
    begin
      set @soma = @soma + convert(int,substring(@cpf,@indice,1)) * (12 - @indice);
      set @indice = @indice + 1
    end

    set @dig2 = 11 - (@soma % 11)

    if @dig2 > 9
      set @dig2 = 0;

    -- validando
    if (@dig1 = substring(@cpf,len(@cpf)-1,1)) and (@dig2 = substring(@cpf,len(@cpf),1))
      set @resultado = 's'
    else
      set @resultado = 'n'
  end
  return @resultado
end 
