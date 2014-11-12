create procedure pr_plano_conta_padrao  
@ic_parametro             int,           
@cd_plano_padrao          int,           
@cd_mascara_conta_padrao  varchar(20),  
@cd_conta_padrao          int output,  ---Retorna o Código da Conta Padrao   
@cd_conta_reduzido_padrao int output,  ---Retorna o código reduzido  
@cd_usuario               int,  
@cd_empresa               int             
                                         
as  

begin  
  DECLARE @passo int                  ---Incremento   
  SET     @passo = 1  

---Inicia a transaçao  

BEGIN TRANSACTION  
------------------------------------------------------------------------------  
if @ic_parametro = 0                ---Atualiza Reduzido e Retorna Novo Código  
------------------------------------------------------------------------------  
begin  
  ---Verifica se já existe o código (máscara) antes de prosseguir  
  if exists(SELECT * FROM Plano_conta_padrao   
            WHERE cd_mascara_conta_padrao = @cd_mascara_conta_padrao and  
                  cd_plano_padrao = @cd_plano_padrao)  
    goto TRATAERRO1   

  ---Gera o código do plano_conta_padrao  
  SELECT @cd_conta_padrao = ISNULL(MAX(cd_conta_padrao),0)+ 1   
    FROM   
      Plano_conta_padrao  
    WHERE   
      cd_plano_padrao = @cd_plano_padrao   


  ---Guarda o valor do incremento  
  SELECT @passo = ISNULL(qt_passo_conta_reduzido,1)  
    FROM  
      Reduzido_conta_padrao  
    WHERE  
      cd_plano_padrao = @cd_plano_padrao  

  ---Gera o código reduzido padrao  
  SELECT @cd_conta_reduzido_padrao = (ISNULL(MAX(cd_conta_reduzido_padrao),0)+@passo)  
    FROM  
      Reduzido_conta_padrao  
    WHERE  
      cd_plano_padrao = @cd_plano_padrao  

  ---Atualizar novo código em Reduzido_conta_padrao  
  if exists( SELECT * FROM Reduzido_conta_padrao   
             WHERE cd_plano_padrao = @cd_plano_padrao)  
    begin  
      UPDATE Reduzido_conta_padrao  
        SET cd_conta_reduzido_padrao = @cd_conta_reduzido_padrao,  
            dt_conta_reduzido_padrao = getDate(),  
            cd_usuario = @cd_usuario,  
            dt_usuario = getDate()  
        WHERE  
          cd_plano_padrao = @cd_plano_padrao  
    end  
  else  
    begin  
      INSERT INTO Reduzido_conta_padrao(cd_plano_padrao,  
         cd_conta_reduzido_padrao,  
         dt_conta_reduzido_padrao,  
         qt_passo_conta_reduzido,  
         cd_usuario,  
         dt_usuario)  
      VALUES(@cd_plano_padrao,  
         @cd_conta_reduzido_padrao,  
         getDate(),  
         1,  
         @cd_usuario,  
         getDate())   
    end  
