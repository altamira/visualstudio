CREATE TABLE [dbo].[Caixa_Lancamento] (
    [cd_lancamento_caixa]      INT          NOT NULL,
    [cd_tipo_operacao]         INT          NOT NULL,
    [dt_lancamento_caixa]      DATETIME     NULL,
    [vl_lancamento_caixa]      FLOAT (53)   NULL,
    [cd_documento_lancamento]  VARCHAR (20) NULL,
    [nm_historico_lancamento]  VARCHAR (40) NULL,
    [cd_tipo_caixa]            INT          NULL,
    [cd_plano_financeiro]      INT          NULL,
    [cd_historico_financeiro]  INT          NULL,
    [cd_moeda]                 INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_lancamento_padrao]     INT          NULL,
    [cd_conta]                 INT          NULL,
    [cd_conta_debito]          INT          NULL,
    [cd_conta_credito]         INT          NULL,
    [dt_contabilizacao]        DATETIME     NULL,
    [cd_lancamento_contabil]   INT          NULL,
    [cd_lote]                  INT          NULL,
    [cd_documento]             INT          NULL,
    [cd_documento_baixa]       INT          NULL,
    [ic_lancamento_conciliado] CHAR (1)     NULL,
    [cd_tipo_lancamento_fluxo] INT          NULL,
    [vl_cotacao_moeda]         FLOAT (53)   NULL,
    [dt_cotacao_moeda]         DATETIME     NULL,
    [cd_requisicao_viagem]     INT          NULL,
    [cd_solicitacao]           INT          NULL,
    [cd_prestacao]             INT          NULL,
    [cd_ap]                    INT          NULL,
    [vl_caixa_moeda]           FLOAT (53)   NULL,
    [nm_obs_caixa_lancamento]  VARCHAR (80) NULL,
    CONSTRAINT [PK_Caixa_Lancamento] PRIMARY KEY CLUSTERED ([cd_lancamento_caixa] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE TRIGGER tr_caixa_lancamento_insercao
ON dbo.Caixa_Lancamento
After Insert, update
AS
  Declare @cd_plano_financeiro  int
  Declare @dt_lancamento_caixa  dateTime
  Declare @cd_moeda             int
  Declare @cd_tipo_caixa        int
  Declare @usuario              int

  select 
    @cd_plano_financeiro = cd_plano_financeiro,
    @cd_moeda            = cd_moeda,
    @cd_tipo_caixa       = cd_tipo_caixa,
    @dt_lancamento_caixa = dt_lancamento_caixa,
    @usuario             = cd_usuario
  from
    Inserted

  exec pr_atualiza_valor_caixa_saldo @cd_plano_financeiro, @dt_lancamento_caixa, @cd_moeda, @cd_tipo_caixa, @usuario

GO
CREATE TRIGGER tr_caixa_lancamento_delete
ON dbo.Caixa_Lancamento
After Delete
AS
Begin

  Declare @cd_plano_financeiro  int
  Declare @dt_lancamento_caixa  DateTime
  Declare @cd_moeda             int
  Declare @cd_tipo_caixa        int
  Declare @usuario              int

  select 
    @cd_plano_financeiro = cd_plano_financeiro,
    @cd_moeda            = cd_moeda,
    @cd_tipo_caixa       = cd_tipo_caixa,
    @dt_lancamento_caixa = dt_lancamento_caixa,
    @usuario             = cd_usuario
  from
    deleted

  exec pr_atualiza_valor_caixa_saldo @cd_plano_financeiro, @dt_lancamento_caixa, @cd_moeda, @cd_tipo_caixa, @usuario

end
