CREATE TABLE [dbo].[Remessa_Viagem_Parcela_Recebimento] (
    [cd_remessa_viagem]             INT           NOT NULL,
    [cd_parcela_viagem_recebimento] INT           NOT NULL,
    [cd_identificacao_parcela]      VARCHAR (30)  NULL,
    [dt_vencimento_remessa]         DATETIME      NULL,
    [vl_parcela_remessa]            FLOAT (53)    NULL,
    [nm_parcela_remessa]            VARCHAR (100) NULL,
    [cd_documento_receber]          INT           NULL,
    [cd_usuario]                    INT           NULL,
    [dt_usuario]                    DATETIME      NULL,
    [cd_cliente]                    INT           NULL,
    CONSTRAINT [PK_Remessa_Viagem_Parcela_Recebimento] PRIMARY KEY CLUSTERED ([cd_remessa_viagem] ASC, [cd_parcela_viagem_recebimento] ASC) WITH (FILLFACTOR = 90)
);