end  
------------------------------------------------------------------------------  
if @ic_parametro = 1           ---Exporta Plano Padrao para o Plano da Empresa  
------------------------------------------------------------------------------  
begin  
  ---Verifica se é permitido gerar Plano de Conta para a Empresa  
  if exists(SELECT 'x'  
        FROM  
          Parametro_contabil  
        WHERE  
          cd_empresa = @cd_empresa and  
          isnull(ic_plano_gerado,'N') = 'S')  
    goto TRATAERRO2       

  ---Verifica se já existe um Plano de Conta para a Empresa  
  if exists(SELECT * FROM Plano_conta WHERE cd_empresa = @cd_empresa)  
    goto TRATAERRO3  
       
  ---Exporta o Plano Padrao selecionado para o Plano de Contas da Empresa  
  INSERT INTO Plano_conta(  
      cd_empresa,  
      cd_conta,  
      cd_mascara_conta,  
      nm_conta,  
      ic_tipo_conta,  
      ic_conta_analitica,  
      ic_conta_balanco,  
      ic_conta_resultado,  
      ic_conta_custo,  
      ic_conta_analise,  
      ic_lancamento_conta,  
      ic_situacao_conta,  
      vl_saldo_inicial_conta,  
      ic_saldo_inicial_conta,  
      vl_debito_conta,  
      vl_credito_conta,  
      qt_lancamento_conta,  
      vl_saldo_atual_conta,  
      ic_saldo_atual_conta,  
      cd_grupo_conta,  
      cd_conta_reduzido,  
      qt_grau_conta,  
      cd_conta_sintetica,   
      cd_usuario,  
      dt_usuario)  
           SELECT @cd_empresa,  
                  cd_conta_padrao,  
                  cd_mascara_conta_padrao,  
                  nm_conta_padrao,  
                  ic_tipo_conta_padrao,  
                  ic_conta_analitica_padrao,  
                  ic_conta_balanco_padrao,  
                  ic_conta_resultado_padrao,  
                  ic_conta_custo,  
                  ic_conta_analise_padrao,  
                  ic_lancamento_conta_padrao,  
                  ic_situacao_conta_padrao,  
                  0,  
                  '0',  
                  0,  
                  0,  
                  0,  
                  0,  
                  '0',  
                  cd_grupo_conta,  
                  cd_conta_reduzido_padrao,  
                  qt_grau_conta_padrao,  
                  cd_conta_sintetica_padrao,  
                  @cd_usuario,  
                  getDate()  
           FROM  
              Plano_conta_padrao  
           WHERE  
              cd_plano_padrao = @cd_plano_padrao  
  ---Faz a gravaçao do código de nível da conta  
  -- Cria Tabela Temporária  
  select   
    cd_empresa, cd_conta, cd_mascara_conta   
  into   
    #Aux_Plano_conta   
  from   
    Plano_conta   
  where   
    cd_empresa = @cd_empresa and  
    ((qt_grau_conta = null) or  (qt_grau_conta = 0))  
  declare @qt_grau_conta int               -- Grau da Conta  
  declare @cd_conta int                    -- Código da Conta (Chave)  
  declare @cd_contador int                 -- Contador de Caracteres   
  declare @cd_mascara_conta varchar(30)    -- Máscara da Conta  
  -- Lê toda a tabela auxiliar e atualiza a tabela de Plano de Contas  
  while exists(select * from #Aux_Plano_conta)  
    begin  
      set @qt_grau_conta = 1  
      set @cd_contador = 0  
      select @cd_conta = cd_conta,  
             @cd_mascara_conta = cd_mascara_conta from #Aux_Plano_conta  
      -- Atribui o grau da conta  
      while (@cd_contador <=  len(@cd_mascara_conta))  
        begin  
          if (substring(@cd_mascara_conta, @cd_contador, 1) = '.')  
            set @qt_grau_conta = @qt_grau_conta + 1  
        
          set @cd_contador = @cd_contador + 1  
        end  
        
      -- Atualiza o Plano de Contas    
      update   
        Plano_conta  
      set  
        qt_grau_conta = @qt_grau_conta   
      where  
        cd_empresa = @cd_empresa and  
        cd_conta   = @cd_conta  
        
      -- Apaga registro usado na tabela Auxiliar  
      delete from #Aux_Plano_conta   
        where cd_conta = @cd_conta  
    end  
        
  ---Guarda Código Reduzido  
  SELECT @cd_conta_reduzido_padrao = ISNULL(MAX(cd_conta_reduzido),1)  
     FROM  
       Plano_conta  
     WHERE  
       cd_empresa = @cd_empresa  

  ---Atualiza Reduzido_conta  
  if exists( SELECT * FROM Reduzido_conta   
             WHERE cd_empresa = @cd_empresa)  
    begin  
      UPDATE Reduzido_conta  
        SET cd_conta_reduzido = @cd_conta_reduzido_padrao,  
            dt_conta_reduzido = getDate(),  
            cd_usuario = @cd_usuario,  
            dt_usuario = getDate()  
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
         @cd_conta_reduzido_padrao,  
         getDate(),  
         1,  
         @cd_usuario,  
         getDate())   
    end  
  ---Atualiza o Parametro_contabil  
  UPDATE Parametro_contabil  
    SET ic_plano_gerado = 'S'  
    WHERE cd_empresa = @cd_empresa  
    
end  
if @@ERROR = 0  
  COMMIT TRAN  
else  
  begin  
    ---RAISERROR @@ERROR  
    ROLLBACK TRAN  
  end  
return  
TRATAERRO1:  
  begin  
    RAISERROR ('O Código (máscara) da Conta já foi utilizado!',16,1)  
    return  
  end  
TRATAERRO2:  
  begin  
    RAISERROR ('Parâmetro Contábil indica Plano já Gerado. Operação Cancelada!',16,1)  
    return  
  end  
TRATAERRO3:  
  begin  
    RAISERROR ('Opção de sobrepor um plano existente ainda não implementada. Operação Cancelada!',16,1)  
    return  
  end  
end  
  
  
  
  

