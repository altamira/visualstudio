

/****** Object:  Stored Procedure dbo.pr_InsMovLog    Script Date: 13/12/2002 15:08:10 ******/
--pr_movimentacao
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton
--Inserçao na tabela de movimentaçao de cones
--Data         : 20.03.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_InsMovLog
@dt_log datetime,
@cd_movimento int,
@cd_cone int,
@cd_grupo_ferramenta int,
@cd_ferramenta int,
@cd_maquina int,
@nm_mensagem char(120),
@cd_usuario int
as
 Insert into LogErroFerNet
            ( dt_log,
              cd_movimento,
              cd_cone,
              cd_grupo_ferramenta,
              cd_ferramenta,
              cd_maquina,
              nm_mensagem,
              cd_usuario )
     values ( @dt_log,
              @cd_movimento,
              @cd_cone,
              @cd_grupo_ferramenta,
              @cd_ferramenta,
              @cd_maquina,
              @nm_mensagem,
              @cd_usuario)


