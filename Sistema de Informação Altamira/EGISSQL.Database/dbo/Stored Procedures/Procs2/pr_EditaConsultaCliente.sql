
CREATE procedure pr_EditaConsultaCliente
-------------------------------------------------------------------------------
--pr_EditaConsultaCliente
-------------------------------------------------------------------------------
--GBS - Global Business Solution	                                   2004
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Fabio Cesar Magalhães
--Banco de Dados          : EgisSql
--Objetivo                : Editar as informações do cliente
--Data                    : 30.10.2002
--Atualização             : 13/10/2003 - Gravar cd_vendedor e cd_vendedor_interno na tabela Cliente
--                          Daniel C. Neto
--                        : 26.02.2004 - Inclusão de novos campos para atualização "ds_cliente_endereco" - por Igor Gama
--                        : 26/05/2004 - Inclusão de novos campos @ic_contrib_icms_cliente, @ic_isento_insc_cliente
--                          DANIEL DUELA
--                        : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- 16.03.2005 - Inclusao do campo nm_divisao_area, correção do cabeçalho - Clelson Camargo
-- 21.03.2005 - Inclusao do campo cd_destinacao_produto - Clelson Camargo
-- 22/03/2005 - Inclusão de campo ic_permite_agrupar_pedido - Daniel C. Neto.
-- 17.05.2005 - Inclusão de campo cd_transportadora/cd_condicao_pagamento - Carlos Fernandes
-- 01/06/2005 - Inclusão do campo Fax - Rafael Santiago
-- 07/07/2005 - Deleta os Vendedores Existentes caso seja diferente do Atual - Márcio
-- 12.07.2007 - Verificação de inclusão automática de vendedores - Carlos Fernandes
-- 06.11.2007 - Complemento do Endereço do Cliente - Carlos Fernandes
-- 25.02.2009 - Ajustes Diversos - Carlos Fernandes
-- 07.04.2009 - Verificação porque da Exclusão dos vendedores do Cadastro - Carlos Fernandes
---------------------------------------------------------------------------------------------------------------------------

@cd_cliente                int          = 0,
@nm_fantasia_cliente       char(15)     = '',
@nm_razao_social_cliente   varchar(40)  = '',
@nm_dominio_cliente        varchar(100) = '',
@cd_status_cliente         int          = 0,
@nm_email_cliente          varchar(100) = '',
@nm_endereco_cliente       varchar(60),
@nm_bairro                 varchar(25),
@cd_pais                   int,
@cd_estado                 int,
@cd_cidade                 int,
@cd_ddd                    char(4),
@cd_telefone               varchar(15),
@cd_fax                    varchar(15),
@cd_identifica_cep         int,
@cd_cep                    char(9),
@cd_inscEstadual           varchar(18),
@cd_ramo_atividade         int,
@cd_fonte_informacao       int,
@cd_tipo_pessoa            int,
@cd_cnpj_cliente           varchar(18),
@dt_cadastro_cliente       datetime,
@ds_perfil_cliente         Text        = '',
@cd_vendedor_Int           int         = 0 ,
@nm_vendedor_Int           varchar(40) = '',
@cd_vendedor_Ext           int         = 0,
@nm_vendedor_Ext           varchar(40) = '',
@ic_liberado_pesq_credito  char(1)     = 'S',
@cd_usuario                int         = 0,
@dt_usuario                datetime    = '',
@cd_numero_endereco        char(10)    = '',
@nm_ponto_ref_cliente      varchar(100)= '',
@cd_tipo_mercado           int         = 1,    --Define que o tipo de mercado é nacional
@ds_cliente_endereco       text        = null, --Campo endereço para cliente do exterior
@ic_contrib_icms_cliente   char(1)     = 'S' , 
@ic_isento_insc_cliente    char(1)     = 'N',
@cd_moeda                  int         = 0,
@nm_divisao_area           varchar(40) = '',
@cd_destinacao_produto     int         = 0,
@ic_permite_agrupar_pedido char(1)     = '',
@cd_condicao_pagamento     int         = 0,
@cd_transportadora         int         = 0,
@nm_complemento_endereco   varchar(30) = '',
@cd_ddd_celular_cliente    varchar(4)  = '',
@cd_celular_cliente        varchar(15) = 0,
@dt_aniversario_cliente    datetime    = Null

