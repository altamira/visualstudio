CREATE TABLE [dbo].[Regional_Venda] (
    [cd_regional_venda]         INT          NOT NULL,
    [nm_regional_venda]         VARCHAR (40) NULL,
    [sg_identificacao_regional] CHAR (10)    NULL,
    [nm_fantasia_regional]      VARCHAR (15) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Regional_Venda] PRIMARY KEY CLUSTERED ([cd_regional_venda] ASC) WITH (FILLFACTOR = 90)
);

