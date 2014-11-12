CREATE TABLE [dbo].[Ato_Concessorio] (
    [cd_ato_concessorio]     INT          NOT NULL,
    [cd_ref_ato_concessorio] VARCHAR (15) NULL,
    [dt_emissao_ato]         DATETIME     NULL,
    [dt_validade_ato]        DATETIME     NULL,
    [nm_obs_ato]             VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Ato_Concessorio] PRIMARY KEY CLUSTERED ([cd_ato_concessorio] ASC) WITH (FILLFACTOR = 90)
);

