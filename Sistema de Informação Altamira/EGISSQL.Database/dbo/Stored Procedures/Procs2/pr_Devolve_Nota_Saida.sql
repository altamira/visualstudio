
------------------------------------------------------------------------------------------------------
CREATE  PROCEDURE pr_Devolve_Nota_Saida
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel Carrasco Neto.
--Banco de Dados: EGISSQL
--Objetivo: Devolver / Ativar os Itens ou a Nota.
--Data: 03/07/2002
--Atualizado: Fabio Cesar - 28.01.2003 - Devolução Parcial dos itens
--                          11/04/2003 - Inclusão de flags de status - ELIAS
--                          30/05/2003 - Modificação do parâmetro @qt_devolucao_item_nota de int p/ float para 
--                                       possibilitar devolução de quantidade com casas decimais
--                          25.05.2004 - Define se a Nota foi devolvida e posteriormente ativada - Fabio
--                          24/05/2005 - Aumentado tamanho do Parâmetro de Motivo de Deolução para o maior possível - ELIAS
------------------------------------------------------------------------------------------------------
@ic_parametro              int,
@ic_ativar                 char(1),
@cd_nota_saida             int,
@cd_item_nota_saida        int,
@ic_dev_nota_saida         char(1),
@dt_cancel_nota_saida      Datetime,
@nm_mot_cancel_nota_saida  varchar(8000),  -- Aumentado p/ o Maior Tamanho Possível de Um String - ELIAS
@dt_nota_dev_nota_saida    Datetime,
@cd_nota_dev_nota_saida    varchar(15),
@cd_status_nota            int,
@qt_devolucao_item_nota    float,
@cd_usuario                int = 0,
@cd_motivo_dev_nota        int = 0

AS

Declare @cd_devolucao_nota_saida int,
        @qt_devolucao float


--------------------------------------------------------
if @ic_parametro = 1 -- Devolução/Ativação Total da Nota
--------------------------------------------------------
begin

  -- DEVOLUÇÃO
  if (@ic_ativar = 'N') 
  begin

      --Atualiza os dados da Nota de Saída
      UPDATE 
        Nota_Saida
      SET 
        nm_mot_cancel_nota_saida = @nm_mot_cancel_nota_saida,
        dt_cancel_nota_saida     = @dt_cancel_nota_saida,
      	ic_dev_nota_saida        = @ic_dev_nota_saida,
        dt_nota_dev_nota_saida   = @dt_nota_dev_nota_saida,
        cd_nota_dev_nota_saida   = @cd_nota_dev_nota_saida,
        cd_status_nota           = 4,
        ic_status_nota_saida     = 'D',          -- Devolução Total conforme Status_Nota
        cd_usuario               = @cd_usuario,  --Código do Usuário
        dt_usuario               = GetDate(),
        cd_motivo_dev_nota       = @cd_motivo_dev_nota
      where  
        cd_nota_saida = @cd_nota_saida


      --Atualiza os dados dos itens da Nota de Saída

      UPDATE 
        Nota_Saida_item
      set 
        dt_restricao_item_nota    = @dt_nota_dev_nota_saida,
      	qt_devolucao_item_nota    = qt_item_nota_saida,
        -- Os dois campos abaixo, ic_dev_nota_saida, cd_nota_dev_nota_saida serão preenchidos
        -- somente quando a devolução acontecer através de uma nota do próprio cliente - ELIAS 11/04/2003
      	ic_dev_nota_saida         = @ic_dev_nota_saida,
      	cd_nota_dev_nota_saida    = @cd_nota_dev_nota_saida,
        -- Acrescentado as informações de Devolução no Item - ELIAS 11/04/2003
        ic_status_item_nota_saida = 'D', -- Devolução Total conforme tabela Status_Nota
        cd_status_nota            = 4, 
        nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida,
        cd_usuario                = @cd_usuario,  --Código do Usuário
        dt_usuario                = GetDate(),
        cd_motivo_dev_nota        = @cd_motivo_dev_nota        
      where
	      cd_nota_saida = @cd_nota_saida
 

      --Pega a qtd a ser devolvida
      Select @qt_devolucao_item_nota = SUM(qt_devolucao_item_nota) From Nota_Saida_Item 
      Where cd_nota_saida = @cd_nota_saida 

      --Pega o útimo codigo da tabela.
      Select @cd_devolucao_nota_saida = IsNull(Max(cd_devolucao_nota_saida),0)
      From Nota_saida_devolucao
      Where cd_nota_saida = @cd_nota_saida and cd_item_nota_saida = @cd_item_nota_saida

      --Atualizar os dados da tabela de Devolução
      Insert Into Nota_Saida_Devolucao
      (cd_nota_saida, cd_item_nota_saida, cd_devolucao_nota_saida,
       ic_dev_nota_saida, dt_nota_dev_nota_saida, cd_nota_dev_nota_saida,
       cd_status_nota, qt_devolucao_item_nota, nm_mot_devol_nota_saida,
       cd_usuario, dt_usuario) Values
      (@cd_nota_saida, @cd_item_nota_saida, (@cd_devolucao_nota_saida + 1),
       @ic_dev_nota_saida,  @dt_nota_dev_nota_saida, @cd_nota_dev_nota_saida,
       4, @qt_devolucao, @nm_mot_cancel_nota_saida, @cd_usuario, GetDate())

  end
  else 
  begin

      -- ATIVAÇÃO
      -- Atualização dos dados do Cabeçalho da Nota
      UPDATE 
        Nota_Saida 
      SET 
        --ds_ativacao_pedido = @ds_cancelamento_pedido,
        --dt_ativacao_pedido = @dt_cancelamento_pedido,
        nm_mot_cancel_nota_saida  = '',
        dt_cancel_nota_saida      = null,
        ic_dev_nota_saida         = null,
        dt_nota_dev_nota_saida    = null,
        cd_nota_dev_nota_saida    = null,
        cd_status_nota            = 5,
        ic_status_nota_saida      = 'E', -- Nota Emitida Conforme Status_Nota - ELIAS 11/04/2003
        cd_usuario                = @cd_usuario,  --Código do Usuário
        dt_usuario                = GetDate(),
        cd_motivo_dev_nota        = null
      where  
        cd_nota_saida = @cd_nota_saida

      --Atualiza os dados dos itens da Nota de Saída
      UPDATE 
        Nota_Saida_item
      set 
        dt_restricao_item_nota    = null,
        qt_devolucao_item_nota    = 0,
      	ic_dev_nota_saida         = null,
      	cd_nota_dev_nota_saida    = null,
        -- Acrescentado as informações de Ativação do Item - ELIAS 11/04/2003
        ic_status_item_nota_saida = 'E', -- Nota Emitida conforme tabela Status_Nota
        cd_status_nota            = 5, 
        cd_requisicao_faturamento = null,
        cd_item_requisicao        = null, 
        dt_ativacao_nota_saida    = @dt_cancel_nota_saida,
        nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida,
        cd_usuario                = @cd_usuario,  --Código do Usuário
        dt_usuario                = GetDate(),
        cd_motivo_dev_nota        = null
      where
        cd_nota_saida = @cd_nota_saida


      --Atualiza a tabela de Devolução da NF
      Delete Nota_saida_devolucao
      Where cd_nota_saida = @cd_nota_saida

  end         
