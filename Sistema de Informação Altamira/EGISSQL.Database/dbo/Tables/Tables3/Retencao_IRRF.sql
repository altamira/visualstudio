CREATE TABLE [dbo].[Retencao_IRRF] (
    [cd_retencao_irrf]          INT          NOT NULL,
    [nm_rentecao_irrf]          VARCHAR (60) NULL,
    [sg_retencao_irrf]          CHAR (10)    NULL,
    [cd_identificacao_retencao] VARCHAR (10) NULL,
    [ds_retencao_irrf]          TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Retencao_IRRF] PRIMARY KEY CLUSTERED ([cd_retencao_irrf] ASC) WITH (FILLFACTOR = 90)
);