AS

BEGIN

  declare @erro_msg         varchar(255),
  	  @cd_vendedor      int,
   	  @cd_item          int,
          @cd_tipo_vendedor int

  set @cd_vendedor = 0

  --select @cd_vendedor_int,@cd_vendedor_Ext

  if @cd_vendedor_Int is null
     set @cd_vendedor_int = 0

  if @cd_vendedor_Ext is null
     set @cd_vendedor_Ext = 0

  if @nm_vendedor_Int is null
     set @nm_vendedor_Int = ''

  if @nm_vendedor_ext is null
     set @nm_vendedor_ext = ''

  --select @cd_vendedor_int,@cd_vendedor_Ext


  if (@cd_tipo_mercado is null) or (@cd_tipo_mercado = 0)
  begin
    set @cd_tipo_mercado = 1
  end

  --Tratamento especial para pessoa física
  --PESSOA FÍSICA

  if ( @cd_tipo_pessoa  = 2)
  begin
    if ( @ic_contrib_icms_cliente is null )
      set @ic_contrib_icms_cliente = 'N'
  
    if ( @ic_isento_insc_cliente is null )
      set @ic_isento_insc_cliente = 'S'
  end
  else
  begin
    if ( @ic_contrib_icms_cliente is null )
      set @ic_contrib_icms_cliente = 'S'
    if ( @ic_isento_insc_cliente is null )
      set @ic_isento_insc_cliente = 'N'
  end
  
  --Verifica se o cliente já está cadastrado
  BEGIN TRAN

  if exists(Select top 1 'x' from Cliente where cd_cliente = @cd_cliente) 
    -- Caso exista o registro
    begin
	Update Cliente
        set 
          nm_fantasia_cliente      = @nm_fantasia_cliente,
          nm_razao_social_cliente  = @nm_razao_social_cliente,
          nm_dominio_cliente       = @nm_dominio_cliente,
          nm_email_cliente         = @nm_email_cliente,
          dt_cadastro_cliente      = @dt_cadastro_cliente,
          cd_tipo_pessoa           = @cd_tipo_pessoa,
          cd_fonte_informacao      = @cd_fonte_informacao,
          cd_ramo_atividade        = @cd_ramo_atividade,
          cd_status_cliente        = @cd_status_cliente,
          cd_identifica_cep        = @cd_identifica_cep,
          cd_cnpj_cliente          = @cd_cnpj_cliente,
          cd_inscEstadual          = @cd_inscEstadual,
          cd_cep                   = @cd_cep,
          nm_endereco_cliente      = @nm_endereco_cliente,
          nm_bairro                = @nm_bairro,
          cd_cidade                = @cd_cidade,
          cd_estado                = @cd_estado,
          cd_pais                  = @cd_pais,
          cd_ddd                   = @cd_ddd,
          cd_telefone              = @cd_telefone,
          cd_fax                   = @cd_fax,
          ic_liberado_pesq_credito  = @ic_liberado_pesq_credito,
          cd_usuario                = @cd_usuario,
      	  dt_usuario                = @dt_usuario,
          cd_numero_endereco        = @cd_numero_endereco,
      	  nm_ponto_ref_cliente      = @nm_ponto_ref_cliente,
      	  cd_vendedor_interno       = @cd_vendedor_Int,
      	  cd_vendedor               = @cd_vendedor_Ext,
          cd_tipo_mercado           = @cd_tipo_mercado,
          ds_cliente_endereco       = @ds_cliente_endereco,
          ic_contrib_icms_cliente   = @ic_contrib_icms_cliente, 
          ic_isento_insc_cliente    = @ic_isento_insc_cliente,
          cd_moeda                  = @cd_moeda,
      	  nm_divisao_area           = @nm_divisao_area,
      	  cd_destinacao_produto     = @cd_destinacao_produto,
          ic_permite_agrupar_pedido = @ic_permite_agrupar_pedido,
          cd_condicao_pagamento     = @cd_condicao_pagamento,
          cd_transportadora         = @cd_transportadora,
          cd_ddd_celular_cliente    = @cd_ddd_celular_cliente,
          cd_celular_cliente        = @cd_celular_cliente,
          dt_aniversario_cliente    = @dt_aniversario_cliente,
          nm_complemento_endereco   = @nm_complemento_endereco
     	where 
          cd_cliente = @cd_cliente        
        print 'atualização'
    end 
  else
    -- Caso não exista o registro
    begin
	Insert into Cliente
        (
          cd_cliente,        
          nm_fantasia_cliente,
          nm_razao_social_cliente,
          nm_dominio_cliente,
          nm_email_cliente,
          dt_cadastro_cliente,
          cd_tipo_pessoa,
          cd_fonte_informacao,
          cd_ramo_atividade,
          cd_status_cliente,
          cd_usuario,
          dt_usuario,
          cd_identifica_cep,
          cd_cnpj_cliente,
          cd_inscEstadual,
          cd_cep,
          nm_endereco_cliente,
          cd_numero_endereco,
          nm_bairro,
          cd_cidade,
          cd_estado,
          cd_pais,
          cd_ddd,
          cd_fax,
          cd_telefone,
          ic_liberado_pesq_credito,
      	  nm_ponto_ref_cliente,
          cd_vendedor_interno,
      	  cd_vendedor,
          cd_tipo_mercado,
          ds_cliente_endereco,
          ic_contrib_icms_cliente, 
          ic_isento_insc_cliente,
          cd_moeda,
      	  nm_divisao_area,
      	  cd_destinacao_produto,
          ic_permite_agrupar_pedido,
          cd_condicao_pagamento,
          cd_transportadora,
          cd_ddd_celular_cliente,
          cd_celular_cliente,
          dt_aniversario_cliente,
          nm_complemento_endereco
	  ) values
	  (
          @cd_cliente,        
          @nm_fantasia_cliente,
          @nm_razao_social_cliente,
          @nm_dominio_cliente,
          @nm_email_cliente,
          @dt_cadastro_cliente,
          @cd_tipo_pessoa,
          @cd_fonte_informacao,
          @cd_ramo_atividade,
          @cd_status_cliente,
          @cd_usuario,
          @dt_usuario,
          @cd_identifica_cep,
          @cd_cnpj_cliente,
          @cd_inscEstadual,
          @cd_cep,
          @nm_endereco_cliente,
          @cd_numero_endereco,
          @nm_bairro,
          @cd_cidade,
          @cd_estado,
          @cd_pais,
          @cd_ddd,
          @cd_fax,
          @cd_telefone,
          @ic_liberado_pesq_credito,
          @nm_ponto_ref_cliente,
          @cd_vendedor_Int,
          @cd_vendedor_Ext,
          @cd_tipo_mercado,
          @ds_cliente_endereco,
          @ic_contrib_icms_cliente, 
          @ic_isento_insc_cliente,
          @cd_moeda,
          @nm_divisao_area,
          @cd_destinacao_produto,
          @ic_permite_agrupar_pedido,
          @cd_condicao_pagamento,
          @cd_transportadora,
          @cd_ddd_celular_cliente,
          @cd_celular_cliente,
          @dt_aniversario_cliente,
          @nm_complemento_endereco
	  )

          print 'inclusão'

    end
    --Verifica se não ocorreu nenhum erro e salva os dados vinculados ao principal
    if @@error != 0 
      begin
	Set @erro_msg = 'Por motivo de falha interna não foi possível editar o cliente'       
    	--RAISERROR @erro_msg
	ROLLBACK TRAN
      end
   else 
        COMMIT TRAN

    --Edita a tabela de Cliente_Vendedor
    --Verifica se foi informado o vendedor interno
  
  if (@nm_vendedor_Int != '') and not @nm_vendedor_int is null
  begin   
     if (@cd_vendedor_Int = 0) 
     begin
       Select @cd_vendedor = (max( isnull(cd_vendedor,0) ) + 1) from Vendedor

       --Insere o novo vendedor
       if @cd_vendedor>0
       begin  
         Insert into Vendedor
                      (cd_vendedor, 
           		     nm_vendedor, 
            		     nm_fantasia_vendedor, 
                       cd_tipo_vendedor,
            		     cd_usuario,
	  	                 dt_usuario)
		values
                    (  @cd_vendedor, 
		       @nm_vendedor_Int, 
		       Left(@nm_vendedor_Int,15), 
		       1,
		       @cd_usuario,
	  	       @dt_usuario)

                print 'novo vendedor'
        end
     end 
   end

   else 

     set @cd_vendedor = isnull(@cd_vendedor_Int,0)


