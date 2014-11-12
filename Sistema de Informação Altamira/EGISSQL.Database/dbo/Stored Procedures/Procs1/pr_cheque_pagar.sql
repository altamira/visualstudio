
CREATE PROCEDURE pr_cheque_pagar

@ic_parametro           int,
@cd_documento_pagar     int,
@cd_cheque_pagar        int,
@dt_emissao_cheque      datetime,
@ic_baixado_cheque      char(1),
@dt_inicial             datetime,
@dt_final               datetime,
@cd_usuario             int,
@dt_usuario             datetime,
@cd_empresa             int,
@cd_banco               int,
@cd_agencia_banco       int,
@cd_conta_banco         int,
@ic_deposito_conta      char(1),
@nm_favorecido          varchar(50),
@dt_liquidacao_cheque   datetime = null,
@vl_saldo_alterado      float    = 0

as

 declare @cd_tipo_pagamento       int
 declare @vl_desconto_documento   float
 declare @vl_juros_documento      float
 declare @vl_abatimento_documento float

 declare @vl_liberacao_pedido_compra float

 -- carrega valor teto p/ liberação de pedido p/ gerência

 select
   @vl_liberacao_pedido_compra = isnull(vl_lib_pedido_compra,0)
 from
   EGISADMIN.DBO.Empresa with (nolock) 
 where
   cd_empresa = @cd_empresa

begin transaction

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- geração de cheque
-------------------------------------------------------------------------------
 begin

   declare @vl_saldo_documento_pagar numeric(25,2)
   declare @cd_identifica_documento  varchar(50)


   set @vl_saldo_documento_pagar    = 0.00
   set @cd_tipo_pagamento           = 0
   set @cd_identifica_documento     = ''

   set @vl_juros_documento          = 0.00
   set @vl_abatimento_documento     = 0.00
   set @vl_desconto_documento       = 0.00
   
   -- verificacao de código

   if (isnull(@cd_cheque_pagar, 0) <> 0)
     begin
       if exists(select
                   cd_cheque_pagar
                 from
                   Cheque_Pagar with (nolock)
                 where
                   cd_cheque_pagar = @cd_cheque_pagar and
		   cd_conta_banco  = @cd_conta_banco and
                   ic_baixado_cheque_pagar = 'S')
         begin
           raiserror('Cheque já Liquidado! Operação Abortada!',16,1)
           goto TrataErro
         end
     end
   else
     -- criação de novo código
     begin
       select
         @cd_cheque_pagar = max(isnull(cd_cheque_pagar,0))+1
       from
         Cheque_Pagar
     end
       
   -- fazer todas as validações necessárias ( a definir )

   -- valor do pagamento
   -- localização dos valores de juros, desconto e abatimento no documento_pagar

   select
     @vl_saldo_documento_pagar      = cast(str(isnull(vl_saldo_documento_pagar,0),25,2) as decimal(25,2)),
     @vl_juros_documento            = isnull(vl_juros_documento,0),
     @vl_abatimento_documento       = isnull(vl_abatimento_documento,0),
     @vl_desconto_documento         = isnull(vl_desconto_documento,0)

   from
     documento_pagar with (nolock) 
   where
     cd_documento_pagar = @cd_documento_pagar

   print(cast(str(@vl_saldo_documento_pagar,25,2) as varchar(25)))

   set @cd_tipo_pagamento = 2

   -- identificacao do pagamento
   set @cd_identifica_documento = cast(@cd_cheque_pagar as varchar(50))

   -- localização dos valores de juros, desconto e abatimento no documento_pagar
