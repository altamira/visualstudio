CREATE PROCEDURE pr_consulta_reajuste_cliente
---------------------------------------------------------------------
--pr_consulta_reajuste_cliente
---------------------------------------------------------------------
--GBS - Global Business Solution Ltda                            2004
---------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server  2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : EGISSQL
--Objetivo         : Consulta de Produtos para Alteração Definitiva 
--                   do Preço por cliente
--Data		   : 03/11/2006
--Atualização      : 10.07.2007 - Acerto no Preço da Tabela Correta - Produto_Cliente - Carlos Fernandes
---------------------------------------------------------------------------------------------------------

@ic_parametro            int         = 0,
@cd_cliente              int         = 0,
@pc_reajuste             float       = 0,
@cd_motivo_reajuste      int         = 0,
@nm_obs_produto_preco    varchar(40) = '',
@cd_usuario              int         = 0,
@dt_usuario              datetime    = 0,
@ic_filtrar_com_preco    char(1)     = 'S'
as

set @ic_filtrar_com_preco = isnull(@ic_filtrar_com_preco,'S')

declare @cd_tipo_reajuste int,
	@cd_tipo_tabela_preco int

-------------------------------------------------------------------
if @ic_parametro = 1 --Consulta filtrada por Cliente
-------------------------------------------------------------------
begin
  select
    p.cd_produto
  into
    #Produtos
  from
    Produto p
    left outer join Produto_Custo pc on pc.cd_produto=p.cd_produto
  where    
    p.cd_produto in (
      Select cd_produto From Produto_Cliente Where cd_cliente = @cd_cliente
    )

  select
    p.cd_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    u.sg_unidade_medida,
    case when isnull(pcli.vl_produto_cliente,0)>0 
    then
      isnull(pcli.vl_produto_cliente,0) 
    else
      isnull(p.vl_produto,0)
    end                                as vl_produto,
    0.00                               as vl_temp_produto_preco,
    0.00                               as qt_indice_produto_preco,
    case when isnull(mc.sg_moeda,'')<>''
    then
      mc.sg_moeda 
    else
      mp.sg_moeda
    end                                as sg_moeda
  from
  #Produtos ptemp
  inner Join Produto p                 on p.cd_produto=ptemp.cd_produto
  left outer join Produto_Custo pc     on pc.cd_produto=p.cd_produto
  left outer join Unidade_Medida u     on u.cd_unidade_medida=p.cd_unidade_medida
  left outer join Produto_Preco pp     on pp.cd_produto=p.cd_produto
  left outer join Produto_Cliente pcli on pcli.cd_produto = p.cd_produto and
                                          pcli.cd_cliente = @cd_cliente
  left outer join Moeda mp             on mp.cd_moeda      = p.cd_moeda
  left outer join Moeda mc             on mc.cd_moeda      = pcli.cd_moeda
--select * from produto_cliente

  where
    ( (@ic_filtrar_com_preco = 'N') or
      (isnull(p.vl_produto,0) > 0 ) )
  order by
    2, 3
end

-------------------------------------------------------------------
if @ic_parametro = 2 --Atualização dos Preços de acordo com o 
                     --Grupo de Preço
-------------------------------------------------------------------
begin

	--Define o tipo de Reajuste como sendo manual
	set @cd_tipo_reajuste = 
    (select top 1 cd_tipo_reajuste from Tipo_Reajuste where ic_manual_tipo_reajuste='S')
  print @cd_tipo_reajuste

	--Define o tipo de tabela como sendo a padrão
	set @cd_tipo_tabela_preco =
	  (select top 1 cd_tipo_tabela_preco from Tipo_Tabela_Preco where ic_pad_tipo_tabela_preco='S')

	Select
          identity(int,1,1)                                    as cd_historico,
	  p.cd_produto,
	  @dt_usuario                                          as dt_produto_preco,
	  case when isnull(pcli.vl_produto_cliente,0)>0
          then
            pcli.vl_produto_cliente
          else
            p.vl_produto
          end                                                  as vl_atual_produto_preco,

	  case when isnull(pcli.vl_produto_cliente,0)>0
          then
            pcli.vl_produto_cliente + ( pcli.vl_produto_cliente / 100 * @pc_reajuste )
          else            
            p.vl_produto + ( p.vl_produto / 100 * @pc_reajuste )
          end                                                  as vl_temp_produto_preco,
	  @cd_tipo_reajuste                                    as cd_tipo_reajuste,
	  @cd_motivo_reajuste                                  as cd_motivo_reajuste,
	  @nm_obs_produto_preco                                as nm_obs_produto_preco,
	  @cd_usuario                                          as cd_usuario,
	  IsNull(p.cd_moeda,1)                                 as cd_moeda,
	  @dt_usuario                                          as dt_usuario
	into
	  #Produto
	from
	  Produto p 
          inner join Produto_Custo pc          on p.cd_produto    = pc.cd_produto
          left outer join Produto_Cliente pcli on pcli.cd_produto = p.cd_produto and
                                                  pcli.cd_cliente = @cd_cliente
	where
          p.cd_produto in ( Select cd_produto From Produto_Cliente Where cd_cliente = @cd_cliente )


        update
          produto_cliente
        set
          vl_produto_cliente = p.vl_temp_produto_preco
        from
          produto_cliente pc
          inner join #Produto p on p.cd_produto = pc.cd_produto 
        where
          pc.cd_cliente = @cd_cliente
                                       

        --Atualização do Histórico de Reajuste
   
        declare @cd_historico int

        select @cd_historico = max( isnull(cd_historico,0) ) + 1
        from 
         Produto_Cliente_Historico

        if @cd_historico=0 
        begin
           set @cd_historico = 1
        end
 
--        select @cd_historico

        select
          @cd_historico+
          p.cd_historico         as cd_historico,
          @cd_cliente            as cd_cliente,
          p.cd_produto           as cd_produto,
          p.cd_tipo_reajuste     as cd_tipo_reajuste,
          null                   as cd_tipo_tabela_preco,
          @cd_usuario            as cd_usuario,
          getdate()              as dt_usuario,
          p.cd_motivo_reajuste   as cd_motivo_reajuste,
          getdate()              as dt_historico,
          vl_atual_produto_preco as vl_historico
        into
          #Produto_Cliente_Historico            
        from
          #Produto p

        --select * from produto_cliente_historico

        insert into Produto_Cliente_Historico
        select
          *
        from
          #Produto_Cliente_Historico       

	insert into Produto_Preco
	Select
		cd_produto,
		dt_produto_preco,
		IsNull(vl_atual_produto_preco,0),
		IsNull(vl_temp_produto_preco,0),
		@pc_reajuste,
		@nm_obs_produto_preco,
		0,
		cd_moeda,
		cd_tipo_reajuste,
		@cd_motivo_reajuste,
		@cd_tipo_tabela_preco,
		@cd_usuario,
		dt_usuario,
                @cd_cliente,
                null  -- código do Servico
	from
		#Produto



end

