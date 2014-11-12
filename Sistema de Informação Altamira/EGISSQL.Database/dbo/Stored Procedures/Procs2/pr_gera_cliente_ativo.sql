
-------------------------------------------------------------------------------
--pr_gera_cliente_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Geração de Cliente Prospecção para cliente Ativo
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_gera_cliente_ativo

@cd_cliente_prospeccao int,
@cd_usuario            int
as


--Verifica se o Cliente prospecção já existe no Cadastro

if not exists ( select cd_cliente_prospeccao from cliente where cd_cliente_prospeccao = @cd_cliente_prospeccao )
begin

--select * from cliente_prospeccao
  --busca o código do Cliente

  declare @cd_cliente           int
  declare @nm_fantasia_cliente  varchar(15)
  declare @Tabela	        varchar(50)
  declare @ic_consistencia      int
  declare @cd_contato           int

  set @Tabela      = cast(DB_NAME()+'.dbo.Cliente' as varchar(50))
  set @cd_cliente = 0

  while @cd_cliente = 0
  begin

    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_cliente', @codigo = @cd_cliente output	     
 
    --Verifica se Existe o Cliente na Tabela

    if not exists(select cd_cliente from cliente where cd_cliente = @cd_cliente )
    begin

         --Verifica se o Nome Fantasia do cliente já existe no Cadastro

        select 
          @nm_fantasia_cliente = nm_fantasia_cliente
        from
          Cliente_prospeccao
        where
          cd_cliente_prospeccao = @cd_cliente_prospeccao

        set @ic_consistencia = 0

        select 
          @ic_consistencia = isnull(cd_cliente,0) 
        from
          Cliente
        where
          nm_fantasia_cliente = @nm_fantasia_cliente

        -- Realiza a Gravação do cliente

        if @ic_consistencia=0
        begin

          insert cliente (
            cd_cliente,
            nm_fantasia_cliente,
            nm_razao_social_cliente,
            nm_dominio_cliente,
            nm_email_cliente,
            cd_status_cliente,
            dt_cadastro_cliente,
            cd_tipo_pessoa,
            cd_fonte_informacao,
            cd_ramo_atividade,
            cd_criterio_visita,
            cd_cliente_prospeccao,
            cd_tipo_mercado,
            cd_moeda,
            cd_idioma,
            cd_vendedor,
            cd_usuario,
            dt_usuario )
          select
            @cd_cliente,
            nm_fantasia_cliente,
            nm_cliente,
            nm_site_cliente,
            nm_email_cliente,
            1,
            cast( cast( getdate() as int ) as datetime),
            1,
            cd_fonte_informacao,
            cd_ramo_atividade,
            1,
            @cd_cliente_prospeccao,
            1,
            1,
            1, 
            isnull(cd_vendedor,1),
            @cd_usuario,
            getdate()
          from
            Cliente_Prospeccao
          where
            cd_cliente_prospeccao = @cd_cliente_prospeccao


          declare @qt_contato_prospeccao int
          declare @qt_aux_contato        int
 
          select @qt_contato_prospeccao = count(*) from cliente_prospeccao_contato where cd_cliente_prospeccao = @cd_cliente_prospeccao

          --select @qt_contato_prospeccao

          set @qt_aux_contato = 0

          while @qt_aux_contato < @qt_contato_prospeccao 
          begin
           
            --Busca o Código do Próximo Contato
            select @cd_contato = isnull(max(cd_contato),0) + 1 from cliente_contato where cd_cliente=@cd_cliente  

            insert Cliente_Contato (
              cd_cliente,
              cd_contato,
              nm_contato_cliente,
              nm_fantasia_contato,
              cd_ddd_contato_cliente,
              cd_telefone_contato,
              cd_fax_contato,
              cd_celular,
              cd_ramal,
              cd_email_contato_cliente,
              ds_observacao_contato,
              dt_nascimento,
              cd_usuario,
              dt_usuario )
            select
              @cd_cliente,
              @cd_contato,
              nm_contato,
              nm_fantasia_contato,
              cd_ddd_contato,
              cd_fone_contato,
              cd_fax_contato,
              cd_celular_contato,
              cd_ramal_contato,
              nm_email_contato,
              ds_obs_contato,
--              nm_cargo_contato,  
--              nm_departamento_contato,
              dt_nascimento_contato,
              @cd_usuario,
              getdate()             
            from
              Cliente_Prospeccao_Contato
            where
              cd_cliente_prospeccao = @cd_cliente_prospeccao and
              cd_prospeccao_contato = @qt_aux_contato + 1

           set @qt_aux_contato = @qt_aux_contato + 1

          end --while         

           --select * from cliente_contato
           --select * from cliente_prospeccao_contato
 
        end --if

        -- limpeza da tabela de código
       exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_cliente, 'D'

      end --if
    else
      begin
  
        -- limpeza da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_cliente, 'D'
        set @cd_cliente=0
      end
  
  end --While

  --Cliente
  --select * from cliente

   --select * from cliente_prospeccao

   --Cliente Contato
   --terminar


   --Cliente Endereço
   --terminar

   --Cliente Vendedor
   --terminar
  

end --if


