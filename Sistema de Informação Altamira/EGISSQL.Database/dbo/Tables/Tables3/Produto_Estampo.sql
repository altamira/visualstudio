CREATE TABLE [dbo].[Produto_Estampo] (
    [cd_produto_estampo]          INT          NOT NULL,
    [cd_produto]                  INT          NOT NULL,
    [cd_codificacao_produto]      VARCHAR (25) NULL,
    [nm_fantasia_produto_estampo] VARCHAR (25) NULL,
    [nm_produto_estampo]          VARCHAR (50) NULL,
    [qt_diametro_interno]         FLOAT (53)   NULL,
    [qt_diametro_externo]         FLOAT (53)   NULL,
    [qt_espessura]                FLOAT (53)   NULL,
    [qt_altura]                   FLOAT (53)   NULL,
    [qt_tol_diametro_interno]     FLOAT (53)   NULL,
    [qt_tol_diametro_externo]     FLOAT (53)   NULL,
    [qt_tol_espessura]            FLOAT (53)   NULL,
    [qt_tol_altura]               FLOAT (53)   NULL,
    [cd_mat_prima]                INT          NOT NULL,
    [cd_tratamento_produto]       INT          NULL,
    [cd_acabamento_produto]       INT          NULL,
    [ds_especificacao_produto]    TEXT         NULL,
    [qt_producao_anterior]        FLOAT (53)   NULL,
    [cd_unidade_medida]           INT          NULL,
    [cd_estampo]                  INT          NULL,
    [qt_minimo_produto]           FLOAT (53)   NULL,
    [qt_producao]                 FLOAT (53)   NULL,
    [vl_referencia_produto]       FLOAT (53)   NULL,
    [qt_prazo_fabricacao]         FLOAT (53)   NULL,
    [nm_endereco_produto]         VARCHAR (30) NULL,
    [nm_obs_produto]              VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [qt_produto_kg]               FLOAT (53)   NULL,
    [cd_cliente]                  INT          NULL,
    [qt_capacidade_producao]      FLOAT (53)   NULL,
    [qt_economica_producao]       FLOAT (53)   NULL,
    [qt_maxi_economica]           FLOAT (53)   NULL,
    [ic_sucata]                   CHAR (1)     NULL,
    [ic_frete]                    CHAR (1)     NULL,
    [vl_frete]                    FLOAT (53)   NULL,
    [ic_montagem]                 CHAR (1)     NULL,
    [ic_custo_ferramenta]         CHAR (1)     NULL,
    [qt_aproveitamento]           FLOAT (53)   NULL,
    [qt_blank_produto]            FLOAT (53)   NULL,
    [qt_sucata_produto]           FLOAT (53)   NULL,
    [qt_peso_produto]             FLOAT (53)   NULL,
    [qt_area_produto]             FLOAT (53)   NULL,
    [qt_mat_prima_produto]        FLOAT (53)   NULL,
    [qt_bruto_produto]            FLOAT (53)   NULL,
    [qt_liquido_produto]          FLOAT (53)   NULL,
    [qt_hora_montagem]            FLOAT (53)   NULL,
    [qt_maquina_producao]         INT          NULL,
    [cd_maquina]                  INT          NULL,
    [pc_queda_producao]           FLOAT (53)   NULL,
    [dt_entrega_prevista]         DATETIME     NULL,
    [dt_disponibilidade_maquina]  DATETIME     NULL,
    [qt_producao_diaria]          FLOAT (53)   NULL,
    [qt_peso_bruto_diario]        FLOAT (53)   NULL,
    [pc_miolo]                    FLOAT (53)   NULL,
    [qt_peso_diario]              FLOAT (53)   NULL,
    [qt_tonelagem_corte]          FLOAT (53)   NULL,
    [qt_tonelagem_corte_ext]      FLOAT (53)   NULL,
    [vl_compra_material]          FLOAT (53)   NULL,
    [vl_sucata_produto]           FLOAT (53)   NULL,
    [vl_custo_material]           FLOAT (53)   NULL,
    [vl_produto]                  FLOAT (53)   NULL,
    [vl_cento_produto]            FLOAT (53)   NULL,
    [vl_milheiro_produto]         FLOAT (53)   NULL,
    [vl_total_produto]            FLOAT (53)   NULL,
    [vl_lucro_produto]            FLOAT (53)   NULL,
    [vl_custo_materia_prima]      FLOAT (53)   NULL,
    [vl_custo_sucata]             FLOAT (53)   NULL,
    [vl_ferramental_produto]      FLOAT (53)   NULL,
    [vl_frete_produto]            FLOAT (53)   NULL,
    [vl_tratamento_produto]       FLOAT (53)   NULL,
    [vl_acabamento_produto]       FLOAT (53)   NULL,
    [cd_consulta]                 INT          NULL,
    [cd_item_consulta]            INT          NULL,
    [cd_tipo_lucro]               INT          NULL,
    [cd_aplicacao_markup]         INT          NULL,
    [vl_orcamento_produto]        FLOAT (53)   NULL,
    [cd_unidade_mat_prima]        INT          NULL,
    [cd_produto_mat_prima]        INT          NULL,
    [ic_cadastro_produto]         CHAR (1)     NULL,
    [cd_sucata]                   INT          NULL,
    [vl_sucata]                   FLOAT (53)   NULL,
    [dt_produto_estampo]          DATETIME     NULL,
    [vl_produto_estampo]          FLOAT (53)   NULL,
    [vl_produto_negociado]        FLOAT (53)   NULL,
    CONSTRAINT [PK_Produto_Estampo] PRIMARY KEY CLUSTERED ([cd_produto_estampo] ASC) WITH (FILLFACTOR = 90)
);