--    select
--      @vl_juros_documento      = isnull(vl_juros_documento,0),
--      @vl_abatimento_documento = isnull(vl_abatimento_documento,0),
--      @vl_desconto_documento   = isnull(vl_desconto_documento,0)
--    from
--      documento_pagar
--    where
--      cd_documento_pagar = @cd_documento_pagar

   -- se existir juros, abatimento ou desconto acertar o saldo de documento_pagar

   if ((@vl_juros_documento      <> 0) or
       (@vl_abatimento_documento <> 0) or
       (@vl_desconto_documento   <> 0)
      )
     begin
       update
         documento_pagar
       set
         vl_juros_documento       = 0.00,
         vl_abatimento_documento  = 0.00,
         vl_desconto_documento    = 0.00,
         vl_saldo_documento_pagar = isnull(vl_documento_pagar,0) - 
                                    isnull((select sum(isnull(vl_pagamento_documento,0) +
                                                   isnull(vl_juros_documento_pagar,0) -
                                                   isnull(vl_desconto_documento,0) -
                                                   isnull(vl_abatimento_documento,0))
					    from
					      documento_pagar_pagamento
					    where                                                                             
					      cd_documento_pagar = @cd_documento_pagar),0)
       where
         cd_documento_pagar = @cd_documento_pagar

       select
         @vl_saldo_documento_pagar = isnull(vl_documento_pagar,0) - 
         isnull((select
                                                                              
         sum(isnull(vl_pagamento_documento,0) +
                                                                                  
         isnull(vl_juros_documento_pagar,0) -
                                                                                  
         isnull(vl_desconto_documento,0) -
                                                                                  
         isnull(vl_abatimento_documento,0))
                                                                            
        from
                                                                              
          documento_pagar_pagamento
                                                                            
        where
                                                                              
           cd_documento_pagar = @cd_documento_pagar),0)
       from
         documento_pagar
       where
         cd_documento_pagar = @cd_documento_pagar

     end

   -- Verifica se Houve a Alteração do Saldo Manualmente pelo Usuário

   if @vl_saldo_alterado>0 and @vl_saldo_alterado<>@vl_saldo_documento_pagar
   begin
     set @vl_saldo_documento_pagar = @vl_saldo_alterado
   end
              
   -- criação do registro de pagamento do documento
   exec pr_documento_pagar 1,                                -- parâmetro de inserção
                           'S',
                           @cd_documento_pagar,
                           0,                                -- item do pagamento (gerado automaticamente)
                           null,                             -- data do pagamento
                           @vl_saldo_documento_pagar,        -- valor do pagamento
                           @cd_identifica_documento,
                           @vl_juros_documento,              -- valor de juros
                           @vl_desconto_documento,           -- valor de desconto
                           @vl_abatimento_documento,         -- valor de abatimento
                           '',                               -- recibo
                           @cd_tipo_pagamento,
                           'Geração Automática',
                           @ic_deposito_conta,
                           @cd_usuario,
                          @cd_conta_banco

   if @@ERROR <> 0    
     goto TrataErro

   --???
   if exists(select * from  
               Cheque_Pagar with (nolock) 
             where
               cd_cheque_pagar = @cd_cheque_pagar and
	       cd_conta_banco  = @cd_conta_banco)
     begin
       -- atualização do registro de borderô

       update
         Cheque_Pagar
       set
         dt_emissao_cheque_pagar = @dt_emissao_cheque,
         vl_cheque_pagar = (select
                             (isnull(vl_cheque_pagar, 0) +
                                 isnull(@vl_saldo_documento_pagar,0)) + 
                                 isnull(@vl_juros_documento,0)-
                                 isnull(@vl_abatimento_documento,0)-
                                 isnull(@vl_desconto_documento,0)
                            from
                              Cheque_Pagar
                            where
                              cd_cheque_pagar = @cd_cheque_pagar and
			      cd_conta_banco  = @cd_conta_banco),
         ic_baixado_cheque_pagar = 'N',
         cd_usuario              = @cd_usuario,
         dt_usuario              = getDate()
       where
         cd_cheque_pagar = @cd_cheque_pagar and
         cd_conta_banco  = @cd_conta_banco
     end
   else
     begin
       -- criação do registro de cheque
       insert into
          Cheque_Pagar
          ( cd_cheque_pagar, 
            dt_emissao_cheque_pagar, 
            vl_cheque_pagar, 
            cd_banco, 
            cd_agencia_banco,
            cd_conta_banco, 
            cd_usuario, 
            dt_usuario, 
            ic_baixado_cheque_pagar, 
            nm_favorecido )
        values (
       @cd_cheque_pagar,
          @dt_emissao_cheque,
          isnull(@vl_saldo_documento_pagar,0) + 
          isnull(@vl_juros_documento,0) -
          isnull(@vl_abatimento_documento,0) -
          isnull(@vl_desconto_documento,0),
          @cd_banco,
          @cd_agencia_banco,
          @cd_conta_banco,
          @cd_usuario,
          getDate(),
          'N',
      @nm_favorecido)

       update Documento_Pagar
       set cd_cheque_pagar = @cd_cheque_pagar
       where cd_documento_Pagar = @cd_documento_pagar

     end

   -- Atualiza o lançamento financeiro do cheque (Inclusão ou modificação)
   exec pr_lancamento_cheque_pagar_financeiro 1,
                                              @cd_cheque_pagar, 
                                              @cd_banco, 
                                              @cd_conta_banco,
                                              @cd_usuario
   
 end
