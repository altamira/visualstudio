
CREATE procedure sp_InsereAtributo_Padrao
@cd_atributo int output,
@nm_atributo varchar (40),
@ds_atributo varchar (40),
@cd_natureza_atributo int,
@qt_tamanho_atributo int,
@qt_decimal_atributo int,
@nm_mascara_atributo varchar (20),
@nm_atributo_relatorio varchar (40),
@nm_atributo_consulta varchar (40),
@ic_numeracao_automatica char (1),
@ic_atributo_chave char (1),
@nm_atributo_tabela_dbf char (10),
@cd_help int,
@ic_atributo_obrigatorio char (1),
@ic_mostra_grid char (1),
@ic_edita_cadastro char(1),
@ic_mostra_relatorio char(1),
@ic_mostra_cadastro char(1),
@vl_default char(20),
@nu_ordem int,
@ic_chave_estrangeira char(1),
@ic_combo_box char(1),
@nm_campo_mostra_combo_box varchar(50),
@nm_campo_chave_combo_box varchar(50),
@nm_tabela_combo_box varchar(50),
@ic_lista_valor varchar(20),
@nm_alias varchar(20),
@cd_usuario int,
@dt_usuario datetime,
@ic_formata_string char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_atributo = ISNULL(MAX(cd_atributo),0) + 1 FROM Atributo TABLOCK
  INSERT INTO Atributo
             ( cd_atributo,
               nm_atributo,
               ds_atributo,
               cd_natureza_atributo,
               qt_tamanho_atributo,
               qt_decimal_atributo,
               nm_mascara_atributo,
               nm_atributo_relatorio,
               nm_atributo_consulta,
               ic_numeracao_automatica,
               ic_atributo_chave,
               nm_atributo_tabela_dbf,
               cd_help,
               ic_atributo_obrigatorio,
               ic_mostra_grid,
               ic_edita_cadastro,
               ic_mostra_relatorio,
               ic_mostra_cadastro,
               vl_default,
               nu_ordem,
               ic_chave_estrangeira,
               ic_combo_box,
               nm_campo_mostra_combo_box,
               nm_campo_chave_combo_box, 
               nm_tabela_combo_box,
               ic_lista_valor,
               nm_alias,
               cd_usuario,
               dt_usuario,
               ic_formata_string )
      VALUES ( @cd_atributo,
               @nm_atributo,
               @ds_atributo,
               @cd_natureza_atributo,
               @qt_tamanho_atributo,
               @qt_decimal_atributo,
               @nm_mascara_atributo,
               @nm_atributo_relatorio,
               @nm_atributo_consulta,
               @ic_numeracao_automatica,
               @ic_atributo_chave,
               @nm_atributo_tabela_dbf,
               @cd_help,
               @ic_atributo_obrigatorio,
               @ic_mostra_grid,
               @ic_edita_cadastro,
               @ic_mostra_relatorio,
               @ic_mostra_cadastro,
               @vl_default,
               @nu_ordem,
               @ic_chave_estrangeira,
               @ic_combo_box,
               @nm_campo_mostra_combo_box,
               @nm_campo_chave_combo_box, 
               @nm_tabela_combo_box,
               @ic_lista_valor,
               @nm_alias,
               @cd_usuario,
               @dt_usuario,
               @ic_formata_string  )
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