--   select @cd_vendedor,@cd_vendedor_int

      --Caso já exista um vendedor interno exclui o mesmo e troca por esse

      if exists(Select top 1 'x' from Cliente_Vendedor where cd_cliente = @cd_cliente and 
                                                             cd_vendedor <> @cd_vendedor_int and cd_tipo_vendedor = 1) 
      begin
        delete from cliente_vendedor 
        where cd_cliente = @cd_cliente and 
        cd_vendedor <> @cd_vendedor_int and cd_tipo_vendedor = 1
      end

      --Vincula o vendedor ao cliente caso esse não tenha sido vinculado

      if not exists(Select top 1 'x' from Cliente_Vendedor 
                    where cd_cliente = @cd_cliente and cd_vendedor <> @cd_vendedor and cd_tipo_vendedor = 1) 
       begin

         delete   from Cliente_Vendedor 
         where cd_vendedor      = @cd_vendedor and 
               cd_Cliente       = @cd_cliente and
               cd_tipo_vendedor = 1

-- 		  --Define o código do item 
 		  Select @cd_item = (count(cd_cliente) + 1) from Cliente_Vendedor where cd_cliente = @cd_cliente

                  if @cd_vendedor>0 and @cd_item>0
                  begin 
                    Insert into Cliente_Vendedor
		    (cd_cliente,
		     cd_vendedor,
		     cd_cliente_vendedor,
                     cd_tipo_vendedor,
		     cd_usuario,
	  	     dt_usuario)
		    values
		     (@cd_cliente,
		      @cd_vendedor,
		      @cd_item,
                      1,
		      @cd_usuario,
	  	      @dt_usuario)
                  end

 	    end 		

