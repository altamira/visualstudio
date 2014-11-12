CREATE TABLE [dbo].[Laudo_Padrao] (
    [cd_laudo_padrao]               INT          NOT NULL,
    [nm_laudo_padrao]               VARCHAR (60) NULL,
    [cd_identificacao_laudo_padrao] VARCHAR (15) NULL,
    [ds_laudo_padrao]               TEXT         NULL,
    [nm_obs_laudo_padrao]           VARCHAR (40) NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    CONSTRAINT [PK_Laudo_Padrao] PRIMARY KEY CLUSTERED ([cd_laudo_padrao] ASC) WITH (FILLFACTOR = 90)
);

