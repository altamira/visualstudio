

/****** Object:  Stored Procedure dbo.pr_InsMovCone    Script Date: 13/12/2002 15:08:10 ******/
--pr_movimentacao
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton
--Inserçao na tabela de movimentaçao de cones
--Data         : 20.03.2001
--Atualizado   : 08.08.2001 - Inclusao do campo dt_usuario na inserçao - Elias
-----------------------------------------------------------------------------------
CREATE procedure pr_InsMovCone
@dt_movimento_cone datetime,
@cd_Cone int,
@cd_movimento int,
@cd_grupo_ferramenta int,
@cd_ferramenta int,
@cd_maquina int,
@cd_tipo_movimento int,
@qt_dia_operacao_cone int,
@cd_usuario int
as
 Insert into Movimento_Cone
            ( dt_movimento_cone,
              cd_Cone,
              cd_movimento,
              cd_grupo_ferramenta,
              cd_ferramenta,
              cd_maquina,
              cd_tipo_movimento,
              qt_dia_operacao_cone,
              cd_usuario,
              dt_usuario )
     values ( @dt_movimento_cone,
              @cd_Cone,
              @cd_movimento,
              @cd_grupo_ferramenta,
              @cd_ferramenta,
              @cd_maquina,
              @cd_tipo_movimento,
              @qt_dia_operacao_cone,
              @cd_usuario,
              getDate())


