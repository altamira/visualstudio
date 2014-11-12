
CREATE PROCEDURE pr_ParametroEmpresa 
	@cd_empresa	int,
	@aa_exercicio_empresa	int,
	@cd_nota_fiscal_saida	int,
	@cd_nota_fiscal_entrada	int,
	@cd_nota_fiscal_servico	int,
	@vl_faturamento_minimo	money,
	@vl_faturamento_maximo	money,
	@ds_cartorio_empresa	text,
	@nm_inscricao_municipal	varchar,
	@cd_contador	int,
	@cd_usuario_atualiza	int,
	@dt_atualiza	datetime,
	@cd_fornecedor_empresa	int,
	@cd_requisicao_compra_empresa	int,
	@cd_cotacao_empresa	int,
	@cd_pedido_compra_empresa	int,
	@cd_fmedida_empresa	int,
	@cd_ult_nf_entrada_empresa	int,
	@cd_carta_correcao_empresa	int,
	@cd_rem_empresa	int,
	@cd_rena_empresa	int,
	@cd_cliente_empresa	int,
	@cd_consulta_empresa	int,
	@cd_cocorrencia_empresa	int,
	@cd_pedido_venda	int,
	@cd_processo_fab_empresa	int,
	@cd_ult_nf_saida_empresa	int,
	@cd_req_faturamento_empresa	int,
	@cd_previa_fat_empresa	int,
	@cd_os_assist_tec_empresa	int,
	@cd_lancamento_estoque	int,
	@cd_consulta_assitatura	int,
	@ic_tipo_proposta	char(1),
	@ic_obs_cotacao_empresa	char(1),
	@ds_obs_cotacao_empresa	varchar(60),
	@ic_frete_cotacao_empresa	char(1)
AS
Begin
    --Variáveis para enviar as mensagens de erro caso o mesmo ocorra
    declare @errno int, --Número do erro
            @errmsg varchar(255) --Menssagem do erro
    /* Edita o registro da tabela Parametro empresa uma vez que o parâmetros da empresa já é cadastrado pela trigger do sistema */  
   Begin Transaction --Inicializa a transaçao   
   Update Parametro_Empresa set   
    aa_exercicio_empresa = @aa_exercicio_empresa , cd_nota_fiscal_saida = @cd_nota_fiscal_saida, cd_nota_fiscal_entrada = @cd_nota_fiscal_entrada, 
    cd_nota_fiscal_servico = @cd_nota_fiscal_servico, vl_faturamento_minimo = @vl_faturamento_minimo, vl_faturamento_maximo = @vl_faturamento_maximo, 
    ds_cartorio_empresa = @ds_cartorio_empresa, nm_inscricao_municipal = @nm_inscricao_municipal, cd_contador = @cd_contador, cd_usuario_atualiza = @cd_usuario_atualiza, 
    dt_atualiza = @dt_atualiza, cd_fornecedor_empresa = @cd_fornecedor_empresa, cd_requisicao_compra_empresa = @cd_requisicao_compra_empresa, cd_cotacao_empresa = @cd_cotacao_empresa, 
    cd_pedido_compra_empresa = @cd_pedido_compra_empresa, cd_fmedida_empresa = @cd_fmedida_empresa, cd_ult_nf_entrada_empresa = @cd_ult_nf_entrada_empresa, 
    cd_carta_correcao_empresa = @cd_carta_correcao_empresa, cd_rem_empresa = @cd_rem_empresa, cd_rena_empresa = @cd_rena_empresa, cd_cliente_empresa = @cd_cliente_empresa,
    cd_consulta_empresa = @cd_consulta_empresa, cd_cocorrencia_empresa = @cd_cocorrencia_empresa, cd_pedido_venda = @cd_pedido_venda, cd_processo_fab_empresa = @cd_processo_fab_empresa,
    cd_ult_nf_saida_empresa = @cd_ult_nf_saida_empresa, cd_req_faturamento_empresa = @cd_req_faturamento_empresa, cd_previa_fat_empresa = @cd_previa_fat_empresa,
    cd_os_assist_tec_empresa = @cd_os_assist_tec_empresa,
    cd_lancamento_estoque = @cd_lancamento_estoque,
    cd_consulta_assitatura = @cd_consulta_assitatura,
    ic_tipo_proposta = @ic_tipo_proposta,
    ic_obs_cotacao_empresa = @ic_obs_cotacao_empresa,
    ds_obs_cotacao_empresa = @ds_obs_cotacao_empresa,
    ic_frete_cotacao_empresa = @ic_frete_cotacao_empresa
   where     
    cd_empresa = @cd_empresa
    if @@error != 0 begin --Verifica se nao ocorreu nenhum erro
              select @errno  = 30002,
             @errmsg = 'SapAdmin - Nao foi possível editar os parâmetros da empresa , verifique se está tudo de acordo na base de dados'
              goto error
   end else
           Commit Transaction --Confirma a transaçao   
  return --Retorna sem passa pela rotina de tratamento de erro
error:
    raiserror @errno @errmsg --gera uma exceçao a ser enviada
    rollback transaction --Cancela a transaçao
end
	

