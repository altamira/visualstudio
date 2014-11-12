
CREATE FUNCTION fn_grau_conta_contabil
(@cd_mascara_conta varchar(20) )
RETURNS int

as 

begin
  

  declare @qt_grau_conta          int
  declare @cd_mascara_grupo_conta varchar(50)
  declare @qt_grau                int
  declare @qt_contador            int
  declare @cd_grupo_conta         int 
  declare @x                      varchar(20)

  --Busca o Grupo da Contas
  select
    @cd_grupo_conta = cd_grupo_conta
  from
    Plano_Conta
  where
    cd_mascara_conta = @cd_mascara_conta

  --Busca o Grau do grupo da Conta
  select
    @qt_grau_conta = qt_grau_grupo_conta
  from
    grupo_conta
   where
    cd_grupo_conta = @cd_grupo_conta

    set @qt_grau              = 0
    set @qt_contador          = 1
    set @x = ''

    while @qt_contador <= len( @cd_mascara_conta)
    begin

      if substring(@cd_mascara_conta,@qt_contador,1)='.'
      begin

        if @x<>'.'
        begin
          if cast(@x as int)>0 
             begin
               set @qt_grau = @qt_grau + 1
             end
        end

        set @x = ''
 
        if @qt_grau  = @qt_grau_conta
        begin
          break
        end
      end 
      else
        begin
          set @x = @x + substring(@cd_mascara_conta,@qt_contador,1)        
        end

      set @qt_contador          = @qt_contador          + 1
    
    end

    if @x<>'.'
    begin
      if cast(@x as int)>0 
         begin
           set @qt_grau = @qt_grau + 1
          end
     end


  return(@qt_grau)

end