GO

CREATE TRIGGER ti_produto_estampo
ON Produto_Estampo
after insert
AS 
BEGIN
-- Caso seja para Inserir

	Declare @cd_cliente as int
	Declare @cd_produto as int

	Select 
		@cd_cliente = isnull(cd_cliente,0),
		@cd_produto = isnull(cd_produto,0)
	from
		Inserted

	if (@cd_produto > 0 and @cd_cliente > 0) and
		(not exists(Select top 1 * From Produto_Cliente pc where cd_produto = @cd_produto and cd_cliente = @cd_cliente))
	begin
			Insert into Produto_Cliente
			Select
				cd_cliente,
				cd_produto,
				nm_fantasia_produto_estampo as nm_fantasia_prod_cliente,
				'S' as ic_proposta_prod_cliente,
				'S' as ic_ped_vend_prod_cliente,
				'S' as ic_nf_produto_cliente,
				nm_produto_estampo as nm_produto_cliente,
				'N' as ic_desc_produto_cliente,
				nm_obs_produto as nm_obs_produto_cliente,
				cd_usuario,
				dt_usuario,
				1 as cd_moeda,
				vl_referencia_produto as vl_produto_cliente,
				cast(null as Datetime) as dt_preco_produto_cliente,
				Cast(null as int) as cd_termo_comercial,
				Cast(null as int) as cd_tabela_preco,
				Cast(null as int) as cd_aplicacao_markup,
				qt_minimo_produto as qt_minimo_produto_cliente
			from 
				inserted 
	end
END

GO

CREATE TRIGGER tu_produto_estampo
ON Produto_Estampo
after UPDATE
AS 
BEGIN
-- Caso seja para Inserir

	Declare @cd_cliente as int
	Declare @cd_produto as int
	Declare @nm_fantasia_prod_cliente as varchar(50)
	Declare @nm_produto_cliente       as varchar(50)
	Declare @nm_obs_produto_cliente   as varchar(50)
	Declare @cd_usuario as int
	Declare @dt_usuario as datetime
	Declare @vl_produto_cliente as float
	Declare @qt_minimo_produto_cliente as float

	Select 
		@cd_cliente                = isnull(cd_cliente,0),
		@cd_produto                = isnull(cd_produto,0),
		@nm_fantasia_prod_cliente  = nm_fantasia_produto_estampo ,
		@nm_produto_cliente        = nm_produto_estampo,
		@nm_obs_produto_cliente    = nm_obs_produto,
		@cd_usuario                = cd_usuario,
		@dt_usuario                = dt_usuario,
		@vl_produto_cliente        = vl_referencia_produto, 
		@qt_minimo_produto_cliente = qt_minimo_produto
	from
		Inserted

	if (@cd_produto > 0 and @cd_cliente > 0) and
		(exists(Select top 1 * From Produto_Cliente pc where cd_produto = @cd_produto and cd_cliente = @cd_cliente))
	begin
			Update Produto_Cliente
			Set
				nm_fantasia_prod_cliente  = @nm_fantasia_prod_cliente,
				nm_produto_cliente        = @nm_produto_cliente,
				nm_obs_produto_cliente    = @nm_obs_produto_cliente,
				cd_usuario                = @cd_usuario,
				dt_usuario                = @dt_usuario,
				vl_produto_cliente        = @vl_produto_cliente,
				qt_minimo_produto_cliente = @qt_minimo_produto_cliente
			where
				cd_produto = @cd_produto and cd_cliente = @cd_cliente

	end
END

GO

CREATE TRIGGER td_produto_estampo
ON Produto_Estampo
after DELETE
AS 
BEGIN
-- Caso seja para Inserir

	Declare @cd_cliente as int
	Declare @cd_produto as int

	Select 
		@cd_cliente                = isnull(cd_cliente,0),
		@cd_produto                = isnull(cd_produto,0)
	from
		Deleted

	if (@cd_produto > 0 and @cd_cliente > 0) and
		(exists(Select top 1 * From Produto_Cliente pc where cd_produto = @cd_produto and cd_cliente = @cd_cliente))
	begin
			Delete From
				Produto_Cliente 
			where
				cd_produto = @cd_produto and cd_cliente = @cd_cliente

	end
END
