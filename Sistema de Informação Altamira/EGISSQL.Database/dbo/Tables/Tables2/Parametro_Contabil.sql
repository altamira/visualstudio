CREATE TABLE [dbo].[Parametro_Contabil] (
    [cd_empresa]                INT      NOT NULL,
    [cd_exercicio]              INT      NOT NULL,
    [dt_inicial_exercicio]      DATETIME NOT NULL,
    [dt_final_exercicio]        DATETIME NOT NULL,
    [ic_plano_gerado]           CHAR (1) NOT NULL,
    [ic_exercicio_ativo]        CHAR (1) NOT NULL,
    [ic_exercicio_aberto]       CHAR (1) NOT NULL,
    [ic_lote_fechado]           CHAR (1) NOT NULL,
    [ic_movimento_atualizado]   CHAR (1) NOT NULL,
    [ic_exercicio_encerrado]    CHAR (1) NOT NULL,
    [cd_usuario]                INT      NOT NULL,
    [dt_usuario]                DATETIME NOT NULL,
    [qt_pagina_diario]          INT      NULL,
    [qt_sequencia_diario]       INT      NULL,
    [ic_contab_automatica]      CHAR (1) NULL,
    [ic_altera_reduzido_plano]  CHAR (1) NULL,
    [cd_conta_resultado]        INT      NULL,
    [cd_historico_resultado]    INT      NULL,
    [cd_conta_apuracao]         INT      NULL,
    [cd_historico_apuracao]     INT      NULL,
    [qt_pagina_balanco_empresa] INT      NULL,
    [qt_grau_balanco_empresa]   INT      NULL,
    [cd_conta_passivo]          INT      NULL,
    [ic_sinal_credito_empresa]  CHAR (1) NULL,
    [ic_assinatura_balanco]     CHAR (1) NULL,
    [cd_conta_receita]          INT      NULL,
    [cd_conta_despesa]          INT      NULL,
    [cd_conta_ir]               INT      NULL,
    [cd_conta_cont_social]      INT      NULL,
    [qt_pagina_dre_empresa]     INT      NULL,
    [ic_altera_c_custo_receita] CHAR (1) NULL,
    [ic_venda_sem_lista]        CHAR (1) NULL,
    [cd_quantidade_nivel]       INT      NULL,
    [cd_conta_LP]               INT      NULL,
    [ic_exercicio_fechado]      CHAR (1) NULL,
    [ic_desp_rec_exercicio]     CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_contabil] PRIMARY KEY NONCLUSTERED ([cd_empresa] ASC, [cd_exercicio] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_parametro_contabil
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Rotina de Exclusao de Parametro Contábil
--Data        :   18/06/2001
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_parametro_contabil on Parametro_contabil
for delete
as
begin
  declare @cd_empresa int
  declare @cd_exercicio int
  select 
    @cd_empresa = cd_empresa, 
    @cd_exercicio = cd_exercicio
  from 
    deleted
  if exists(select
              cd_lote
            from
              Lote_contabil
            where
              cd_empresa = @cd_empresa and
              cd_exercicio = @cd_exercicio)
    begin
      raiserror('Deleçao nao Permitida. Existem Lotes Criados neste Exercício.',16,1)
      rollback transaction
    end
end
