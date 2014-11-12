
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)       : GBS
--Banco de Dados  : EGISADMIN
--Objetivo        :  
--Data            : 01.02.2001
--Atualizado      : 14.05.2006 - Novo Atributo -0 Imagem - Carlos Fernandes
-----------------------------------------------------------------------------------------
CREATE  procedure sp_AlteraAtributo  
--dados depois da execuçao (novos)  
@cd_tabela   int,  
@cd_atributo int,  
@nm_atributo varchar (40),  
@ds_atributo             varchar (40),  
@cd_natureza_atributo    int,  
@qt_tamanho_atributo     int,  
@qt_decimal_atributo     int,  
@nm_mascara_atributo     varchar (20),  
@nm_atributo_relatorio   varchar (40),  
@nm_atributo_consulta    varchar (40),  
@ic_numeracao_automatica char (1),  
@ic_atributo_chave       char (1),  
@nm_atributo_tabela_dbf  char (10),  
@cd_help                 int,  
@ic_atributo_obrigatorio char (1),  
@ic_mostra_grid          char (1),  
@ic_edita_cadastro       char(1),  
@ic_mostra_relatorio char(1),  
@ic_mostra_cadastro char(1),  
@vl_default char(20),  
@nu_ordem int,  
@ic_chave_estrangeira char(1),  
@ic_combo_box char(1),  
@nm_campo_mostra_combo_box varchar(50),  
@nm_campo_chave_combo_box varchar(50),  
@nm_tabela_combo_box varchar(50),  
--dados antes da execuçao (antigos)  
@cd_tabela_old int ,  
@cd_atributo_old int,  
@ic_lista_valor char(1),  
@nm_alias varchar(20),  
@cd_usuario int,  
@dt_usuario datetime,  
@ic_formata_string char(1),  
@ic_alteracao char(1),  
@ds_campo_help Text,  
@ic_atributo_clustered char(1),  
@qt_atributo_fillfactor int,  
@ic_usar_spin char(1),  
@ic_aliasadmin_combo_box char(1),  
@ic_grafico_atributo     char(1),  
@ic_grid_agrupado_atributo char(1),
@ic_site_atributo char(1),   
@ic_doc_caminho_atributo char(1),
@ic_tabela_composicao   char(1),
@nm_tabsheet_lookup      varchar(15),
@ic_imagem_atributo     char(1) = 'N',
@ic_filtro_atributo	char(1) = 'N',
@ic_cep_atributo	char(1) = 'N',
@ic_classe_atributo	char(1) = 'N',
@ic_imagem_sistema_atributo  char(1) = 'N',
--@cd_classe	int=0,
@ic_senha  char(1) = 'N',
@ic_codigo_barra  char(1) = 'N',
@cd_tipo_codigo_barra   int     = 0,
@cd_imagem              int     = 0

  
AS  
BEGIN  
  --inicia a transaçao  
  BEGIN TRANSACTION  
  --gera código e executa travamento  
  UPDATE Atributo SET  
         cd_tabela                 = @cd_tabela,  
         cd_atributo               = @cd_atributo,  
         nm_atributo               = @nm_atributo,  
         ds_atributo               = @ds_atributo,  
         cd_natureza_atributo      = @cd_natureza_atributo,  
         qt_tamanho_atributo       = @qt_tamanho_atributo,  
         qt_decimal_atributo       = @qt_decimal_atributo,  
         nm_mascara_atributo       = @nm_mascara_atributo,  
         nm_atributo_relatorio     = @nm_atributo_relatorio,  
         nm_atributo_consulta      = @nm_atributo_consulta,  
         ic_numeracao_automatica   = @ic_numeracao_automatica,  
         ic_atributo_chave         = @ic_atributo_chave,  
         nm_atributo_tabela_dbf    = @nm_atributo_tabela_dbf,  
         cd_help                   = @cd_help,  
         ic_atributo_obrigatorio   = @ic_atributo_obrigatorio,  
         ic_mostra_grid            = @ic_mostra_grid,  
         ic_edita_cadastro         = @ic_edita_cadastro,  
         ic_mostra_relatorio       = @ic_mostra_relatorio,  
         ic_mostra_cadastro        = @ic_mostra_cadastro,  
         vl_default                = @vl_default,  
         nu_ordem                  = @nu_ordem,  
         ic_chave_estrangeira      = @ic_chave_estrangeira,  
         ic_combo_box              = @ic_combo_box,  
         nm_campo_mostra_combo_box = @nm_campo_mostra_combo_box,  
         nm_campo_chave_combo_box  = @nm_campo_chave_combo_box,  
         nm_tabela_combo_box       = @nm_tabela_combo_box,  
         ic_lista_valor            = @ic_lista_valor,  
         nm_alias                  = @nm_alias,  
         cd_usuario                = @cd_usuario,  
         dt_usuario                = @dt_usuario,  
         ic_formata_string         = @ic_formata_string,  
         ic_alteracao              = @ic_alteracao,  
         ds_campo_help             = @ds_campo_help,  
         ic_atributo_clustered     = @ic_atributo_clustered,  
         qt_atributo_fillfactor    = @qt_atributo_fillfactor,  
         ic_usar_spin              = @ic_usar_spin,  
         ic_aliasadmin_combo_box   = @ic_aliasadmin_combo_box,  
         ic_grafico_atributo       = @ic_grafico_atributo,  
         ic_grid_agrupado_atributo = @ic_grid_agrupado_atributo,
         ic_site_atributo          = @ic_site_atributo,
         ic_doc_caminho_atributo   = @ic_doc_caminho_atributo,
         ic_tabela_composicao      = @ic_tabela_composicao,
         nm_tabsheet_lookup        = @nm_tabsheet_lookup,
         ic_imagem_atributo        = @ic_imagem_atributo,
         cd_imagem                 = @cd_imagem  ,
			ic_filtro_atributo        = @ic_filtro_atributo,
			ic_cep_atributo           = @ic_cep_atributo,
			ic_classe_atributo        = @ic_classe_atributo,
			ic_imagem_sistema_atributo = @ic_imagem_sistema_atributo,
			ic_senha                  = @ic_senha,  
         ic_codigo_barra           = @ic_codigo_barra,
			cd_tipo_codigo_barra      = @cd_tipo_codigo_barra
--			cd_classe        			  = @cd_classe

     WHERE  
         cd_tabela = @cd_tabela_old and   
         cd_atributo = @cd_atributo_old  
  if @@ERROR = 0  
    COMMIT TRAN  
  else  
  begin  
  --RAISERROR @@ERROR  
    ROLLBACK TRAN  
  end  
end  
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON  