--   end

--   select @cd_vendedor,@cd_vendedor_int


    --Edita a tabela de Cliente_Vendedor
    --Verifica se foi informado o vendedor Externo

   --Tipo do Vendedor
   select @cd_tipo_vendedor = isnull(cd_tipo_vendedor,2) 
   from vendedor with (nolock) 
   where 
     cd_vendedor = @cd_vendedor_Ext

   --select @cd_tipo_vendedor
   --select @nm_vendedor_ext,@cd_vendedor_ext

   if (@nm_vendedor_Ext <> '') and not @nm_vendedor_ext is null
   begin   
     print '1'

	  if (@cd_vendedor_Ext = 0) 
          begin
		Select @cd_vendedor = (max( isnull(cd_vendedor,0)) + 1) from Vendedor

		--Insere o novo vendedor
                if @cd_vendedor>0 
                begin
                  Insert into Vendedor
                      (cd_vendedor, 
                       nm_vendedor, 
                       nm_fantasia_vendedor, 
                       cd_tipo_vendedor,
	               cd_usuario,
	               dt_usuario)
		  values
                      (@cd_vendedor, 
		       @nm_vendedor_Ext, 
		       Left(@nm_vendedor_Ext,15), 
		       @cd_tipo_vendedor,
		       @cd_usuario,
		       @dt_usuario)	        
                end
          end
     end
     else 
       set @cd_vendedor = isnull(@cd_vendedor_Ext,0)


     --select @cd_vendedor,@cd_vendedor_ext

     print 'Vendedor Externo'
    
      --Caso já exista um vendedor interno exclui o mesmo e troca por esse
   
     
      if exists(Select top 1 'x' from Cliente_Vendedor 
                where cd_cliente = @cd_cliente and 
                      cd_vendedor <> @cd_vendedor_ext and cd_tipo_vendedor = @cd_tipo_vendedor) 
      begin
        delete from cliente_vendedor 
        where cd_cliente = @cd_cliente and 
              cd_vendedor <> @cd_vendedor_ext and cd_tipo_vendedor = @cd_tipo_vendedor
      end
	 
      --Vincula o vendedor ao cliente caso esse não tenha sido vinculado

      if not exists(Select top 1 'x' from Cliente_Vendedor 
                    where cd_cliente = @cd_cliente and 
                          cd_vendedor <> @cd_vendedor_ext and cd_tipo_vendedor = @cd_tipo_vendedor) 
       begin
        -- Deleta o Vendedor

         print '2'

         delete   from Cliente_Vendedor 
         where cd_vendedor      = @cd_vendedor and 
               cd_Cliente       = @cd_cliente  and 
               cd_tipo_vendedor = @cd_tipo_vendedor

		  --Define o código do item
		  Select @cd_item = (count(cd_cliente) + 1) from Cliente_Vendedor where cd_cliente = @cd_cliente

                  if @cd_vendedor>0 and @cd_item>0 
                  begin
                    Insert into Cliente_Vendedor
		    (cd_cliente,
		     cd_vendedor,
		     cd_cliente_vendedor,
                     cd_tipo_vendedor,
		     cd_usuario,
		     dt_usuario)
		     values
		     (@cd_cliente,
		     @cd_vendedor,
		     @cd_item,
                     @cd_tipo_vendedor,
		     @cd_usuario,
		     @dt_usuario)
                  end

 	       end 		
         end 	
