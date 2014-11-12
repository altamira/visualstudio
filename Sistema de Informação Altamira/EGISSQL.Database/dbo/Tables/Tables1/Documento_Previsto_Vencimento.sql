CREATE TABLE [dbo].[Documento_Previsto_Vencimento] (
    [cd_documento_previsto]      INT          NOT NULL,
    [cd_item_documento_previsto] INT          NOT NULL,
    [dt_vencimento_previsto]     DATETIME     NULL,
    [vl_vencimento_previsto]     FLOAT (53)   NULL,
    [nm_obs_previsto]            VARCHAR (50) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Documento_Previsto_Vencimento] PRIMARY KEY CLUSTERED ([cd_documento_previsto] ASC, [cd_item_documento_previsto] ASC) WITH (FILLFACTOR = 90)
);

