CREATE TABLE [dbo].[Di_Item] (
    [cd_di]                      INT          NOT NULL,
    [cd_di_item]                 INT          NOT NULL,
    [cd_produto]                 INT          NOT NULL,
    [qt_embarque]                FLOAT (53)   NULL,
    [qt_efetiva_chegada]         FLOAT (53)   NULL,
    [vl_produto_moeda_destino]   FLOAT (53)   NULL,
    [vl_produto_moeda_origem]    FLOAT (53)   NULL,
    [cd_importador]              INT          NULL,
    [cd_tipo_embalagem]          INT          NULL,
    [dt_prevista_embarque]       DATETIME     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [pc_di_item_ii]              FLOAT (53)   NULL,
    [pc_di_item_ipi]             FLOAT (53)   NULL,
    [pc_di_item_icms]            FLOAT (53)   NULL,
    [pc_di_item_red_base]        FLOAT (53)   NULL,
    [ic_di_item_rateio_ipi]      CHAR (1)     NULL,
    [ic_di_item_rateio_icms]     CHAR (1)     NULL,
    [cd_pedido_importacao]       INT          NULL,
    [cd_item_ped_imp]            INT          NULL,
    [cd_origem_importacao]       INT          NULL,
    [qt_peso_liq_item_di]        FLOAT (53)   NULL,
    [qt_peso_bruto_item_di]      FLOAT (53)   NULL,
    [nm_obs_item_di]             VARCHAR (60) NULL,
    [cd_invoice]                 INT          NULL,
    [cd_invoice_item]            INT          NULL,
    [ID]                         INT          NULL,
    [cd_adicao_item_di]          INT          NULL,
    [cd_sequencia_adicao]        INT          NULL,
    [vl_total_moeda_destino]     FLOAT (53)   NULL,
    [vl_ipi_item_di]             FLOAT (53)   NULL,
    [vl_total_ipi_item_di]       FLOAT (53)   NULL,
    [vl_ii_item_di]              FLOAT (53)   NULL,
    [vl_total_ii_item_di]        FLOAT (53)   NULL,
    [vl_pis_item_di]             FLOAT (53)   NULL,
    [vl_total_pis_item_di]       FLOAT (53)   NULL,
    [vl_cof_item_di]             FLOAT (53)   NULL,
    [vl_total_cof_item_di]       FLOAT (53)   NULL,
    [vl_sis_item_di]             FLOAT (53)   NULL,
    [vl_total_sis_item_di]       FLOAT (53)   NULL,
    [pc_di_item_pis]             FLOAT (53)   NULL,
    [pc_di_item_cof]             FLOAT (53)   NULL,
    [pc_red_icms_item_di]        FLOAT (53)   NULL,
    [vl_icms_item_di]            FLOAT (53)   NULL,
    [vl_total_icms_item_di]      FLOAT (53)   NULL,
    [vl_total_moeda_origem]      FLOAT (53)   NULL,
    [vl_frete_item_di]           FLOAT (53)   NULL,
    [vl_total_capatazia_item_di] FLOAT (53)   NULL,
    [vl_capatazia_item_di]       FLOAT (53)   NULL,
    [vl_seguro_item_di]          FLOAT (53)   NULL,
    [vl_total_seguro_item_di]    FLOAT (53)   NULL,
    [vl_total_frete_item_si]     FLOAT (53)   NULL,
    [vl_cfr_item_di]             FLOAT (53)   NULL,
    [vl_item_pos1]               FLOAT (53)   NULL,
    [vl_item_pos2]               FLOAT (53)   NULL,
    [vl_total_pos1]              FLOAT (53)   NULL,
    [vl_total_pos2]              FLOAT (53)   NULL,
    CONSTRAINT [PK_Di_Item] PRIMARY KEY CLUSTERED ([cd_di] ASC, [cd_di_item] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Di_Item_Importador] FOREIGN KEY ([cd_importador]) REFERENCES [dbo].[Importador] ([cd_importador])
);


GO
create trigger ti_atualiza_id_di_item
on DI_ITEM
after insert

as

--ti_atualiza_id_di_item
--------------------------------------------------------------------
--GBS - Global Business Solution	       2005
--Trigger: Microsoft SQL Server          2000
--Autor(es): Paulo Souza
--Banco de Dados: EGISSQL
--Objetivo: Trigger para atualização da coluna ID na tabela DI_ITEM
--Data: 10/01/2005
--------------------------------------------------------------------

begin

Declare @ID as Int

Select @Id = Max(ID) + 1 
From di_item

Update di_item set di_item.ID = @ID
From di_item dii, inserted i
where dii.cd_di = i.cd_di and
      dii.cd_di_item = i.cd_di_item

end