end
-----------------------------------------------------
else if @ic_parametro = 2 -- Devolução Parcial
------------------------------------------------------
begin

  -- DEVOLUÇÃO PARCIAL
  if (@ic_ativar = 'N') 
  begin

      -- Atualização dos Itens
      UPDATE 
        Nota_Saida_Item 
      SET 
        dt_restricao_item_nota    = @dt_nota_dev_nota_saida,
      	qt_devolucao_item_nota    = IsNull(qt_devolucao_item_nota,0) + IsNull(@qt_devolucao_item_nota,0),
       	ic_dev_nota_saida         = @ic_dev_nota_saida,
      	cd_nota_dev_nota_saida    = @cd_nota_dev_nota_saida,
      	nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida,
        -- Acrescentado as informações de Devolução no Item
        ic_status_item_nota_saida = 'P', -- Devolução Parcial conforme tabela Status_Nota
        cd_status_nota            = 3,
        cd_usuario                = @cd_usuario,  --Código do Usuário
        dt_usuario                = GetDate(),
        cd_motivo_dev_nota        = @cd_motivo_dev_nota
      where  
      	cd_nota_saida      = @cd_nota_saida and
        cd_item_nota_saida = @cd_item_nota_saida

      --Pega o útimo codigo da tabela.
      Select @cd_devolucao_nota_saida = IsNull(Max(cd_devolucao_nota_saida),0)
      From Nota_saida_devolucao with (nolock) 
      Where cd_nota_saida = @cd_nota_saida and cd_item_nota_saida = @cd_item_nota_saida

      --Atualizar os dados da tabela de Devolução
      Insert Into Nota_Saida_Devolucao
      (cd_nota_saida, cd_item_nota_saida, cd_devolucao_nota_saida,
       ic_dev_nota_saida, dt_nota_dev_nota_saida, cd_nota_dev_nota_saida,
       cd_status_nota, qt_devolucao_item_nota, nm_mot_devol_nota_saida,
       cd_usuario, dt_usuario) Values
      (@cd_nota_saida, @cd_item_nota_saida, (@cd_devolucao_nota_saida + 1),
       @ic_dev_nota_saida,  @dt_nota_dev_nota_saida, @cd_nota_dev_nota_saida,
       3, @qt_devolucao_item_nota, @nm_mot_cancel_nota_saida, @cd_usuario, GetDate())


  end
  else

  -- ATIVAÇÃO PARCIAL
  begin

    if exists(select 
                  'x' 
                from 
                  Nota_Saida_Item with (nolock)   
                where 
                  cd_nota_saida          = @cd_nota_saida and 
                  cd_item_nota_saida     = @cd_item_nota_saida and 
                  qt_devolucao_item_nota = @qt_devolucao_item_nota)
    begin

          UPDATE 
            Nota_Saida_Item 
          SET 
            dt_restricao_item_nota    = null,
      	    qt_devolucao_item_nota    = 0,
      	    ic_dev_nota_saida         = null,
	          cd_nota_dev_nota_saida    = null,
            -- Acrescentado as informações de Ativação do Item - ELIAS 11/04/2003
            ic_status_item_nota_saida = 'E', -- Nota Emitida conforme tabela Status_Nota
            cd_status_nota            = 5, 
            cd_requisicao_faturamento = null,
            cd_item_requisicao        = null, 
            dt_ativacao_nota_saida    = @dt_cancel_nota_saida,
            nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida,
            cd_usuario                = @cd_usuario,  --Código do Usuário
            dt_usuario                = GetDate(),
            cd_motivo_dev_nota        = null
          where  
            cd_nota_saida      = @cd_nota_saida and
            cd_item_nota_saida = @cd_item_nota_saida	


		      --Atualiza a tabela de Devolução da NF
		      Delete Nota_saida_devolucao
		      Where cd_nota_saida = @cd_nota_saida and cd_item_nota_saida = @cd_item_nota_saida

  	 end
     else
   	 begin

           UPDATE 
             Nota_Saida_Item 
           SET 
             qt_devolucao_item_nota    = IsNull(qt_devolucao_item_nota,0) - 
                                         @qt_devolucao_item_nota,
             nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida,
             dt_restricao_item_nota    = @dt_nota_dev_nota_saida,
             cd_usuario                = @cd_usuario,  --Código do Usuário
             dt_usuario                = GetDate(),
             cd_motivo_dev_nota        = @cd_motivo_dev_nota     
           where  
             cd_nota_saida      = @cd_nota_saida and
             cd_item_nota_saida = @cd_item_nota_saida	

			      --Pega o útimo codigo da tabela.
			      Select @cd_devolucao_nota_saida = IsNull(Max(cd_devolucao_nota_saida),0)
			      From Nota_saida_devolucao with (nolock) 
			      Where cd_nota_saida = @cd_nota_saida and cd_item_nota_saida = @cd_item_nota_saida

			      --Atualizar os dados da tabela de Devolução
			      Insert Into Nota_Saida_Devolucao
			      (cd_nota_saida, cd_item_nota_saida, cd_devolucao_nota_saida,
			       ic_dev_nota_saida, dt_nota_dev_nota_saida, cd_nota_dev_nota_saida,
			       cd_status_nota, qt_devolucao_item_nota, nm_mot_devol_nota_saida,
			       cd_usuario, dt_usuario) Values
			      (@cd_nota_saida, @cd_item_nota_saida, (@cd_devolucao_nota_saida + 1),
			       @ic_dev_nota_saida,  @dt_nota_dev_nota_saida, @cd_nota_dev_nota_saida,
			       3, @qt_devolucao_item_nota, 
             @nm_mot_cancel_nota_saida, @cd_usuario, GetDate())

  	  end
  end           
