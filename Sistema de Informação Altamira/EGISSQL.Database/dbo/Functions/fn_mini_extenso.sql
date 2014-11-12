

CREATE FUNCTION fn_mini_extenso
(@nm_trio  char(3))

RETURNS varchar(500)
AS
BEGIN

  declare
  @Unidade	varchar(500),
  @Dezena	varchar(500),
  @Centena	varchar(500)

  declare
  @Unidades table
   (cd_conteudo int identity(1,1),
   nm_conteudo varchar(30))
  declare
  @Dez table
   (cd_conteudo int identity(1,1),
    nm_conteudo varchar(30))

  declare
  @Dezenas table
   (cd_conteudo int identity(1,1),
    nm_conteudo varchar(30))
  declare
   @Centenas table
  (cd_conteudo int identity(1,1),
   nm_conteudo varchar(30))


  --Populando tabela temporária de unidades
  insert into @Unidades values('Um')
  insert into @Unidades values('Dois')
  insert into @Unidades values('Tres')
  insert into @Unidades values('Quatro')
  insert into @Unidades values('Cinco')
  insert into @Unidades values('Seis')
  insert into @Unidades values('Sete')
  insert into @Unidades values('Oito')
  insert into @Unidades values('Nove')

  --Criando tabela temporária Dez
  --Populando tabela temporária Dez
  insert into @Dez values('Onze')
  insert into @Dez values('Doze')
  insert into @Dez values('Treze')
  insert into @Dez values('Quatorze')
  insert into @Dez values('Quinze')
  insert into @Dez values('Dezesseis')
  insert into @Dez values('Dezessete')
  insert into @Dez values('Dezoito')
  insert into @Dez values('Dezenove')

  --Populando tabela temporária de Dezenas
  insert into @Dezenas values('Dez')
  insert into @Dezenas values('Vinte')
  insert into @Dezenas values('Trinta')
  insert into @Dezenas values('Quarenta')
  insert into @Dezenas values('Cinquenta')
  insert into @Dezenas values('Sessenta')
  insert into @Dezenas values('Setenta')
  insert into @Dezenas values('Oitenta')
  insert into @Dezenas values('Noventa')

  --Populando tabela temporária de Centenas
  insert into @Centenas values('Cento')  
  insert into @Centenas values('Duzentos')  
  insert into @Centenas values('Trezentos')  
  insert into @Centenas values('Quatrocentos')  
  insert into @Centenas values('Quinhentos')  
  insert into @Centenas values('Seiscentos')  
  insert into @Centenas values('Setecentos')  
  insert into @Centenas values('Oitocentos')  
  insert into @Centenas values('Novecentos')  

  set @Unidade = ''
  set @Dezena  = ''
  set @Centena = ''

  if substring(@nm_trio,2,1) = '1' and substring(@nm_trio,3,1) <> '0'
  begin
    select
      @Unidade = nm_conteudo
    from
      @Dez
    where
      cd_conteudo = substring(@nm_trio,3,1)
    set @Dezena = ''
  end
  else
  begin
    if substring(@nm_trio,2,1) <> '0'
      select
        @Dezena = nm_conteudo
      from
        @Dezenas
      where
        cd_conteudo = substring(@nm_trio,2,1)      
    if substring(@nm_trio,3,1) <> '0'
      select
        @Unidade = nm_conteudo
      from
        @Unidades
      where
        cd_conteudo = substring(@nm_trio,3,1)
  end 

  if substring(@nm_trio,1,1) = '1' and @Unidade = '' and @Dezena = ''
    set @Centena = 'Cem'
  else
    if substring(@nm_trio,1,1) <> '0'
      select
        @Centena = nm_conteudo
      from
        @Centenas
      where
        cd_conteudo = substring(@nm_trio,1,1)      
    else
      set @Centena = ''

  declare @nm_resultado varchar(500)

  set @nm_resultado =
         ( @Centena + 
         case when @Centena <> '' and (@Dezena <> '' or @Unidade <> '') then ' e ' else '' end +
         @Dezena + 
         case when @Dezena <> '' and @Unidade <> '' then ' e ' else '' end +        
         @Unidade )

  Return @nm_resultado 
end