-------------------------------------------------------------------------------
--else
if @ic_parametro = 2   -- listagem dos documentos do Cheque.
-------------------------------------------------------------------------------
 begin
   
   select distinct
     dt_emissao_documento_paga,
     b.dt_emissao_cheque_pagar,
     d.dt_vencimento_documento,
     c.sg_tipo_conta_pagar,
     case 
       when (isnull((select x.cd_empresa_diversa 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then 
         cast((select top 1 z.sg_empresa_diversa 
               from empresa_diversa z with (nolock) 
               where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
       when (isnull((select x.cd_contrato_pagar 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then 
         cast((select top 1 w.nm_fantasia_fornecedor 
               from contrato_pagar w with (nolock) 
               where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))
       when (isnull((select x.cd_funcionario 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then 
         cast((select top 1 k.nm_funcionario 
               from funcionario k with (nolock) 
               where k.cd_funcionario = d.cd_funcionario) as varchar(30))
       when (isnull((select x.nm_fantasia_fornecedor 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), '') <> '') then 
         cast(d.nm_fantasia_fornecedor as varchar(30)) 
     end as 'cd_favorecido',               
     case 
       when (isnull((select x.cd_empresa_diversa 
                     from documento_pagar x  with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then 
         cast((select top 1 z.nm_empresa_diversa 
               from empresa_diversa z with (nolock) 
               where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
       when (isnull((select x.cd_contrato_pagar 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then 
         cast((select top 1 w.nm_contrato_pagar 
                      from contrato_pagar w  with (nolock) 
                      where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))
       when (isnull((select x.cd_funcionario 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then 
         cast((select top 1 k.nm_funcionario 
               from funcionario k with (nolock) 
               where k.cd_funcionario = d.cd_funcionario) as varchar(50))
       when (isnull((select x.nm_fantasia_fornecedor 
                     from documento_pagar x with (nolock) 
                     where x.cd_documento_pagar = d.cd_documento_pagar),'') <> '') then 
         cast((select top 1 o.nm_razao_social 
               from fornecedor o with (nolock) 
               where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
     end as 'nm_favorecido',             
     d.cd_identificacao_document,
     p.nm_obs_documento_pagar,
     d.nm_observacao_documento,
     case
       when isnull(d.cd_fornecedor,0)      > 0 then (select cd_banco from fornecedor      where cd_fornecedor  = d.cd_fornecedor)
       when isnull(d.cd_funcionario,0)     > 0 then (select cd_banco from funcionario     where cd_funcionario = d.cd_funcionario)
       when isnull(d.cd_empresa_diversa,0) > 0 then (select cd_banco from empresa_diversa where cd_empresa_diversa = d.cd_empresa_diversa)
       --when isnull(d.cd_contrato_pagar,0 ) > 0 then 0
     end as cd_banco,
     case
       when isnull(d.cd_fornecedor,0)      > 0 then (select cd_agencia_banco from fornecedor      where cd_fornecedor  = d.cd_fornecedor)
       when isnull(d.cd_funcionario,0)     > 0 then (select cd_agencia_funcionario from funcionario     where cd_funcionario = d.cd_funcionario)
       when isnull(d.cd_empresa_diversa,0) > 0 then (select cd_agencia_banco from empresa_diversa where cd_empresa_diversa = d.cd_empresa_diversa)
       --when isnull(d.cd_contrato_pagar,0 ) > 0 then 0
     end as cd_numero_agencia_banco,
     case
       when isnull(d.cd_fornecedor,0)      > 0 then (select cd_conta_banco from fornecedor      where cd_fornecedor  = d.cd_fornecedor)
       when isnull(d.cd_funcionario,0)     > 0 then (select cd_conta_funcionario from funcionario     where cd_funcionario = d.cd_funcionario)
       when isnull(d.cd_empresa_diversa,0) > 0 then (select cd_conta_corrente from empresa_diversa where cd_empresa_diversa = d.cd_empresa_diversa)
       --when isnull(d.cd_contrato_pagar,0 ) > 0 then 0
     end as nm_conta_banco,
     p.vl_juros_documento_pagar +
     p.vl_abatimento_documento -
     p.vl_desconto_documento as 'vl_juros_abatimento', -- Este campo está Errado, porem vaificar na pr so pra noa dar erro onde se usa ele, usar os 3 campos abaixo - Anderson 
     isnull(p.vl_juros_documento_pagar,0) as vl_juros_documento_pagar,
     p.vl_abatimento_documento,
     p.vl_desconto_documento,
     p.vl_pagamento_documento as 'vl_original_documento',
     p.vl_pagamento_documento +
     p.vl_juros_documento_pagar -
     p.vl_desconto_documento -
     p.vl_abatimento_documento as 'vl_documento_pagar',
     d.cd_pedido_compra,
     p.ic_deposito_conta,
     b.nm_favorecido           as 'Favorecido',
     b.cd_ap,
     ap.dt_aprovacao_ap,
     u.nm_fantasia_usuario          as UsuarioAprovacao,
     isnull(d.vl_multa_documento,0) as vl_multa_documento     

--select * from documento_pagar
     
   into
     #TabelaDistinta
   from
     Cheque_Pagar b                         with (nolock) 
     inner join documento_pagar_pagamento p on p.cd_tipo_pagamento = (
                                               select min(cd_tipo_pagamento) 
                                               from tipo_pagamento_documento 
                                               where sg_tipo_pagamento like 'CHEQU%') and
                                               p.cd_identifica_documento = cast(b.cd_cheque_pagar as varchar(20)) and
                                               p.cd_conta_banco = b.cd_conta_banco
     left outer join documento_pagar d        on d.cd_documento_pagar = p.cd_documento_pagar
     left outer join tipo_conta_pagar c       on d.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar
     left outer join autorizacao_pagamento ap on ap.cd_ap              = b.cd_ap
     left outer join egisadmin.dbo.usuario u  on u.cd_usuario          = ap.cd_usuario_aprovacao

   where     
     --p.cd_identifica_documento = cast(@cd_bordero as varchar(50)) and
     p.cd_tipo_pagamento = (select
                              min(cd_tipo_pagamento)
                            from
                              tipo_pagamento_documento
                            where
                              sg_tipo_pagamento like 'CHEQU%') and
    p.cd_identifica_documento = cast(@cd_cheque_pagar as varchar(20)) and
    p.cd_conta_banco          = @cd_conta_banco


   select * from #TabelaDistinta
   order by
     sg_tipo_conta_pagar,
     dt_vencimento_documento desc,
     cd_favorecido,
     cd_identificacao_document

   drop table #TabelaDistinta
     
 end
-------------------------------------------------------------------------------
else if @ic_parametro = 3   -- listagem dos documentos para geração do Cheque.
-------------------------------------------------------------------------------
begin

 -- carrega tabela temporária c/ as informações do documento_pagar

 select
   d.*,
   isnull(p.ic_deposito_conta, 'N') as 'ic_deposito_conta'
 into
   #Documento_pagar
 from
   Documento_pagar d                           with (nolock)
   left outer join Documento_pagar_pagamento p with (nolock) on d.cd_documento_pagar = p.cd_documento_pagar 
 where
   d.dt_vencimento_documento between @dt_inicial and @dt_final     and  --Data do Vencimento
   cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) > 0 and  --Saldo do Documento
   not exists ( select 'x'
                from
                  Cheque_Pagar b      with (nolock) 
                where 
                  p.cd_tipo_pagamento = (select
                                           min(cd_tipo_pagamento)
                      		         from
                     		           tipo_pagamento_documento
                     		         where
                    		           sg_tipo_pagamento like 'CHEQU%') and
                  p.cd_identifica_documento = cast(b.cd_cheque_pagar as varchar(20)) and
	          p.cd_conta_banco = b.cd_conta_banco )


   --Verifica se existe pagamento 
   --Carlos 11.04.2006
   --Comentado porque não estava trazendo os documentos com Saldo a Pagar, devido a pelo menos
   --existir 01 baixa

   --and
   --not exists(select top 1 cd_documento_pagar 
   --           from documento_pagar_pagamento p 
   --          where  p.cd_documento_pagar = d.cd_documento_pagar and 
   --                  p.cd_identifica_documento is not null)
         
 select
   distinct
   d.cd_documento_pagar,
   d.dt_vencimento_documento,
   c.nm_tipo_conta_pagar,
   c.sg_tipo_conta_pagar,
   case when (isnull(d.cd_fornecedor, '') <> '') 
        then cast(d.nm_fantasia_fornecedor as varchar(30)) 
        when (isnull(d.cd_empresa_diversa, 0) <> 0) 
        then cast((select top 1 z.sg_empresa_diversa 
                   from empresa_diversa z 
                   where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
        when (isnull(d.cd_contrato_pagar, 0) <> 0) 
        then cast((select top 1 w.nm_fantasia_fornecedor 
                   from contrato_pagar w 
                   where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))
        when (isnull(d.cd_funcionario, 0) <> 0) 
        then cast((select top 1 k.nm_funcionario 
                   from funcionario k 
                   where k.cd_funcionario = d.cd_funcionario) as varchar(30))
   end                             as 'cd_favorecido',               
   case when (isnull(d.cd_fornecedor, '') <> '') 
        then cast((select top 1 o.nm_razao_social 
                   from fornecedor o 
                   where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  
        when (isnull(d.cd_empresa_diversa, 0) <> 0) 
        then cast((select top 1 z.nm_empresa_diversa  
                   from empresa_diversa z 
                   where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))
        when (isnull(d.cd_funcionario, 0) <> 0) 
        then cast((select top 1 k.nm_funcionario 
                   from funcionario k 
                   where k.cd_funcionario = d.cd_funcionario) as varchar(50))
        when (isnull(d.cd_contrato_pagar, 0) <> 0) 
        then cast((select top 1 w.nm_contrato_pagar 
                   from contrato_pagar w 
                   where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))                      
   end                             as 'nm_favorecido',     
   d.cd_identificacao_document,
   cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar',
   'S' as 'ic_pagar',
   d.cd_pedido_compra,
   ic_pedido_compra_aprovado =
   case
     when exists (select top 1 b.cd_pedido_compra 
		  from pedido_compra_aprovacao b 
		  where d.cd_pedido_compra = b.cd_pedido_compra) 
     then case when ((((select top 1 b.vl_total_pedido_compra 
	                from pedido_compra b 
                        where d.cd_pedido_compra = b.cd_pedido_compra) <= @vl_liberacao_pedido_compra) and 
			((select b.cd_usuario_aprovacao 
                          from pedido_compra_aprovacao b 
                          where d.cd_pedido_compra = b.cd_pedido_compra and 
                                cd_tipo_aprovacao = 2) is null)) or 
                         (((select top 1 b.vl_total_pedido_compra 
                            from pedido_compra b 
                            where d.cd_pedido_compra = b.cd_pedido_compra) > @vl_liberacao_pedido_compra) and 
                         ((select b.cd_usuario_aprovacao 
                           from pedido_compra_aprovacao b 
                           where d.cd_pedido_compra = b.cd_pedido_compra and 
                                 cd_tipo_aprovacao = 3) is null))) 
                then 'N' else 'S' end
      else 'S' end,
   case when (isnull(d.cd_fornecedor, '') <> '') 
   then (select top 1 f.cd_banco 
         from fornecedor f 
         where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor)
   when (isnull(d.cd_empresa_diversa, 0) <> 0) 
   then (select top 1 z.cd_banco 
         from empresa_diversa z 
         where z.cd_empresa_diversa = d.cd_empresa_diversa)
   when (isnull(d.cd_funcionario, 0) <> 0) 
   then (select top 1 k.cd_banco 
         from funcionario k 
         where k.cd_funcionario = d.cd_funcionario)
   when (isnull(d.cd_contrato_pagar, 0) <> 0) 
   then (select top 1 f.cd_banco 
         from fornecedor f, contrato_pagar w 
         where w.cd_contrato_pagar = d.cd_contrato_pagar and 
               w.cd_fornecedor = f.cd_fornecedor)
   end as 'cd_banco',               
   case when (isnull(d.cd_fornecedor, '') <> '') 
   then cast((select top 1 f.cd_agencia_banco 
              from fornecedor f 
              where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
   when (isnull(d.cd_empresa_diversa, 0) <> 0) 
   then cast((select top 1 z.cd_agencia_banco 
              from empresa_diversa z 
              where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
   when (isnull(d.cd_funcionario, 0) <> 0) 
   then cast((select top 1 k.cd_agencia_funcionario 
              from funcionario k 
              where k.cd_funcionario = d.cd_funcionario) as varchar(20))
   when (isnull(d.cd_contrato_pagar, 0) <> 0) 
   then cast((select top 1 f.cd_agencia_banco 
              from fornecedor f, contrato_pagar w 
              where w.cd_contrato_pagar = d.cd_contrato_pagar and 
                    w.cd_fornecedor = f.cd_fornecedor) as varchar(20))
   end as 'cd_agencia_banco',               
   case when (isnull(d.cd_fornecedor, '') <> '') 
   then cast((select top 1 f.cd_conta_banco 
              from fornecedor f 
              where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
   when (isnull(d.cd_empresa_diversa, 0) <> 0) 
   then cast((select top 1 z.cd_conta_corrente 
              from empresa_diversa z 
              where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
   when (isnull(d.cd_funcionario, 0) <> 0) 
   then cast((select top 1 k.cd_conta_funcionario 
              from funcionario k 
              where k.cd_funcionario = d.cd_funcionario) as varchar(20))
   when (isnull(d.cd_contrato_pagar, 0) <> 0) 
   then cast((select top 1 f.cd_conta_banco 
              from fornecedor f, contrato_pagar w 
              where w.cd_contrato_pagar = d.cd_contrato_pagar and 
                    w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
   end as 'cd_conta_banco',               
   d.ic_deposito_conta,
   d.nm_observacao_documento
 from
   #Documento_pagar d
 left outer join
   tipo_conta_pagar c
 on
   d.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar
 order by
   d.dt_vencimento_documento desc,
   c.nm_tipo_conta_pagar,
   cd_favorecido,
   d.cd_identificacao_document

end

-------------------------------------------------------
else if @ic_parametro = 4 -- Baixar Cheque Pagar
-------------------------------------------------------
begin

 declare @vl_pagamento_documento float

 set @cd_tipo_pagamento = 2 -- Cheques.

 -- permitir a baixa somente dos cheques que não foram baixados
 if (select
       ic_baixado_cheque_pagar
     from
       Cheque_Pagar with (nolock) 
     where
       cd_cheque_pagar = @cd_cheque_pagar and
       cd_conta_banco  = @cd_conta_banco) = 'S'
   begin
     raiserror('Cheque já Liquidado, Operação Cancelada !', 16, 1)
     goto TrataErro
   end

 --Tabela temporária com documentos a pagar do cheque informado
 select
   cd_documento_pagar,
   vl_pagamento_documento
 into
   #Documento_Cheque
 from
   Documento_Pagar_Pagamento
 where
   cd_tipo_pagamento       = @cd_tipo_pagamento and 
   cd_identifica_documento = cast(@cd_cheque_pagar as varchar(20)) and
   cd_conta_banco          = @cd_conta_banco


 --Atualiza Saldo dos Documentos a Pagar do Cheque
 while exists(select top 1 'x' from #Documento_Cheque)
 begin
   
   select
     @cd_documento_pagar     = cd_documento_pagar,
     @vl_pagamento_documento = vl_pagamento_documento
   from
     #Documento_Cheque

   update
     Documento_Pagar
   set
     vl_saldo_documento_pagar = @vl_pagamento_documento - 
     vl_saldo_documento_pagar,
     cd_usuario = @cd_usuario,
     dt_usuario = getDate()
   where
     cd_documento_pagar = @cd_documento_pagar

   delete from
     #Documento_Cheque
   where
     cd_documento_pagar = @cd_documento_pagar    

 end

 --Atualiza Borderô
 update
   Cheque_Pagar
 set
   ic_baixado_cheque_pagar = 'S',
   dt_liquidacao_cheque    = @dt_liquidacao_cheque,
   cd_usuario              = @cd_usuario,
   dt_usuario              = getDate()
 where
   cd_cheque_pagar = @cd_cheque_pagar and
   cd_conta_banco  = @cd_conta_banco

 --Atualiza a data de pagamento em documento_pagar_pagamento

 update
   documento_pagar_pagamento
 set
   dt_pagamento_documento = @dt_liquidacao_cheque
 where
   cd_tipo_pagamento       = @cd_tipo_pagamento and
   cd_identifica_documento = cast(@cd_cheque_pagar as varchar(20)) and
   cd_conta_banco          = @cd_conta_banco

 -- Atualiza o lançamento financeiro do cheque (Inclusão ou modificação)
 -- carregar os parâmetros do cheque (eles não são passados neste parâmetro)
 select
   @cd_banco = cd_banco
 from
   cheque_pagar with (nolock) 
 where
   cd_cheque_pagar = @cd_cheque_pagar and
   cd_conta_banco  = @cd_conta_banco

 exec pr_lancamento_cheque_pagar_financeiro 1, @cd_cheque_pagar, @cd_banco, @cd_conta_banco, @cd_usuario

end

-----------------------------------------------------------------------------
else if @ic_parametro = 5 -- Estornar o Cheque.
-----------------------------------------------------------------------------
begin

 select
   *
 into
   #Documento_Cheque_Estorno
 from
   documento_pagar_pagamento
 where
   cd_identifica_documento = cast(@cd_cheque_pagar as varchar(20)) and
   cd_tipo_pagamento      = 2 and
   cd_conta_banco         = @cd_conta_banco -- Somente os cheques.

 while exists(select top 1 cd_documento_pagar from #Documento_Cheque_Estorno)
   begin

     select
       top 1
       @cd_documento_pagar = cd_documento_pagar
     from
       #Documento_Cheque_Estorno

     delete
       documento_pagar_pagamento
     where
       cd_documento_pagar = @cd_documento_pagar

     --Deleta o cheque do documento
  
     update
       documento_pagar
     set
       vl_saldo_documento_pagar = vl_documento_pagar,
       cd_usuario               = @cd_usuario,
       dt_usuario               = getDate(),
       cd_cheque_pagar          = Null
     where
       cd_documento_pagar = @cd_documento_pagar
     
     --Deleta todos dos cheques

     update
       documento_pagar
     set
       cd_cheque_pagar        = null
     where
       cd_cheque_pagar        = @cd_cheque_pagar
     

     delete from
       #Documento_Cheque_Estorno
     where
       cd_documento_pagar = @cd_documento_pagar

   end

 -- Apaga o lançamento financeiro do cheque (Inclusão ou modificação)
 -- carregar os parâmetros do cheque (eles não são passados neste parâmetro)

 select
   @cd_banco = cd_banco
 from
   cheque_pagar with (nolock) 
 where
   cd_cheque_pagar = @cd_cheque_pagar and
   cd_conta_banco  = @cd_conta_banco

 exec pr_lancamento_cheque_pagar_financeiro 2, @cd_cheque_pagar, @cd_banco, null, @cd_usuario

 delete from
   Cheque_Pagar
 where
   cd_cheque_pagar = @cd_cheque_pagar and
   cd_conta_banco  = @cd_conta_banco

end

-----------------------------------------------------------------------------
else if @ic_parametro = 6 -- Deletar Cheque.
-----------------------------------------------------------------------------
begin

 -- tipo do pagamento (Cheque)
 set @cd_tipo_pagamento = 2


 -- permitir a exclusão somente dos borderôs que não foram baixados

 if (select
       ic_baixado_cheque_pagar
     from
       Cheque_Pagar with (nolock) 
     where
       cd_cheque_pagar = @cd_cheque_pagar and
       cd_conta_banco  = @cd_conta_banco) = 'S'
   begin
     raiserror('Cheque já Liquidado, Operação Cancelada!', 16, 1)
     goto TrataErro
   end
 else
   begin
     -- antes de excluir os pagamentos do cheque, acertar os documentos quanto aos
     -- valores de juros, desconto e abatimento

     

     set     @cd_documento_pagar       = 0
     set     @vl_juros_documento       = 0
     set     @vl_desconto_documento    = 0
     set     @vl_abatimento_documento  = 0

     select
       cd_documento_pagar,
       vl_juros_documento_pagar,
       vl_desconto_documento,
       vl_abatimento_documento
     into
       #documento_pagar_pagamento
     from
       documento_pagar_pagamento
     where
       cd_tipo_pagamento       = @cd_tipo_pagamento and
       cd_identifica_documento = cast(@cd_cheque_pagar as varchar(50)) and
       cd_conta_banco          = @cd_conta_banco

     -- excluir pagamentos do borderô
     delete from
       documento_pagar_pagamento
     where
       cd_tipo_pagamento       = @cd_tipo_pagamento and
       cd_identifica_documento = cast(@cd_cheque_pagar as varchar(50)) and
       cd_conta_banco          = @cd_conta_banco
     
     while exists(select top 1 cd_documento_pagar from #documento_pagar_pagamento)
       begin
      
         select
           @cd_documento_pagar       = cd_documento_pagar,
           @vl_juros_documento       = isnull(vl_juros_documento_pagar,0),
           @vl_desconto_documento    = isnull(vl_desconto_documento,0),
           @vl_abatimento_documento  = isnull(vl_abatimento_documento,0)
         from
           #documento_pagar_pagamento

         -- atualizando o documento
         if ((@vl_juros_documento  <> 0) or
           (@vl_desconto_documento <> 0) or
           (@vl_abatimento_documento <> 0))          

           update
             documento_pagar
           set
             vl_juros_documento       = @vl_juros_documento,
             vl_desconto_documento    = @vl_desconto_documento,
             vl_abatimento_documento  = @vl_abatimento_documento,
             vl_saldo_documento_pagar = 
            (cast(str(vl_documento_pagar,25,2) as decimal(25,2)) -
            (select
               isnull(sum(cast(str(vl_pagamento_documento,25,2) as decimal(25,2))),0) -
               isnull(sum(cast(str(vl_juros_documento_pagar,25,2) as decimal(25,2))),0) +
               isnull(sum(cast(str(vl_desconto_documento,25,2) as decimal(25,2))),0) +
               isnull(sum(cast(str(vl_abatimento_documento,25,2) as decimal(25,2))),0)
             from
               documento_pagar_pagamento
             where cd_documento_pagar = @cd_documento_pagar) +
            cast(str(@vl_juros_documento,25,2) as decimal(25,2)) -
            cast(str(@vl_desconto_documento,25,2) as decimal(25,2)) -
            cast(str(@vl_abatimento_documento,25,2) as decimal(25,2))),
             cd_usuario = @cd_usuario,
             dt_usuario = getDate()

           where
             cd_documento_pagar = @cd_documento_pagar

         delete from
           #documento_pagar_pagamento
         where
           cd_documento_pagar = @cd_documento_pagar

       end              

     -- Apaga o lançamento financeiro do cheque
     -- carregar os parâmetros do cheque (eles não são passados neste parâmetro)
     select
       @cd_banco = cd_banco
     from
       cheque_pagar with (nolock) 
     where
       cd_cheque_pagar = @cd_cheque_pagar and
       cd_conta_banco  = @cd_conta_banco

     exec pr_lancamento_cheque_pagar_financeiro 2, @cd_cheque_pagar, @cd_banco, null, @cd_usuario

     -- excluir 
     delete from
       Cheque_Pagar
     where
       cd_cheque_pagar = @cd_cheque_pagar and
       cd_conta_banco  = @cd_conta_banco

     --Deleta todos dos cheques

     update
       documento_pagar
     set
       cd_cheque_pagar        = null
     where
       cd_cheque_pagar        = @cd_cheque_pagar


   end

end

-- atualizando banco de dados    

TrataErro:
 if @@ERROR = 0
   begin
     commit tran
   end
 else
   begin
     --raiserror(@@ERROR, 16, 1)
     rollback tran
   end

