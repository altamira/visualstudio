
CREATE PROCEDURE pr_mini_extenso
@nm_trio  char(3), 
@nm_saida varchar(500) OUTPUT
AS
  declare
  @Unidade	varchar(500),
  @Dezena	varchar(500),
  @Centena	varchar(500)

set nocount on

  --Criando tabela temporária das unidades
  create table
    #Unidades
  (cd_conteudo int identity(1,1),
   nm_conteudo varchar(30))
  --Populando tabela temporária de unidades
  insert into #Unidades values('Um')
  insert into #Unidades values('Dois')
  insert into #Unidades values('Tres')
  insert into #Unidades values('Quatro')
  insert into #Unidades values('Cinco')
  insert into #Unidades values('Seis')
  insert into #Unidades values('Sete')
  insert into #Unidades values('Oito')
  insert into #Unidades values('Nove')

  --Criando tabela temporária Dez
  create table
    #Dez
  (cd_conteudo int identity(1,1),
   nm_conteudo varchar(30))
  --Populando tabela temporária Dez
  insert into #Dez values('Onze')
  insert into #Dez values('Doze')
  insert into #Dez values('Treze')
  insert into #Dez values('Quatorze')
  insert into #Dez values('Quinze')
  insert into #Dez values('Dezesseis')
  insert into #Dez values('Dezessete')
  insert into #Dez values('Dezoito')
  insert into #Dez values('Dezenove')

  --Criando tabela temporária de Dezenas
  create table
    #Dezenas
  (cd_conteudo int identity(1,1),
   nm_conteudo varchar(30))
  --Populando tabela temporária de Dezenas
  insert into #Dezenas values('Dez')
  insert into #Dezenas values('Vinte')
  insert into #Dezenas values('Trinta')
  insert into #Dezenas values('Quarenta')
  insert into #Dezenas values('Cinquenta')
  insert into #Dezenas values('Sessenta')
  insert into #Dezenas values('Setenta')
  insert into #Dezenas values('Oitenta')
  insert into #Dezenas values('Noventa')

  --Criando tabela temporária de Centenas
  create table
    #Centenas
  (cd_conteudo int identity(1,1),
   nm_conteudo varchar(30))
  --Populando tabela temporária de Centenas
  insert into #Centenas values('Cento')  
  insert into #Centenas values('Duzentos')  
  insert into #Centenas values('Trezentos')  
  insert into #Centenas values('Quatrocentos')  
  insert into #Centenas values('Quinhentos')  
  insert into #Centenas values('Seiscentos')  
  insert into #Centenas values('Setecentos')  
  insert into #Centenas values('Oitocentos')  
  insert into #Centenas values('Novecentos')  

  set @Unidade = ''
  set @Dezena  = ''
  set @Centena = ''

  if substring(@nm_trio,2,1) = '1' and substring(@nm_trio,3,1) <> '0'
  begin
    select
      @Unidade = nm_conteudo
    from
      #Dez
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
        #Dezenas
      where
        cd_conteudo = substring(@nm_trio,2,1)      
    if substring(@nm_trio,3,1) <> '0'
      select
        @Unidade = nm_conteudo
      from
        #Unidades
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
        #Centenas
      where
        cd_conteudo = substring(@nm_trio,1,1)      
    else
      set @Centena = ''

  set @nm_saida = @Centena + 
         case when @Centena <> '' and (@Dezena <> '' or @Unidade <> '') then ' e ' else '' end +
         @Dezena + 
         case when @Dezena <> '' and @Unidade <> '' then ' e ' else '' end +        
         @Unidade
  
  --print @Unidade
  --print @Dezena
  --print @Centena

  drop table #Unidades
  drop table #Dez
  drop table #Dezenas
  drop table #Centenas

set nocount off

