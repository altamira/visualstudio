
CREATE PROCEDURE pr_plano_financeiro_lancamento_manutencao
  @opcao char(1),
  @cd_movimento int,
  @dt_movto_plano_financeiro DateTime,
  @vl_plano_financeiro float,
  @nm_historico_movimento char(18),
  @cd_plano_financeiro int,
  @cd_tipo_lancamento_fluxo int,
  @cd_historico_financeiro int,
  @cd_tipo_operacao int,
  @cd_moeda int,
  @cd_usuario int
AS
  begin transaction

  If @opcao = 'D' Begin
    Delete From Plano_Financeiro_Movimento
    Where cd_movimento = @cd_movimento
  End Else
  If @opcao = 'I' Begin
    Insert Into Plano_Financeiro_Movimento
      (cd_movimento,
       dt_movto_plano_financeiro,
       vl_plano_financeiro,
       nm_historico_movimento,
       cd_plano_financeiro,
       cd_tipo_lancamento_fluxo,
       cd_historico_financeiro,
       cd_tipo_operacao,
       cd_moeda,
       cd_usuario,
       dt_usuario)
    Values
      (@cd_movimento,
       @dt_movto_plano_financeiro,
       @vl_plano_financeiro,
       @nm_historico_movimento,
       @cd_plano_financeiro,
       @cd_tipo_lancamento_fluxo,
       @cd_historico_financeiro,
       @cd_tipo_operacao,
       @cd_moeda,
       @cd_usuario,
       GetDate())
  End Else
  If @opcao = 'U' Begin--Update 
    Update Plano_Financeiro_Movimento
    set cd_movimento = @cd_movimento,
        dt_movto_plano_financeiro = @dt_movto_plano_financeiro,
        vl_plano_financeiro = @vl_plano_financeiro,
        nm_historico_movimento = @nm_historico_movimento,
        cd_plano_financeiro = @cd_plano_financeiro,
        cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo,
        cd_historico_financeiro = @cd_historico_financeiro,
        cd_tipo_operacao = @cd_tipo_operacao,
        cd_moeda = @cd_moeda,
        cd_usuario = @cd_usuario,
        dt_usuario = GetDate()
    Where cd_movimento = @cd_movimento
  End


  If @@ERROR = 0
    Commit Transaction
  Else Begin
    RollBack Transaction
    Return
  End

