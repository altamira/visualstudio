
-------------------------------------------------------------------------------
--sp_helptext pr_copia_classificacao_fiscal
-------------------------------------------------------------------------------
--pr_copia_classificacao_fiscal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Cópia da Classificação Fiscal
--Data             : 28/05/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_classificacao_fiscal
@cd_classificacao_fiscal int = 0,
@cd_usuario              int = 0

as


declare @Tabela		     varchar(50)
declare @cd_classificacao    int


  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Classificacao_Fiscal' as varchar(50))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_classificacao_fiscal', @codigo = @cd_classificacao output
	
  while exists(Select top 1 'x' from Classificacao_fiscal where cd_classificacao_fiscal = @cd_classificacao)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_classificacao_fiscal', @codigo = @cd_classificacao output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_classificacao, 'D'
  end

  --select @cd_classificacao

if @cd_classificacao_fiscal>0 
begin

  select
    @cd_classificacao                            as cd_classificacao_fiscal,
    cd_mascara_classificacao,
    nm_classificacao_fiscal,
    sg_classificacao_fiscal,
    pc_ipi_classificacao,
    ic_subst_tributaria,
    ic_base_reduzida,
    cd_dispositivo_legal,
    cd_unidade_medida,
    pc_importacao,
    @cd_usuario                                  as cd_usuario,
    getdate()                                    as dt_usuario,
    qt_siscomex_clas_fiscal,
    ds_classificacao_fiscal,
    ic_ativa_classificacao,
    cd_tributacao,
    cd_dispositivo_legal_ipi,
    cd_especie_produto,
    pc_ipi_entrada_classif,
    cd_norma_origem,
    cd_grupo_bem,
    ic_licenca_importacao

  into
     #Classificacao_Fiscal
  from
    Classificacao_Fiscal
  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal

  insert into
    classificacao_fiscal
  select
    *
  from
    #classificacao_fiscal

  select
    @cd_classificacao_fiscal                     as cd_classificacao_fiscal,
    cd_idioma,
    nm_classif_fiscal_idioma,
    ds_classif_fiscal_idioma,
    @cd_usuario                                  as cd_usuario,
    getdate()                                    as dt_usuario,
    nm_clas_fiscal_idioma,
    ds_clas_fiscal_idioma
  into
    #Classificacao_Fiscal_Idioma
  from
    Classificacao_Fiscal_Idioma
  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal


  insert into
    classificacao_fiscal_idioma
  select
    *
  from
    #classificacao_fiscal_idioma

   select
     @cd_classificacao_fiscal                    as cd_classificacao_fiscal,
     cd_dispositivo_legal,
     cd_item_dispositivo,
     nm_obs_item_dispositivo,
     @cd_usuario                                  as cd_usuario,
     getdate()                                    as dt_usuario
   into
     #Classificacao_Fiscal_Dispos
   from
     Classificacao_Fiscal_Dispos
   where
     cd_classificacao_fiscal = @cd_classificacao_fiscal
  
  insert into
    classificacao_fiscal_dispos
  select
    *
  from
    #classificacao_fiscal_dispos

  select
    @cd_classificacao_fiscal                     as cd_classificacao_fiscal,
    cd_estado,
    pc_icms_classif_fiscal,
    pc_redu_icms_class_fiscal,
    cd_dispositivo_legal,
    nm_classif_fiscal_estado,
    @cd_usuario                                  as cd_usuario,
    getdate()                                    as dt_usuario,
    pc_icms_clas_fiscal,
    pc_red_icms_clas_fiscal,
    nm_clas_fiscal_estado,
    pc_icms_strib_clas_fiscal,
    pc_interna_icms_clas_fis,
    cd_dispositivo_legal_ipi

  into
    #Classificacao_Fiscal_Estado
  from
    Classificacao_Fiscal_Estado

  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal

  insert into
    classificacao_fiscal_estado
  select
    *
  from
    #classificacao_fiscal_estado



  --deleta as Tabelas
  drop table #classificacao_fiscal
  drop table #Classificacao_Fiscal_Idioma
  drop table #Classificacao_Fiscal_Dispos
  drop table #Classificacao_Fiscal_Estado


end

--Libera o Código
exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_classificacao, 'D'