--   end

--   select @cd_vendedor,@cd_vendedor_ext,@cd_vendedor_int

        --Perfil

        --set @ds_perfil_cliente = rtrim(ltrim( cast(@ds_perfil_cliente as varchar(8000) ) ) )

--        select @ds_perfil_cliente

	if rtrim(ltrim(cast(@ds_perfil_cliente as varchar(3)))) <> '' 
        begin

          if not exists(Select top 1 'x' from Cliente_Perfil where cd_cliente = @cd_cliente) and @cd_cliente>0
          begin
            if @cd_cliente>0
            begin
		  Insert into Cliente_Perfil
			(cd_cliente,
			 ds_perfil_cliente,
		         cd_usuario,
		         dt_usuario)
		  values
			(@cd_cliente,
			 cast(@ds_perfil_cliente as varchar(8000)),
			--@ds_perfil_cliente),
		         @cd_usuario,
		         @dt_usuario)
            end
          end

	  else
            begin
              if @cd_cliente>0 --and rtrim(ltrim(cast(@ds_perfil_cliente as varchar(8000))))<>''
                begin  
		  Update Cliente_Perfil
		  set
                     ds_perfil_cliente = rtrim(ltrim(cast(@ds_perfil_cliente as varchar(8000)))),
		     cd_usuario        = @cd_usuario,
		     dt_usuario        = @dt_usuario
		  where
                     cd_cliente        = @cd_cliente
                end  
            end 
	end


--END