end 
---------------------------------------------
else if @ic_parametro = 3 -- Atualiza somente o status da nota
----------------------------------------------
  begin

    -- DEVOLUÇÃO 
    if (@ic_ativar = 'N') 
      begin

        --Atualiza os dados da Nota de Saída
        UPDATE 
          Nota_Saida
        SET 
          nm_mot_cancel_nota_saida = @nm_mot_cancel_nota_saida,
          dt_cancel_nota_saida     = @dt_cancel_nota_saida,
      	  ic_dev_nota_saida        = @ic_dev_nota_saida,
          dt_nota_dev_nota_saida   = @dt_nota_dev_nota_saida,
          cd_nota_dev_nota_saida   = @cd_nota_dev_nota_saida,
          cd_status_nota           = @cd_status_nota,
          cd_usuario               = @cd_usuario,  --Código do Usuário
          dt_usuario               = GetDate(),
          cd_motivo_dev_nota       = @cd_motivo_dev_nota
        where  
          cd_nota_saida = @cd_nota_saida

      end
    else 
      begin
        
        --Verifica se existe um item devolvido
        if not exists(select 
                        'x' 
                      from 
                        Nota_Saida_Item 
                      where 
                        cd_nota_saida = @cd_nota_saida and 
                        IsNull(qt_devolucao_item_nota,0) > 0)
        begin
          UPDATE 
            Nota_Saida 
          SET 
            --ds_ativacao_pedido = @ds_cancelamento_pedido,
            --dt_ativacao_pedido = @dt_cancelamento_pedido,
            nm_mot_cancel_nota_saida = '',
            dt_cancel_nota_saida     = null,
            ic_dev_nota_saida        = null,
            dt_nota_dev_nota_saida   = null,
            cd_nota_dev_nota_saida   = null,
            cd_status_nota           = @cd_status_nota,
            cd_usuario               = @cd_usuario,  --Código do Usuário
            dt_usuario               = GetDate(),
            cd_motivo_dev_nota       = null
          where
            cd_nota_saida = @cd_nota_saida
        end
    end
end

