CREATE TABLE [dbo].[Origem_Plano_MRP] (
    [cd_origem_plano_mrp] INT          NOT NULL,
    [nm_origem_plano_mrp] VARCHAR (50) NULL,
    [sg_origem_plano_mrp] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ic_carteira_origem]  CHAR (1)     NULL,
    [ic_previsao_origem]  CHAR (1)     NULL,
    CONSTRAINT [PK_Origem_Plano_MRP] PRIMARY KEY CLUSTERED ([cd_origem_plano_mrp] ASC) WITH (FILLFACTOR = 90)
);

