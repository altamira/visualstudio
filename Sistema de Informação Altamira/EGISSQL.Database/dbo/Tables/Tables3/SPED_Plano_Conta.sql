CREATE TABLE [dbo].[SPED_Plano_Conta] (
    [cd_controle]  INT          NOT NULL,
    [cd_plano]     INT          NULL,
    [cd_conta]     INT          NULL,
    [nm_obs_conta] VARCHAR (60) NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_SPED_Plano_Conta] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);

