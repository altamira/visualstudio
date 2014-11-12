CREATE TABLE [dbo].[Imposto] (
    [cd_imposto]                INT           NOT NULL,
    [nm_imposto]                VARCHAR (30)  NOT NULL,
    [sg_imposto]                CHAR (10)     NOT NULL,
    [cd_usuario]                INT           NOT NULL,
    [dt_usuario]                DATETIME      NOT NULL,
    [ic_nota_imposto]           CHAR (1)      NULL,
    [cd_ordem_nota_imposto]     INT           NULL,
    [ic_gera_scp_imposto]       CHAR (1)      NULL,
    [ic_retencao_nota_imposto]  CHAR (1)      NULL,
    [qt_dia_pagto_imposto]      INT           NULL,
    [ic_tipo_pagamento_imposto] CHAR (1)      NULL,
    [nm_imposto_mastersaf]      VARCHAR (120) NULL,
    [cd_imposto_mastersaf]      INT           NULL,
    [cd_darf_codigo]            INT           NULL,
    [cd_receita_tributo]        INT           NULL,
    [cd_imposto_especificacao]  INT           NULL,
    [ic_vencimento_imposto]     CHAR (1)      NULL,
    [ic_geracao_darf_imposto]   CHAR (1)      NULL,
    [vl_teto_imposto]           FLOAT (53)    NULL,
    CONSTRAINT [PK_Imposto] PRIMARY KEY CLUSTERED ([cd_imposto] ASC) WITH (FILLFACTOR = 90)
);


GO
--tr_apagar_imposto
-------------------------------------------------------------------------
--Polimold Industrial S/A                           2001
--Trigger : SQL Server Microsoft 7.0
--Elias Pereira da Silva
--Não permite a exclusão de qualquer imposto (Tabela Fixa)
--Data        : 09/05/2002
--Atualizaçao :
-------------------------------------------------------------------------
create trigger tr_apagar_imposto on Imposto
for delete
as

  raiserror('Não é permitido excluir qualquer Imposto!', 16,1)

