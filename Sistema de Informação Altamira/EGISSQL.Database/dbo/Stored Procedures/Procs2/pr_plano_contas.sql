
create procedure pr_plano_contas 
@ic_parametro      int         = 0 ,
@cd_grupo_conta    int         = 0,
@cd_mascara_conta  varchar(20) = '',
@cd_empresa        int         = 0,
@cd_conta          int output,   ---Retorna o código da Conta	
@cd_conta_reduzido int output,   ---Retorna o Código Reduzido
@cd_usuario	   int = 0         
as
  
  declare @qt_passo    int  --Incremento 
  set     @qt_passo    = 1

if @ic_parametro = 0                --Grupo de Conta
begin
   select * from grupo_conta
end

if @ic_parametro = 1                --Plano de Contas p/ Grupo de Conta
begin
  select * 
  from 
    plano_conta
  where
    @cd_grupo_conta = cd_grupo_conta 
  order by 
    cd_grupo_conta,
    cd_mascara_conta 
end

if @ic_parametro = 2                --Plano de Contas pela Máscara da Conta
begin
  select * 
  from 
    plano_conta
  where
    @cd_mascara_conta = cd_mascara_conta 
  order by 
    cd_grupo_conta,
    cd_mascara_conta 
end

if @ic_parametro = 3                --Plano de Contas em ordem Máscara da Conta
begin                               --Decrescente para Atualizaçao dos Saldos
  select * 
  from 
    plano_conta
  order by 
    cd_mascara_conta desc
end

if @ic_parametro = 4                --Inclusao de novas contas
begin
  
  begin transaction 
  
  ---Verifica se já existe o código (máscara) antes de prosseguir

  if exists(SELECT * FROM Plano_conta 
            WHERE cd_mascara_conta = @cd_mascara_conta and
                  cd_empresa = @cd_empresa)
    begin
      RAISERROR ('O Código (máscara) da Conta já foi utilizado!',16,1)
      return
    end

  ---Gera o código do plano_conta

  SELECT @cd_conta = ISNULL(MAX(cd_conta),0)+ 1 
    FROM 
      Plano_conta
    WHERE 
      cd_empresa = @cd_empresa 

  ---Guarda o valor do incremento

  SELECT @qt_passo = ISNULL(qt_passo_conta_reduzido,1)
    FROM
      Reduzido_conta
    WHERE
      cd_empresa = @cd_empresa

  ---Gera o código reduzido padrao

  SELECT @cd_conta_reduzido = (ISNULL(MAX(cd_conta_reduzido),0)+@qt_passo)
    FROM
      Reduzido_conta
    WHERE
      cd_empresa = @cd_empresa

  --Verifica se já existe o Código Reduzido na tabela de plano de contas

  if exists( select cd_conta_reduzido from plano_conta where cd_conta_reduzido = @cd_conta_reduzido )
  begin
    SELECT @cd_conta_reduzido = (ISNULL(MAX(cd_conta_reduzido),0)+@qt_passo)
    FROM
      plano_conta
  end

  ---Atualizar novo código em Reduzido_conta_padrao

  if exists( SELECT top 1 cd_empresa FROM Reduzido_conta 
             WHERE cd_empresa = @cd_empresa)
    begin

      UPDATE Reduzido_conta
        SET cd_conta_reduzido = @cd_conta_reduzido,
            dt_conta_reduzido = getDate(),
            cd_usuario        = @cd_usuario,
            dt_usuario        = getDate()
        WHERE
          cd_empresa = @cd_empresa
    end
  else
    begin
      INSERT INTO Reduzido_conta(
         cd_empresa,
         cd_conta_reduzido,
         dt_conta_reduzido,
         qt_passo_conta_reduzido,
         cd_usuario,
         dt_usuario)
      VALUES(
         @cd_empresa,
         @cd_conta_reduzido,
         getDate(),
         1,
         @cd_usuario,
         getDate()) 
    end
  
  if @@ERROR = 0
    commit tran
  else
    begin
      ---RAISERROR @@ERROR
      rollback tran
    end 

--  return

end

----------------------------------------------------------------------------------
--Retorno do Código do Reduzido
----------------------------------------------------------------------------------

if @ic_parametro = 5                --Cancelamento da inclusão de novas contas
begin
  --select * from reduzido_conta

  print 'em desenvolvimento'

end

