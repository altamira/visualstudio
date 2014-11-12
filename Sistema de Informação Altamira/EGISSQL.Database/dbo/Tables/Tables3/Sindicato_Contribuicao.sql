CREATE TABLE [dbo].[Sindicato_Contribuicao] (
    [cd_sindicato]              INT          NOT NULL,
    [cd_item_sindicato]         INT          NOT NULL,
    [dt_contribuicao_sindicato] DATETIME     NOT NULL,
    [pc_contribuicao_sindicato] FLOAT (53)   NULL,
    [vl_teto_contribuicao_sind] MONEY        NULL,
    [nm_obs_contribuicao_sind]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Sindicato_Contribuicao] PRIMARY KEY CLUSTERED ([cd_sindicato] ASC, [cd_item_sindicato] ASC) WITH (FILLFACTOR = 90)
);

