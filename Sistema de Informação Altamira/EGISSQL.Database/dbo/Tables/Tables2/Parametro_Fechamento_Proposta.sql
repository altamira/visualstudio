CREATE TABLE [dbo].[Parametro_Fechamento_Proposta] (
    [cd_empresa]             INT      NOT NULL,
    [cd_departamento]        INT      NULL,
    [ic_subs_tributaria]     CHAR (1) NULL,
    [ic_operacao_triangular] CHAR (1) NULL,
    [ic_amostra]             CHAR (1) NULL,
    [ic_consignacao]         CHAR (1) NULL,
    [ic_icms]                CHAR (1) NULL,
    [ic_cambio]              CHAR (1) NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    [ic_smo]                 CHAR (1) NULL,
    [ic_entrega_futura]      CHAR (1) NULL,
    [ic_agrupar_pedido]      CHAR (1) NULL,
    [ic_pedido_origem]       CHAR (1) NULL,
    [ic_bonificacao]         CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Fechamento_Proposta] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Fechamento_Proposta_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

