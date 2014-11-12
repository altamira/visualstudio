CREATE TABLE [dbo].[Composicao_Despesa_Operacional] (
    [cd_despesa_operacional]  INT          NOT NULL,
    [cd_item_despesa_operac]  INT          NOT NULL,
    [cd_tipo_despesa]         INT          NULL,
    [vl_item_despesa_operac]  FLOAT (53)   NULL,
    [nm_obs_d  espesa_operac] VARCHAR (40) NULL,
    [cd_visita]               INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Composicao_Despesa_Operacional] PRIMARY KEY CLUSTERED ([cd_despesa_operacional] ASC, [cd_item_despesa_operac] ASC) WITH (FILLFACTOR = 90)
);

